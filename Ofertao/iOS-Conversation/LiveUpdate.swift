//
//  LiveUpdate.swift
//  Conversation MF
//
//  Created by Rafael Moris on 04/07/17.
//  Copyright © 2017 Marco Aurélio Bigélli Cardoso. All rights reserved.
//

import Foundation
import IBMMobileFirstPlatformFoundation
import IBMMobileFirstPlatformFoundationLiveUpdate

class LiveUpdate {
    static let shared = LiveUpdate()
    
    fileprivate init() {}
    
    func configurationForCustomStart(completion:((_ configuration:Configuration?)->())?) {
        
        LiveUpdateManager.sharedInstance.obtainConfiguration("custom_start", useCache: false) { (configuration, error) in
            completion?(configuration)
        }
    }
}
