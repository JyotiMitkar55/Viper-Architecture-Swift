//
//  GlobalVariables.swift
//  Movies
//
//  Created by Jyoti on 20/04/20.
//  Copyright © 2020 Jyoti. All rights reserved.
//

import UIKit

class GlobalVariables: NSObject {
    
    var imageData:[String:Any] = [:]

    static let shared = GlobalVariables()
    
    private override init() {
        //init method
    }
}
