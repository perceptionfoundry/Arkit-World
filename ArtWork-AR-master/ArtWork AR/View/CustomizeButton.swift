//
//  CustomizeButton.swift
//  ArtWork AR
//
//  Created by Syed ShahRukh Haider on 28/11/2017.
//  Copyright © 2017 Syed ShahRukh Haider. All rights reserved.
//

import UIKit

@IBDesignable class CustomizeButton: UIButton {

    @IBInspectable var cornerRadius:  CGFloat = 0 {
        
        didSet{
            layer.cornerRadius = cornerRadius
        
        }
        
    }
    
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        didSet {
            layer.borderColor = borderColor?.cgColor
        }

}
}
