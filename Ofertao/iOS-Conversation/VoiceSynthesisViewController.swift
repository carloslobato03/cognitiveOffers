//
//  VoiceSynthesisSettingsViewController.swift
//  Watson Conversation
//
//  Created by Marco Aurélio Bigélli Cardoso on 09/04/17.
//  Copyright © 2017 IBM. All rights reserved.
//

import Foundation
import UIKit

class VoiceSynthesisSettingsViewController: UITableViewController {
    @IBOutlet weak var voiceSynthesisUserTF: UITextField!
    @IBOutlet weak var voiceSynthesisPwdTF: UITextField!
    @IBOutlet weak var voiceSynthesisURLCell: UITableViewCell!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Settings to fields
        voiceSynthesisUserTF.text = Settings.voiceSynthesisUsername
        voiceSynthesisPwdTF.text = Settings.voiceSynthesisPassword
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Fields to settings
        Settings.voiceSynthesisUsername = voiceSynthesisUserTF.text!
        Settings.voiceSynthesisPassword = voiceSynthesisPwdTF.text!
        
        Settings.saveToDisk()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        if (indexPath.section == 1 && indexPath.item == 1 && !useTextToSpeechSwitch.isOn) ||
//            (indexPath.section == 1 && indexPath.item == 2 && useTextToSpeechSwitch.isOn) {
//            return 0
//        }
        return UITableViewAutomaticDimension
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 2 {
            UIHelper.confirmAlert(title: "Delete Audio Cache", text: "Are you sure you want to delete all audio cache?", owner: self, okHandler: { _ in
                Settings.clearAudioCache()
            })
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func switchDidChange() {
        tableView.reloadData()
    }
}
