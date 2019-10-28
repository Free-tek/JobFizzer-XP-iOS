//
//  Font.swift
//  UberdooXP
//
//  Created by admin on 11/20/18.
//  Copyright © 2018 Uberdoo. All rights reserved.
//

import Foundation
import UIKit

enum FontBook: String
{
    case Regular = "Ubuntu-Regular"
    case Bold = "Ubuntu-Bold"
    case BoldItalic = "Ubuntu-BoldItalic"
    case Italic = "Ubuntu-Italic"
    case Medium = "Ubuntu-Medium"
    case mediumItalic = "Ubuntu-MediumItalic"
    case Light = "Ubuntu-Light"
    case LightItalic = "Ubuntu-LightItalic"
    func of(size: CGFloat) -> UIFont
    {
        return UIFont(name: self.rawValue, size: size)!
    }
}

