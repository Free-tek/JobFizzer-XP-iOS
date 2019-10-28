//
//  BookingTableViewCell.swift
//  UberdooXP
//
//  Created by Karthik Sakthivel on 01/11/17.
//  Copyright © 2017 Uberdoo. All rights reserved.
//

import UIKit

class BookingTableViewCell: UITableViewCell {
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    
    @IBOutlet weak var serviceDate: UILabel!
    @IBOutlet weak var subCategoryName: UILabel!
    @IBOutlet weak var providerImage: UIImageView!
    

    @IBOutlet weak var changeStatusLbl: UILabel!
    @IBOutlet weak var changeStatusButton: UIButton!
    
//    @IBOutlet weak var startToPlace: UIButton!
//    @IBOutlet weak var startJob: UIButton!
    
    @IBOutlet weak var serviceTime: UILabel!
    @IBOutlet weak var cornerView: UIView!
    
    @IBOutlet weak var providerName: UILabel!
    
    @IBOutlet weak var bookingStatusImageView: UIImageView!
    @IBOutlet weak var bookingStatusLbl: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        dateLbl.text = "Date".localized()
        timeLbl.text = "Time".localized()
        
        providerName.font = FontBook.Medium.of(size: 16)
        subCategoryName.font = FontBook.Medium.of(size: 13)
        dateLbl.font = FontBook.Regular.of(size: 15)
        timeLbl.font = FontBook.Regular.of(size: 15)
        serviceDate.font = FontBook.Medium.of(size: 12)
        serviceTime.font = FontBook.Medium.of(size: 12)
        changeStatusLbl.font = FontBook.Regular.of(size: 12)
        bookingStatusLbl.font = FontBook.Medium.of(size: 12)
        
        
        
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

