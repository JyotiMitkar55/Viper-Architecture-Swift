//
//  TextFieldPresenter.swift
//  MovieProject
//
//  Created by Jyoti on 16/04/20.
//  Copyright © 2020 Jyoti. All rights reserved.
//

import Foundation
import UIKit

extension UITextField {
    
    /* This method is used to set icon at left side of the textfield */
    func setLeftIcon(_ image: UIImage?) {
        
        if let icon = image {
            let iconView = UIImageView(frame:CGRect(x: 10, y: 5, width: 20, height: 20))
            iconView.image = icon
            let iconContainerView: UIView = UIView(frame:CGRect(x: 20, y: 0, width: 30, height: 30))
            iconContainerView.addSubview(iconView)
            leftView = iconContainerView
            leftViewMode = .always
        }
    }
}
