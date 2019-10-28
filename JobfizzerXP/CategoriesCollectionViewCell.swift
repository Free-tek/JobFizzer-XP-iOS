//
//  CategoriesCollectionViewCell.swift
//  UberdooXP
//
//  Created by Karthik Sakthivel on 05/11/17.
//  Copyright © 2017 Uberdoo. All rights reserved.
//

import UIKit

class CategoriesCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var categoryName: UILabel!
    @IBOutlet weak var serviceName: UILabel!
    @IBOutlet weak var exprerience: UILabel!
    @IBOutlet weak var pricePerHour: UILabel!
    @IBOutlet weak var quickPitch: UILabel!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var editImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        categoryName.font = FontBook.Medium.of(size: 12)
        serviceName.font = FontBook.Medium.of(size: 12)
        exprerience.font = FontBook.Medium.of(size: 12)
        pricePerHour.font = FontBook.Medium.of(size: 12)
        quickPitch.font = FontBook.Medium.of(size: 12)
        
        
    }
    
    
}
