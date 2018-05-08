//
//  OrchestratorSettingsViewController.swift
//  Watson Conversation
//
//  Created by Marco Aurélio Bigélli Cardoso on 09/04/17.
//  Copyright © 2017 IBM. All rights reserved.
//

import Foundation
import UIKit

class OrchestratorSettingsViewController: UITableViewController {
    @IBOutlet weak var orchestratorUserTF: UITextField!
    @IBOutlet weak var orchestratorPwdTF: UITextField!
    @IBOutlet weak var workspaceIDTF: UITextField!
    @IBOutlet weak var workspaceCell: UITableViewCell!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Settings to fields
        orchestratorUserTF.text = Settings.orchestratorUsername
        orchestratorPwdTF.text = Settings.orchestratorPassword
        workspaceIDTF.text = Settings.conversationWorkspace
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Fields to settings
        Settings.orchestratorUsername = orchestratorUserTF.text!
        Settings.orchestratorPassword = orchestratorPwdTF.text!
        Settings.conversationWorkspace = workspaceIDTF.text!
        
        Settings.saveToDisk()
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        if (indexPath.section == 1 && indexPath.item == 1 && !useConversationSwitch.isOn) ||
//            (indexPath.section == 1 && indexPath.item == 2 && useConversationSwitch.isOn) {
//            return 0
//        }
        return UITableViewAutomaticDimension
    }
    
    func switchDidChange() {
        tableView.reloadData()
    }
    
}
