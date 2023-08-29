//
//  CustomizeVFX.swift
//  ArtWork AR
//
//  Created by Syed ShahRukh Haider on 01/12/2017.
//  Copyright © 2017 Syed ShahRukh Haider. All rights reserved.
//

import UIKit

@IBDesignable class CustomizeVFX: UIVisualEffectView {

    @IBInspectable var cornerRadius: CGFloat = 0{
        
        didSet{
            
            layer.cornerRadius = cornerRadius
        }
        
    }


}
