//
//  LanguageTranslator.swift
//  Conversation MF
//
//  Created by Rafael Moris on 12/07/17.
//  Copyright © 2017 Marco Aurélio Bigélli Cardoso. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON

class LanguageTranslator {
    weak var delegate:LanguageTranslatorDelegate?
    
    func translate(text:String) {
        self.delegate?.onTranslationStart()
        
        let requestURL = "https://gateway.watsonplatform.net/language-translator/api/v2/translate"
        
        var headers: HTTPHeaders = [:]
        if let authorizationHeader = Request.authorizationHeader(user: "25ba9f15-886c-44c5-a288-c01e62b17699", password: "TaGtRhdrM5k5") {
            headers[authorizationHeader.key] = authorizationHeader.value
            
        }
        headers["Content-Type"] = "application/json"
        headers["Accept"] = "application/json"
            
        let requestParams = [
            "text": text,
            "source": "en",
            "target": "pt"
        ]
        
        Alamofire.request(requestURL, method: .post, parameters: requestParams, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            
            switch response.result {
            case .success(let data):
                let json = JSON(data)
                self.delegate?.onTranslationSuccess(result: json)
                
            case .failure(let error):
                print(error)
                self.delegate?.onTranslationError(errorDescription: error.localizedDescription)
            }
        }
    }
}

protocol LanguageTranslatorDelegate:class {
    func onTranslationStart()
    func onTranslationSuccess(result: JSON)
    func onTranslationError(errorDescription: String)
}
