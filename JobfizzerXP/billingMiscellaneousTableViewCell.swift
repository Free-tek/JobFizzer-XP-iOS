//
//  billingMiscellaneousTableViewCell.swift
//  UberdooXP
//
//  Created by Praba VJ on 26/07/19.
//  Copyright © 2019 Uberdoo. All rights reserved.
//

import UIKit

class billingMiscellaneousTableViewCell: UITableViewCell
{
    @IBOutlet weak var miscellaneousName: UILabel!
    @IBOutlet weak var miscellaneousValue: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
