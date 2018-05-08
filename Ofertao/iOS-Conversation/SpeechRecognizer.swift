//
//  SpeechRecognizer.swift
//  Watson Conversation
//
//  Created by Marco Aurélio Bigélli Cardoso on 10/04/17.
//  Copyright © 2017 IBM. All rights reserved.
//

import Foundation

protocol SpeechRecognizer: class {
    var delegate: SpeechRecognizerDelegate? { get set }
    func startRecording()
    func cancel()
}

protocol SpeechRecognizerDelegate: class {
    func onRecognitionStart()
    func onRecognitionSuccess(transcription: String)
    func onRecognitionError(errorDescription: String)
}
