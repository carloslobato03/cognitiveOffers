//
//  VoiceSynthesizer.swift
//  Watson Conversation
//
//  Created by Marco Aurélio Bigélli Cardoso on 27/04/17.
//  Copyright © 2017 IBM. All rights reserved.
//

import Foundation

protocol VoiceSynthesizer: class {
    var delegate: VoiceSynthesizerDelegate? { get set }
    func synthesize(text: String)
    func cancel()
}

protocol VoiceSynthesizerDelegate: class {
    func onSynthesisStart()
    func onSynthesisSuccess(audio: Data)
    func onSynthesisError(errorDescription: String)
    func didFinishMassSynthesize()
}
