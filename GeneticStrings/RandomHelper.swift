//
//  RandomHelper.swift
//  GeneticStrings
//
//  Created by Mateus Leichsenring on 30.08.18.
//  Copyright © 2018 Mateus Leichsenring. All rights reserved.
//

import Foundation

class RandomHelper {
    static func random(_ maxValue:Int) -> Int {
        return Int(arc4random_uniform(UInt32(maxValue)))
    }
    static func random(minValue:Int, maxValue:Int) -> Int {
        return Int(arc4random_uniform(UInt32(maxValue - minValue))) + minValue
    }
    static func randomCharacter(minValue:Int,maxValue:Int) -> Character {
        return Character(Unicode.Scalar.init(random(minValue: minValue, maxValue: maxValue))!)
    }
}
