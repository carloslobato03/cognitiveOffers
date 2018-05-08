//
//  WatsonSpeechRecognizer.swift
//  Watson Conversation
//
//  Created by Marco Aurélio Bigélli Cardoso on 09/04/17.
//  Copyright © 2017 IBM. All rights reserved.
//

import Foundation
import AVFoundation
//import SpeechToTextV1

private let SilenceIntervalSinceLastSpokenWord = TimeInterval(2.0)
private let SilenceIntervalSinceRecordingStart = TimeInterval(15.0)

class WatsonSpeechRecognizer: NSObject, SpeechRecognizer, AVAudioRecorderDelegate {
    weak var delegate: SpeechRecognizerDelegate?
    
//    let speechToText: SpeechToText
    private var stopRecordingTimer: Timer?
    private var transcriptedText: String?
    
    override init() {
//        speechToText = SpeechToText(username: Settings.speechRecognitionUsername, password: Settings.speechRecognitionPassword)
    }
    
    func startRecording() {
//        var settings = RecognitionSettings(contentType: .opus)
//        settings.continuous = true
//        settings.interimResults = true
//        delegate?.onRecognitionStart()
//        rescheduleStopRecordingTimer(silenceInterval: SilenceIntervalSinceRecordingStart)
//        speechToText.recognizeMicrophone(settings: settings, model: Settings.speechToTextLanguage, customizationID: nil, learningOptOut: false, compress: true,
//            failure: { failure in
//                print(failure.localizedDescription)
//                self.stopRecording(error: failure)
//            },
//            success: { results in
//                print(results.bestTranscript)
//                self.transcriptedText = results.bestTranscript
//                self.rescheduleStopRecordingTimer(silenceInterval: SilenceIntervalSinceLastSpokenWord)
//            }
//        )
    }
    
    func cancel() {
        stopRecording(error: nil)
    }
    
    func stopRecording(error: Error?) {
        stopRecordingTimer?.invalidate()
//        speechToText.stopRecognizeMicrophone()
        if error != nil {
            delegate?.onRecognitionError(errorDescription: (error?.localizedDescription)!)
        } else if transcriptedText == nil {
            delegate?.onRecognitionError(errorDescription: "Transcription is nil")
        } else {
            delegate?.onRecognitionSuccess(transcription: transcriptedText!)
        }
    }
    
    func rescheduleStopRecordingTimer(silenceInterval: TimeInterval) {
        stopRecordingTimer?.invalidate()
        stopRecordingTimer = Timer.scheduledTimer(
            withTimeInterval: silenceInterval,
            repeats: false,
            block: { (timer) in
                DispatchQueue.main.async { self.stopRecording(error: nil) }
        }
        )
    }
    
}
