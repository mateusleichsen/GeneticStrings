//
//  UIViewBinding.swift
//  GeneticStrings
//
//  Created by Mateus Leichsenring on 30.08.18.
//  Copyright © 2018 Mateus Leichsenring. All rights reserved.
//

import Foundation
import UIKit

protocol UIViewBindingDelegate {
    func setValue<T>(_ newValue:T)
    func getValue<T>() -> T?
    func command(_ target:Any?, action: Selector, for: UIControlEvents)
}

extension UIView:UIViewBindingDelegate {
    func setValue<T>(_ newValue:T) {
        if let button = self as? UIButton {
            button.setTitle(newValue as? String, for: .normal)
        }
        
        if let label = self as? UILabel {
            label.text = newValue as? String
        }
        
        if let textView = self as? UITextView {
            textView.text = newValue as? String
        }
        
        if let textField = self as? UITextField {
            textField.text = newValue as? String
        }
        
        if let uiSwitch = self as? UISwitch {
            uiSwitch.isOn = newValue as! Bool
        }
        
        if let slider = self as? UISlider {
            slider.value = newValue as! Float
        }
    }
    
    func getValue<T>() -> T? {
        if let button = self as? UIButton {
            return button.titleLabel?.text as? T
        }
        
        if let label = self as? UILabel {
            return label.text as? T
        }
        
        if let textView = self as? UITextView {
            return textView.text as? T
        }
        
        if let textField = self as? UITextField {
            return textField.text as? T
        }
        
        if let uiSwitch = self as? UISwitch {
            return uiSwitch.isOn as? T
        }
        
        if let slider = self as? UISlider {
            return slider.value as? T
        }
        
        return nil
    }
    
    func command(_ target: Any?, action: Selector,for controlEvent: UIControlEvents) {
        if let uiControl = self as? UIControl {
            uiControl.addTarget(target, action: action, for: controlEvent)
        }
//        if let button = self as? UIButton {
//            button.addTarget(target, action: action, for: controlEvent)
//        }
//        if let uiSwitch = self as? UISwitch {
//            uiSwitch.addTarget(target, action: action, for: controlEvent)
//        }
//        if let slider = self as? UISlider {
//            slider.addTarget(target, action: action, for: controlEvent)
//        }
//        if let textField = self as? UITextField {
//            textField.addTarget(target, action: action, for: controlEvent)
//        }
    }
    
}
