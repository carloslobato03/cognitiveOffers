//
//  NativeVoiceSynthesizer.swift
//  Watson Conversation
//
//  Created by Marco Aurélio Bigélli Cardoso on 27/04/17.
//  Copyright © 2017 IBM. All rights reserved.
//

import Foundation
import Speech

class NativeVoiceSynthesizer: NSObject, VoiceSynthesizer, AVSpeechSynthesizerDelegate {
    
    var delegate: VoiceSynthesizerDelegate?
    let synthesizer = AVSpeechSynthesizer()

    override init() {
        super.init()
        synthesizer.delegate = self
    }
    
    func synthesize(text: String) {
        let utterance = AVSpeechUtterance(string: text)
//        utterance.voice = AVSpeechSynthesisVoice(language: Settings.nativeRecognitionLanguage)
        synthesizer.speak(utterance)
    }

    func cancel() {
        synthesizer.stopSpeaking(at: AVSpeechBoundary.immediate)
    }
    
    
}
