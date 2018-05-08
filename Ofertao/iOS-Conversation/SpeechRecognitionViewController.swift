//
//  SpeechRecognitionViewController.swift
//  Watson Conversation
//
//  Created by Marco Aurélio Bigélli Cardoso on 11/04/17.
//  Copyright © 2017 IBM. All rights reserved.
//

import Foundation
import UIKit

class SpeechRecognitionViewController: UITableViewController {
    
    @IBOutlet weak var useSpeechToTextCell: UITableViewCell!
    @IBOutlet weak var useNativeRecognitionCell: UITableViewCell!
    @IBOutlet weak var speechRecognitionUsernameTF: UITextField!
    @IBOutlet weak var speechRecognitionPasswordTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        useSpeechToTextCell.accessoryType = .none
        useNativeRecognitionCell.accessoryType = .checkmark
        
        speechRecognitionUsernameTF.text = Settings.speechRecognitionUsername
        speechRecognitionPasswordTF.text = Settings.speechRecognitionPassword
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Fields to settings
        Settings.speechRecognitionUsername = speechRecognitionUsernameTF.text!
        Settings.speechRecognitionPassword = speechRecognitionPasswordTF.text!
        
        Settings.saveToDisk()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            tableView.cellForRow(at: IndexPath(item: 1 - indexPath.item, section: 0))?.accessoryType = .none
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
            tableView.reloadData()
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        if Settings.useNativeRecognition && indexPath.section == 1 {
//            return 0
//        } else {
            return UITableViewAutomaticDimension
//        }
    }
    
    
}
