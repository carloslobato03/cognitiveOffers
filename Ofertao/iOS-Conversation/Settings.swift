//
//  Settings.swift
//  Watson Conversation
//
//  Created by Marco Aurélio Bigélli Cardoso on 02/02/17.
//  Copyright © 2017 IBM. All rights reserved.
//

import Foundation
import IBMMobileFirstPlatformFoundation

class Settings {
    static var accessToken:AccessToken?
    
    static var nativeRecognitionLanguage = ""
    
    static var speechRecognitionUsername = ""
    static var speechRecognitionPassword = ""
    
    static var conversationWorkspace = ""
    static var orchestratorUsername = ""
    static var orchestratorPassword = ""
    
    static var messageURL: String {
        get {
            return "adapters/ConversationAdapter/resource/conversation/\(conversationWorkspace)"
        }
    }
    
    static var textToSpeechVoice = "pt-BR_IsabelaVoice"
    static var voiceSynthesisUsername = ""
    static var voiceSynthesisPassword = ""
    
    static var voiceSynthesisURL: String {
        get {
            return "adapters/TextToSpeechAdapter/resource/texttospeech/synthesize?voice=\(textToSpeechVoice)"
        }
    }
    
    static func saveToDisk() {
        UserDefaults.standard.set(speechRecognitionUsername, forKey: "speechRecognitionUsername")
        UserDefaults.standard.set(speechRecognitionPassword, forKey: "speechRecognitionPassword")
        UserDefaults.standard.set(nativeRecognitionLanguage, forKey: "nativeRecognitionLanguage")
        
        UserDefaults.standard.set(orchestratorUsername, forKey: "orchestratorUsername")
        UserDefaults.standard.set(orchestratorPassword, forKey: "orchestratorPassword")
        UserDefaults.standard.set(conversationWorkspace, forKey: "conversationWorkspace")
        
        UserDefaults.standard.set(voiceSynthesisUsername, forKey: "voiceSynthesisUsername")
        UserDefaults.standard.set(voiceSynthesisPassword, forKey: "voiceSynthesisPassword")
        UserDefaults.standard.set(voiceSynthesisPassword, forKey: "voiceSynthesisPassword")
        UserDefaults.standard.set(textToSpeechVoice, forKey: "textToSpeechVoice")
    }
    
    static func loadFromDisk() {
        speechRecognitionUsername = UserDefaults.standard.value(forKey: "speechRecognitionUsername") as? String ?? ""
        speechRecognitionPassword = UserDefaults.standard.value(forKey: "speechRecognitionPassword") as? String ?? ""
        nativeRecognitionLanguage = UserDefaults.standard.value(forKey: "nativeRecognitionLanguage") as? String ?? "pt-BR"
        
        orchestratorUsername = UserDefaults.standard.value(forKey: "orchestratorUsername") as? String ?? "e21a3047-8d37-4220-913d-7ca6023397c8"
        orchestratorPassword = UserDefaults.standard.value(forKey: "orchestratorPassword") as? String ?? "Bl06sdgiydtL"
        conversationWorkspace = UserDefaults.standard.value(forKey: "conversationWorkspace") as? String ?? "8cccb4b3-f1b1-477b-96bc-1c5efa1b891c"

        voiceSynthesisUsername = UserDefaults.standard.value(forKey: "voiceSynthesisUsername") as? String ?? "e2bc66d7-207a-409f-8d39-c36acf24147a"
        voiceSynthesisPassword = UserDefaults.standard.value(forKey: "voiceSynthesisPassword") as? String ?? "5ivYGaoMTM36"
        
        textToSpeechVoice = UserDefaults.standard.value(forKey: "textToSpeechVoice") as? String ?? "pt-BR_IsabelaVoice"
    }
    
    static func clearAudioCache() {
        let fileManager = FileManager.default
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] + "/"
        do {
            let filePaths = try fileManager.contentsOfDirectory(atPath: documentsPath)
            for filePath in filePaths {
                print(filePath)
                try fileManager.removeItem(atPath: documentsPath + filePath)
            }
        } catch {
            print("Could not clear audio cache: \(error)")
        }
    }
}
