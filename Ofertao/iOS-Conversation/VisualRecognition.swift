//
//  VisualRecognition.swift
//  Conversation MF
//
//  Created by Rafael Moris on 12/07/17.
//  Copyright © 2017 Marco Aurélio Bigélli Cardoso. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON

class VisualRecognition {
    weak var delegate:VisualRecognitionDelegate?
    
    func classify(image original:UIImage) {
        if let image = self.resizeImage(image: original) {
            var data:Data?
            
            if let pngData = UIImagePNGRepresentation(image) {
                data = pngData
            }else if let jpegData = UIImageJPEGRepresentation(image, 100) {
                data = jpegData
            }
            
            if data != nil {
                self.delegate?.onRecognitionStart()
                
                let stringBase64 = data!.base64EncodedString(options: .endLineWithCarriageReturn)
                
                let requestURL = "https://visual-recognition-demo.mybluemix.net/api/classify"
                let headers: HTTPHeaders = ["Content-Type":"application/x-www-form-urlencoded"]
                
                let requestParams = [
                    "classifier_id": "",
                    "url": "",
                    "image_data": "data:image/png;base64," + stringBase64
                ]
                
                Alamofire.request(requestURL, method: .post, parameters: requestParams, headers: headers).responseJSON { response in
                    
                    switch response.result {
                    case .success(let data):
                        let json = JSON(data)
                        self.delegate?.onRecognitionSuccess(result: json)
                        
                    case .failure(let error):
                        print(error)
                        self.delegate?.onRecognitionError(errorDescription: error.localizedDescription)
                    }
                }
            }
        }
    }
    
    func resizeImage(image:UIImage)-> UIImage? {
        var actualHeight = image.size.height
        var actualWidth = image.size.width
        let maxHeight:CGFloat = 300.0
        let maxWidth:CGFloat = 400.0
        var imgRatio:CGFloat = actualWidth/actualHeight
        let maxRatio:CGFloat = maxWidth/maxHeight
        let compressionQuality:CGFloat = 0.5 //50 percent compression
        
        if (actualHeight > maxHeight || actualWidth > maxWidth)
        {
            if(imgRatio < maxRatio)
            {
                //adjust width according to maxHeight
                imgRatio = maxHeight / actualHeight
                actualWidth = imgRatio * actualWidth
                actualHeight = maxHeight
            }
            else if(imgRatio > maxRatio)
            {
                //adjust height according to maxWidth
                imgRatio = maxWidth / actualWidth
                actualHeight = imgRatio * actualHeight
                actualWidth = maxWidth
            }
            else
            {
                actualHeight = maxHeight
                actualWidth = maxWidth
            }
        }
        
        let rect = CGRect(x: 0.0, y:0.0, width: actualWidth, height: actualHeight)
        UIGraphicsBeginImageContext(rect.size)
        image.draw(in: rect)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        let imageData = UIImageJPEGRepresentation(img!, compressionQuality)
        UIGraphicsEndImageContext()
        
        return UIImage(data: imageData!)
    }
}

protocol VisualRecognitionDelegate:class {
    func onRecognitionStart()
    func onRecognitionSuccess(result: JSON)
    func onRecognitionError(errorDescription: String)
}
