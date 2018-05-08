//
//  AlamoWrapper.swift
//  PinacoApp
//
//  Created by Felipe Fiali de Sa on 12/01/17.
//  Copyright © 2017 IBM. All rights reserved.
//

import Foundation
import Alamofire

class AlamoWrapper {
    private static let httpStatusCodeOK = 200
    
    static func performRequest(_ url: URLConvertible, method: Alamofire.HTTPMethod = .get, parameters: Parameters? = nil, encoding: ParameterEncoding = URLEncoding.default, headers: HTTPHeaders? = nil, result: @escaping (_ success: Bool, _ data: Any?) -> Void, noConnection: @escaping () -> Void) -> Void {
        request(url, method: method, parameters: parameters, encoding: encoding, headers: headers).response {
            response in
            
            var successAnswer = false
            var dataAnswer: Any? = nil
            print(response)
            
            switch response.response?.statusCode {
            case 200?:
                dataAnswer = response.data
                print(dataAnswer != nil ? dataAnswer! : "")
                if response.response?.statusCode == httpStatusCodeOK {
                    successAnswer = true
                }
                
                break
                
            default:
                noConnection() // I am aware this is not correct. But it's enough to keep this working
                
                break
            }
            
            result(successAnswer, dataAnswer)
        }
    }
}
