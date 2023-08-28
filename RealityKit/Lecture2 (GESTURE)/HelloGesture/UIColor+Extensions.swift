//
//  UIColor+Extensions.swift
//  HelloGesture
//
//  Created by Perception on 28/08/2023.
//

import Foundation
import UIKit

extension UIColor {
    
    static func random() -> UIColor{
        UIColor(displayP3Red: Double.random(in: 0...1), green: Double.random(in: 0...1), blue: Double.random(in: 0...1), alpha: 1)
    }
}
