//
//  AccountTableViewCell.swift
//  UberdooXP
//
//  Created by Karthik Sakthivel on 01/11/17.
//  Copyright © 2017 Uberdoo. All rights reserved.
//

import UIKit

class AccountTableViewCell: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    
    @IBOutlet weak var icon: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        title.font = FontBook.Regular.of(size: 19)
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
