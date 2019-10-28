//
//  MiscellaneousTableViewCell.swift
//  UberdooXP
//
//  Created by admin on 7/16/19.
//  Copyright © 2019 Uberdoo. All rights reserved.
//

import UIKit

class MiscellaneousTableViewCell: UITableViewCell {

    
   
    
    @IBOutlet weak var nameLine: UIView!
    @IBOutlet weak var priceLine: UIView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var amountLbl: UILabel!
    @IBOutlet weak var amountTf: UITextField!
    @IBOutlet weak var currencyLbl: UILabel!
    @IBOutlet weak var descriptionTf: UITextField!
    @IBOutlet weak var removeBtn: UIButton!
    @IBOutlet weak var removeImageView: UIImageView!
   
    
    override func awakeFromNib() {
        super.awakeFromNib()
        nameLbl.isHidden = true
        amountLbl.isHidden = true
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
