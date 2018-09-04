//
//  Individual.swift
//  GeneticStrings
//
//  Created by Mateus Leichsenring on 30.08.18.
//  Copyright © 2018 Mateus Leichsenring. All rights reserved.
//

import Foundation

class Individual
{
    public var Fitness:Float = 0
    public var Identity:String
    
    init(identity:String) {
        self.Identity = identity
    }
}
