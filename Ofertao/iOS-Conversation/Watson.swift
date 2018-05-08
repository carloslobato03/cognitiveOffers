
//  Watson.swift
//  Watson Conversation
//
//  Created by Marco Aurélio Bigélli Cardoso on 19/01/17.
//  Copyright © 2017 IBM. All rights reserved.
//

import Foundation
import AVFoundation
import AudioToolbox
import Alamofire
import IBMMobileFirstPlatformFoundation

class Watson: NSObject {
    var isVoiceEnabled = false
    var isTextEnabled = false
    
    weak var delegate: WatsonDelegate?
    
    let speechRecognizer: SpeechRecognizer
    let languageClassifier: LanguageClassifier
    let voiceSynthesizer: VoiceSynthesizer
    let audioSpeaker: AudioSpeaker
        
    var state: WatsonState = .idle {
        didSet {
            delegate?.didChangeState(from: oldValue, to: state)
            if state == .idle {
                nextAction()
            }
        }
    }
    
    var scheduledActions: [WatsonAction] = []
    var lastTranscription = ""
    var lastAnswer = ""
    var lastIntent = ""
    var lastAudio: Data?
    var isAnsweringQuestion = false
    
    // MARK: - Interface
    
    override init() {
        speechRecognizer = NativeSpeechRecognizer()
        
        languageClassifier = LanguageClassifier()
        voiceSynthesizer = WatsonVoiceSynthesizer()
        audioSpeaker = AudioSpeaker()
        super.init()
        speechRecognizer.delegate = self
        languageClassifier.delegate = self
        voiceSynthesizer.delegate = self
        audioSpeaker.delegate = self
    }
    
    deinit {
        print("Watson has deinited")
    }
    
    func prepareAudio(for messages: [String]) {
//        voiceSynthesizer.massSynthesize(texts: messages)
    }
    
    func schedule(_ action: WatsonAction) {
        scheduledActions.append(action)
        if state == .idle {
            nextAction()
        }
    }
    
    func startListening() {
        schedule(RecognitionAction())
        schedule(ClassificationAction())
        schedule(SynthesisAction())
        schedule(SpeechAction())
    }
    
    func mockQuestion(_ question: String) {
        lastTranscription = question
        schedule(ClassificationAction())
        schedule(SynthesisAction())
        schedule(SpeechAction())
    }
    
    func speak(_ text: String) {
        schedule(SynthesisAction(text: text))
        schedule(SpeechAction())
    }
    
    func stop() {
        scheduledActions.removeAll()
        let oldState = state
        state = .idle
        switch oldState {
        case .idle: break
        case .listening: speechRecognizer.cancel()
        case .classifying: languageClassifier.cancel()
        case .synthesizing: voiceSynthesizer.cancel()
        case .speaking: audioSpeaker.cancel()
        }
    }
    
    private func nextAction() {
        if !scheduledActions.isEmpty {
            let action = scheduledActions.first!
            scheduledActions.remove(at: 0)
            
            if action is RecognitionAction {
                speechRecognizer.startRecording()
                
                let metadata = ["": ""];
                WLAnalytics.sharedInstance().log("Recognition Action", withMetadata: metadata);
                WLAnalytics.sharedInstance().send();
                
            } else if action is ClassificationAction {
                guard let data = action.data as? [String: Any?],
                    let question = data["question"] as? String?
                    else { return }
                languageClassifier.classify(text: question ?? lastTranscription)
                
                if self.isTextEnabled {
                    self.delegate?.showUserMessage(text: question ?? lastTranscription)
                }
                
                let strClassify = question ?? lastTranscription
                if !strClassify.isEmpty {
                    let metadata = ["classify": strClassify];
                    WLAnalytics.sharedInstance().log("Classification Action", withMetadata: metadata);
                    WLAnalytics.sharedInstance().send();
                }
            } else if action is SynthesisAction {
                if self.isVoiceEnabled && !self.isTextEnabled {
                    voiceSynthesizer.synthesize(text: action.data as? String ?? lastAnswer)
                    
                }else if !self.isVoiceEnabled && self.isTextEnabled {
                    self.delegate?.showWatsonMessage(text: action.data as? String ?? lastAnswer)
                    self.scheduledActions.removeFirst()
                    self.state = .idle
                    
                }else if self.isVoiceEnabled && self.isTextEnabled {
                    voiceSynthesizer.synthesize(text: action.data as? String ?? lastAnswer)
                    
                    self.delegate?.showWatsonMessage(text: action.data as? String ?? lastAnswer)
                }
                
                let strSynthesize = action.data as? String ?? lastAnswer
                if !strSynthesize.isEmpty {
                    let metadata = ["synthesize": strSynthesize];
                    WLAnalytics.sharedInstance().log("Synthesis Action", withMetadata: metadata);
                    WLAnalytics.sharedInstance().send();
                }
            } else if action is SpeechAction {
                audioSpeaker.play(audio: action.data as? Data ?? lastAudio ?? Data())
                
                let metadata = ["": ""];
                WLAnalytics.sharedInstance().log("Speech Action", withMetadata: metadata);
                WLAnalytics.sharedInstance().send();
            }
        }
    }
}


