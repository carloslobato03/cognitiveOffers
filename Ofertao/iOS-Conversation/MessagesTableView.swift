//
//  MessagesTableView.swift
//  Conversation MF
//
//  Created by Rafael Moris on 05/07/17.
//  Copyright © 2017 Marco Aurélio Bigélli Cardoso. All rights reserved.
//

import Foundation
import UIKit

enum MessageSource {
    case user, watson
}

struct Message {
    var source:MessageSource
    var text:String
}

class MessagesTableView: UITableView, UITableViewDelegate, UITableViewDataSource {
    var messages = [Message]()
    var adjustScroll = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.delegate = self
        self.dataSource = self
        
        self.rowHeight = UITableViewAutomaticDimension
        self.estimatedRowHeight = 100.0
    }
    
    func removeAll() {
        self.messages.removeAll()
        self.reloadData()
    }
    
    func append(message:Message) {
        self.messages.append(message)

        if !messages.isEmpty {
            let indexPathOfLastRow = IndexPath(row: messages.count - 1, section: 0)
        
            self.insertRows(at: [indexPathOfLastRow], with: .none)
            
            delay(0.3) {
                self.adjustScroll = true
                self.scrollToRow(at: indexPathOfLastRow, at: .top, animated: true)
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.messages.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.messages[indexPath.row].source == .user {
            let cell = self.dequeueReusableCell(withIdentifier: "UserMessageCell")
                as! UserMessageCell
            cell.lblText.text = self.messages[indexPath.row].text
            return cell
        }else { // .watson
            var cell:WatsonMessageCell!
            if indexPath.row == 0 {
                cell = self.dequeueReusableCell(withIdentifier: "FirstWatsonMessageCell")
                    as! WatsonMessageCell
            }else {
            cell = self.dequeueReusableCell(withIdentifier: "WatsonMessageCell")
                as! WatsonMessageCell
            }
            cell.lblText.text = self.messages[indexPath.row].text
            return cell
        }
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        if self.adjustScroll {
            self.adjustScroll = false
            
            let scrollViewHeight = scrollView.frame.size.height;
            let scrollContentSizeHeight = scrollView.contentSize.height;
            let scrollOffset = scrollView.contentOffset.y;
            
            if scrollOffset > 0 && (scrollOffset + scrollViewHeight < scrollContentSizeHeight) {
                scrollView.setContentOffset(CGPoint(x: 0, y: scrollView.contentOffset.y - 36), animated: true)
            }
        }
    }
}
