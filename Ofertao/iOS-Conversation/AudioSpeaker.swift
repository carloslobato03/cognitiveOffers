//
//  AudioSpeaker.swift
//  PinacoApp
//
//  Created by Marco Aurélio Bigélli Cardoso on 07/04/17.
//  Copyright © 2017 IBM. All rights reserved.
//

import Foundation
import AVFoundation

// AVAudioPlayer wrapper
class AudioSpeaker: NSObject, AVAudioPlayerDelegate {
    weak var delegate: AudioSpeakerDelegate?
    var player: AVAudioPlayer?
    
    func play(audio: Data) {
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true, with: .notifyOthersOnDeactivation)
            
            player = try AVAudioPlayer(data: audio, fileTypeHint: AVFileType.wav.rawValue)
            player?.delegate = self
            player?.setVolume(1, fadeDuration: 0)
            player?.prepareToPlay()
            player?.play()
            delegate?.onSpeechStart()
            AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
            
        } catch let error {
            print(error.localizedDescription)
            if error.localizedDescription == "The operation couldn’t be completed. (OSStatus error 1954115647.)" {
                delegate?.onSpeechError(errorDescription: "Invalid audio file format. Only WAV is supported in this app.")
            } else if error.localizedDescription == "The operation couldn’t be completed. (OSStatus error -39.)" {
                
            } else {
                delegate?.onSpeechError(errorDescription: error.localizedDescription)
            }
        }
    }
    
    func cancel() {
        player?.stop()
    }
    
    // MARK: AVAudioPlayerDelegate
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        delegate?.onSpeechSuccess()
        self.player = nil
    }
    
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        if let error = error {
            print("[x] Audio Player Decode Error: \(error.localizedDescription)")
        }
    }
    
}

protocol AudioSpeakerDelegate: class {
    func onSpeechStart()
    func onSpeechSuccess()
    func onSpeechError(errorDescription: String)
}
