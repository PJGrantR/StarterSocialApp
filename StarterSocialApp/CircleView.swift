//
//  CircleView.swift
//  StarterSocialApp
//
//  Created by Peter-Jon Grant on 2016-10-31.
//  Copyright © 2016 Peter-Jon Grant. All rights reserved.
//

import UIKit

class CircleView: UIImageView {
    
    override func layoutSubviews() {
       super.layoutSubviews()
        
         layer.cornerRadius = self.frame.width / 2
         clipsToBounds = true
    }
}
