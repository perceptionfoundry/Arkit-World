//
//  customizeImage.swift
//  ArtWork AR
//
//  Created by Syed ShahRukh Haider on 28/11/2017.
//  Copyright © 2017 Syed ShahRukh Haider. All rights reserved.
//

import UIKit

@IBDesignable class customizeImage: UIImageView {

    @IBInspectable var cornerRadius: CGFloat = 0{
        
        didSet{
            
            layer.cornerRadius = cornerRadius
        }
        
    }
    
}
