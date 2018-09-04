//
//  ViewModelProperties.swift
//  GeneticStrings
//
//  Created by Tiago Leichsenring on 01.09.18.
//  Copyright © 2018 Mateus Leichsenring. All rights reserved.
//

import Foundation
import UIKit

extension ViewModelProperties:ViewModel {
    var population:[Individual]!
    var objective:String? {
        get {
            return getValue("objectiveText")
        }
        set {
            if newValue != objective {
                setValue("objectiveText", newValue: newValue!)
            }
        }
    }
    var limitPopulation:Int {
        get {
            return getValue("limitPopulationText") ?? 0
        }
        set {
            if newValue != limitPopulation {
                setValue("limitPopulationText", newValue: newValue)
            }
        }
    }
    
    var limitGeneration:Int {
        get {
            return getValue("llimitGenerationText") ?? 0
        }
        set {
            if newValue != limitGeneration {
                setValue("limitGenerationText", newValue: newValue)
            }
        }
    }
    
    var mutationDeviant:Float {
        get {
            return (getValue("mutationDeviantText") ?? 0) / 100
        }
        set {
            if newValue != mutationDeviant {
                setValue("mutationDeviantText", newValue: Int(newValue * 100))
            }
        }
    }
    
    var typeProcriation:Bool {
        get {
            return getValue("typeProcriationSwitch") ?? false
        }
        set {
            if newValue != typeProcriation {
                setValue("typeProcriationSwitch", newValue: newValue)
            }
        }
    }
    
    var typeProcriationText:String {
        get {
            return getValue("typeProcriationLabel") ?? ProcriationType.auto.rawValue
        }
        set {
            if newValue != typeProcriationText {
                setValue("typeProcriationLabel", newValue: newValue)
            }
        }
    }
    
    var identity:String? {
        get {
            return self.getValue("identityLabel")
        }
        set {
            if newValue != self.identity {
                self.setValue("identityLabel", newValue: newValue!)
            }
        }
    }
    
    var fitness:String? {
        get {
            return getValue("fitnessLabel")
        }
        set {
            if newValue != fitness {
                setValue("fitnessLabel", newValue: fitness!)
            }
        }
    }
    
}
