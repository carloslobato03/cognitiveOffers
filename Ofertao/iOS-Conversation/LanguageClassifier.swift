//
//  LanguageClassifier.swift
//  PinacoApp
//
//  Created by Marco Aurélio Bigélli Cardoso on 20/01/17.
//  Copyright © 2017 IBM. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire
import IBMMobileFirstPlatformFoundation

/*
 Language Classifier class represents a language classification API.
 Uses Watson Conversation API interface by default. New interfaces may be added in the future.
*/

class LanguageClassifier: NSObject {
    weak var delegate: LanguageClassifierDelegate?
    
//    private var currentRequest: DataRequest?
    
    public var lastContext: [String: Any?] = [:]
    public var lastEntities: [JSON] = [[:]]
    
    public func classify(text: String) {
        let _ = WLClient.sharedInstance().serverUrl()

        if let _ = Settings.accessToken {
            self.startClassifyWithText(text)
        }else {
            WLAuthorizationManager.sharedInstance().obtainAccessToken(forScope: "RegisteredClient") { (token, error) in
                
                if let error = error {
                    print("Não foi recebido um Token do servidor: " + error.localizedDescription)
                    self.delegate?.onClassificationError(errorDescription: error.localizedDescription)
                }else {
                    self.startClassifyWithText(text)
                }
            }
        }
    }
    
    private func startClassifyWithText(_ text: String) {
        let requestURL = Settings.messageURL
        let user = Settings.orchestratorUsername
        let password = Settings.orchestratorPassword
        
        let request = WLResourceRequest(url: URL(string: requestURL), method: WLHttpMethodPost)
        
        var authorizationValue = ""
        if let authorizationHeader = Request.authorizationHeader(user: user, password: password) {
            authorizationValue = authorizationHeader.value
            request?.setHeaderValue("application/json" as NSObject, forName: "Content-Type")
        }
        
        var context = self.lastContext
        context["timezone"] = "America/Sao_Paulo"
        
        let requestParams = [
            "authorization" : authorizationValue,
            "input": [
                "text": text.lowercased()
            ],
            "context": context
        ] as [String : Any]
        
        self.delegate?.onClassificationStart()
        
        request?.send(withJSON: requestParams, completionHandler: { (response, error) in
            if let error = error {
                print("Failure: " + error.localizedDescription)
                self.delegate?.onClassificationError(errorDescription: error.localizedDescription)
            }else {
                if let response = response {
                    let json = JSON(response.responseData)
                    print(json)
                    
                    if let answerArrayObject = json["output"]["text"].arrayObject,
                        let context = json["context"].dictionaryObject {
                        let answerArray: [String] = answerArrayObject.flatMap { String(describing: $0) }
                        self.delegate?.onClassificationSuccess(result: answerArray.joined(separator: " "))
                        self.lastContext = context
                        
                        if let entities = json["entities"].array {
                            self.lastEntities = entities
                        }
                        
                    } else {
                        self.delegate?.onClassificationError(errorDescription: "Parsing error. server responded with " + (json.rawString() ?? ""))
                    }
                }
            }
        })
    }

    public func cancel() {
//        currentRequest?.cancel()
    }

}

protocol LanguageClassifierDelegate: class {
    func onClassificationStart()
    func onClassificationSuccess(result: String)
    func onClassificationError(errorDescription: String)
}
