//
//  ArtProfileView.swift
//  ArtWork AR
//
//  Created by Syed ShahRukh Haider on 30/11/2017.
//  Copyright © 2017 Syed ShahRukh Haider. All rights reserved.
//

import UIKit

class ArtProfileView: UIView {
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var thumbUpButton: UIButton!
    @IBOutlet weak var thumbDownButton: UIButton!
    
    @IBOutlet weak var thumbUpValue: UILabel!
    
    @IBOutlet weak var thumbDownValue: UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}
