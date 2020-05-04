//
//  AssetsColor.swift
//  DarkLighModeTheme
//
//  Created by Jyoti on 15/04/20.
//  Copyright © 2020 Jyoti. All rights reserved.
//

import Foundation
import UIKit

enum Color : String {
    case backgroundColor
    case iconTintColor
    case textColor
    case navigationBarColor
    case likeIconColor
    case releaseDateIconColor
    case splashScreenColor
}

extension UIColor
{
    static func getColor(_ name: Color) -> UIColor? {
       return UIColor(named: name.rawValue)
    }
}
