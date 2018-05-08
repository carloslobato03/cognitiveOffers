//
//  SpeechRecognizer.swift
//  Watson Conversation
//
//  Created by Marco Aurélio Bigélli Cardoso on 19/01/17.
//  Copyright © 2017 IBM. All rights reserved.
//

import Foundation
import Speech

class NativeSpeechRecognizer: NSObject, SpeechRecognizer {
    
    weak var delegate: SpeechRecognizerDelegate?
    
    var makeTranscription = false
    @objc dynamic var transcriptedText = ""
    
    var recognizer: SFSpeechRecognizer
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    
    private var stopRecordingTimer: Timer?
    
    private let allowedTimeBetweenWords = TimeInterval(2.0)
    private let allowedTimeFromStart = TimeInterval(15.0)
    
    override init() {
        recognizer = SFSpeechRecognizer(locale: Locale.init(identifier: Settings.nativeRecognitionLanguage))!
        super.init()
        recognizer.delegate = self
        requestAndHandleSpeechRecognizerAuthorization()
    }
    
    func requestAndHandleSpeechRecognizerAuthorization() {
        SFSpeechRecognizer.requestAuthorization { (authStatus) in
            switch authStatus {
            case .authorized:
                print("[*] Speech Auth Request: User authorized access to speech recognition.\n")
                
            case .denied:
                print("[x] Speech Auth Request: User denied access to speech recognition.\n")
                
            case .restricted:
                print("[!] Speech Auth Request: Speech recognition restricted on this device.\n")
                
            case .notDetermined:
                print("[?] Speech Auth Request: Speech recognition not yet authorized.\n")
            }
        }
    }
    
    func rescheduleStopRecordingTimer(silenceInterval: TimeInterval) {
        stopRecordingTimer?.invalidate()
        stopRecordingTimer = Timer.scheduledTimer(
            withTimeInterval: silenceInterval, repeats: false, block: { _ in self.stopRecording() }
        )
    }
    
    func stopRecording() {
        stopRecordingTimer?.invalidate()
        stopRecordingTimer = nil
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
        recognitionRequest?.endAudio()
        if !transcriptedText.isEmpty {
            delegate?.onRecognitionSuccess(transcription: transcriptedText)
        }
        transcriptedText = ""
        recognitionRequest = nil
        recognitionTask = nil
    }
    
    func finishRecording() {
        self.makeTranscription = true
        stopRecordingTimer?.invalidate()
        stopRecordingTimer = nil
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
        recognitionRequest?.endAudio()
    }
    
    func startRecording() {
        
        if recognitionTask != nil {
            stopRecording()
        }
        
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try audioSession.setActive(true, with: .notifyOthersOnDeactivation)
        } catch {
            print("audioSession properties weren't set because of an error.")
        }
        
        let inputNode = audioEngine.inputNode
        //else {
        //    fatalError("Audio engine has no input node")
        //}
        
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        guard let recognitionRequest = recognitionRequest else {
            fatalError("Unable to create an SFSpeechAudioBufferRecognitionRequest object")
        }
        recognitionRequest.shouldReportPartialResults = true
        
        recognitionTask = recognizer.recognitionTask(with: recognitionRequest, resultHandler: { (result, error) in
            
            if result != nil {
                self.transcriptedText = result!.bestTranscription.formattedString
                print(self.transcriptedText)
                
                if self.makeTranscription {
                    self.makeTranscription = false
                    self.stopRecording()
                }
                //                self.rescheduleStopRecordingTimer(silenceInterval: self.allowedTimeBetweenWords)
            }
            
            if let error = error?.localizedDescription {
                print("[ -- SR Error: \(error) -- ]\n")
                self.delegate?.onRecognitionError(errorDescription: error)
            }
        })
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, when) in
            self.recognitionRequest?.append(buffer)
        }
        
        audioEngine.prepare()
        
        do {
            try audioEngine.start()
            delegate?.onRecognitionStart()
            //            rescheduleStopRecordingTimer(silenceInterval: allowedTimeFromStart)
        } catch {
            print("[x] Audio Engine couldn't start because of an error: \(error)")
        }
    }
    
    func cancel() {
        transcriptedText = ""
        stopRecording()
    }
    
}

// MARK: SpeechRecognitionDelegate
extension NativeSpeechRecognizer: SFSpeechRecognizerDelegate {
    func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        if available {
            print("[*] Speech Recognition is Available\n")
        } else {
            print("[!] Speech Recognition is NOT Available\n")
        }
    }
}

