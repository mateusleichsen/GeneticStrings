//
//  UIComponentViewWrapper.swift
//  GeneticStrings
//
//  Created by Mateus Leichsenring on 31.08.18.
//  Copyright © 2018 Mateus Leichsenring. All rights reserved.
//

import Foundation
import UIKit

class UIComponentViewWrapper {
    var viewController:UIViewController
    var uiViewDictionary:[String:UIView] {
        let mirrorObject = Mirror(reflecting: viewController)
        return generateDictionary(from: mirrorObject)
    }
    
    init(viewController:UIViewController) {
        self.viewController = viewController
    }
    
    private func generateDictionary(from mirrorObject: Mirror) -> [String:UIView] {
        var result:[String:UIView] = [:]
        for case let (label?, value) in mirrorObject.children {
            if let valueUIView = value as? UIView {
                result[label] = valueUIView
            }
        }
        return result
    }
}
