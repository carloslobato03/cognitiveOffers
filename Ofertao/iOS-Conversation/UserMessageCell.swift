//
//  UserMessageCell.swift
//  Conversation MF
//
//  Created by Rafael Moris on 05/07/17.
//  Copyright © 2017 Marco Aurélio Bigélli Cardoso. All rights reserved.
//

import Foundation
import UIKit

class UserMessageCell: UITableViewCell {
    @IBOutlet weak var lblText: UILabel!
    @IBOutlet weak var viewBackground: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.lblText.text = ""
        self.renderLayout()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.lblText.text = ""
        self.renderLayout()
    }
    
    func renderLayout() {
        let layout = Layout.shared
        
        self.lblText.textColor = layout.colorForString(layout.userMessageTextColor)
        
        self.viewBackground.layer.cornerRadius = 8
        self.viewBackground.layer.masksToBounds = true
        
        self.viewBackground.backgroundColor = layout.colorForString(layout.userMessageBackgroundColor)
        
        self.viewBackground.contentMode = UIViewContentMode.scaleAspectFill
    }
}
