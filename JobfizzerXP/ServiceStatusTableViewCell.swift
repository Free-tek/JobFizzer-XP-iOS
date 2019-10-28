//
//  ServiceStatusTableViewCell.swift
//  UberdooXP
//
//  Created by Karthik Sakthivel on 05/01/18.
//  Copyright © 2018 Uberdoo. All rights reserved.
//

import UIKit

class ServiceStatusTableViewCell: UITableViewCell {
    @IBOutlet weak var statusTime: UILabel!
    @IBOutlet weak var centerCircle: UIView!
    @IBOutlet weak var topLine: UIView!
    @IBOutlet weak var bottomLine: UIView!
    @IBOutlet weak var statusIdentifier: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        statusIdentifier.font = FontBook.Regular.of(size: 16)
        statusTime.font = FontBook.Regular.of(size: 13)
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