// MARK: SpeechRecognizerDelegate
extension Watson: SpeechRecognizerDelegate {
    
    func onRecognitionStart() {
        state = .listening
    }
    
    func onRecognitionSuccess(transcription: String) {
        lastTranscription = transcription
        if state == .listening {
            state = .idle
        }
    }
    
    func onRecognitionError(errorDescription: String) {
        self.scheduledActions.removeAll()
        self.stop()
        self.state = .idle
        self.delegate?.didFail(module: "SpeechRecognizer", description: errorDescription)
    }
}

// MARK: - LanguageClassifierDelegate
extension Watson: LanguageClassifierDelegate {

    func onClassificationStart() {
        state = .classifying
    }
    
    func onClassificationSuccess(result: String) {
        lastAnswer = result
        if state == .classifying {
            state = .idle
        }
    }
    
    func onClassificationError(errorDescription: String) {
        stop()
        delegate?.didFail(module: "LanguageClassifier", description: errorDescription)
    }
}

// MARK: - VoiceSynthesizerDelegate
extension Watson: VoiceSynthesizerDelegate {
    func onSynthesisStart() {
        state = .synthesizing
    }
    
    func onSynthesisSuccess(audio: Data) {
        lastAudio = audio
        if state == .synthesizing {
            state = .idle
        }
    }
    
    func didFinishMassSynthesize() {
        delegate?.didFinishPrepareAudio()
    }
    
    func onSynthesisError(errorDescription: String) {
        stop()
        delegate?.didFail(module: "VoiceSynthesizer", description: errorDescription)
    }
}

// MARK: - AudioSpeakerDelegate
extension Watson: AudioSpeakerDelegate {
    func onSpeechStart() {
        state = .speaking
    }
    
    func onSpeechSuccess() {
        if state == .speaking {
            state = .idle
        }
    }
    
    func onSpeechError(errorDescription: String) {
        stop()
        delegate?.didFail(module: "AudioSpeaker", description: errorDescription)
    }
    
}

// MARK: - Auxiliary definitions

protocol WatsonAction {
    var data: Any? { get }
}

struct RecognitionAction: WatsonAction {
    var data: Any?
}

struct ClassificationAction: WatsonAction {
    var data: Any?
    init(question: String? = nil) {
        self.data = ["question": question as Any] as Any
    }
}

struct SynthesisAction: WatsonAction {
    let data: Any?
    init(text: String? = nil) {
        self.data = text
    }
}

struct SpeechAction: WatsonAction {
    var data: Any?
}

enum WatsonState {
    case idle
    case listening
    case classifying
    case synthesizing
    case speaking
    
    func toString()->String {
        switch self {
        case .idle:
            return "idle"
        case .listening:
            return "listening"
        case .classifying:
            return "classifying"
        case .synthesizing:
            return "synthesizing"
        case .speaking:
            return "speaking"
        }
    }
}

protocol WatsonDelegate: class {
    func didChangeState(from: WatsonState, to: WatsonState)
    func didFinishPrepareAudio()
    func didFail(module: String, description: String)
    func showWatsonMessage(text:String)
    func showUserMessage(text:String)
}
