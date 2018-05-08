//
//  ProdutoMapaView.swift
//  Ofertao
//
//  Created by Rafael Moris on 29/07/17.
//  Copyright © 2017 Marco Aurélio Bigélli Cardoso. All rights reserved.
//

import Foundation
import UIKit

class ProdutoMapaView: UIView {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layer.cornerRadius = 5.0
        self.layer.masksToBounds = true
        self.contentMode = .scaleAspectFill
        
        self.backgroundColor = UIColor(red: (255.0/255.0), green: (255.0/255.0), blue: (255.0/255.0), alpha: 0.8)

        self.lblTitle.adjustsFontSizeToFitWidth = true
    }
}
