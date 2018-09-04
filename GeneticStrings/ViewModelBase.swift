//
//  ViewModelBase.swift
//  GeneticStrings
//
//  Created by Mateus Leichsenring on 01.09.18.
//  Copyright © 2018 Mateus Leichsenring. All rights reserved.
//

import Foundation
import UIKit

class ViewModelBase {
    var uiViews:[String:UIView]
    
    required init(uiComponentViewWrapper:UIComponentViewWrapper) {
        self.uiViews = uiComponentViewWrapper.uiViewDictionary
    }
    
    func setValue<T>(of property:T,newValue:Any) {
        let mirror = Mirror(reflecting: T.self)
        uiViews[mirror.description]?.setValue(newValue)
    }
    
    func setValue(_ property:String,newValue:Any) {
        uiViews[property]?.setValue(newValue)
    }
    
    func getValue<T>(_ property:String) -> T? {
        return uiViews[property]?.getValue()
    }
    
    func getValue<T>(of property:T) -> T? {
        let mirror = Mirror(reflecting: T.self)
        return uiViews[mirror.description]?.getValue()
    }
    
    func command(_ property:String, _ target: Any?, action: Selector,for controlEvent: UIControlEvents) {
        uiViews[property]?.command(target, action: action, for: controlEvent)
    }
}
