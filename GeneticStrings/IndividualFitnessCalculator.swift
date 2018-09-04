//
//  IndividualFitnessCalculator.swift
//  GeneticStrings
//
//  Created by Mateus Leichsenring on 30.08.18.
//  Copyright © 2018 Mateus Leichsenring. All rights reserved.
//

import Foundation

class IndividualFitnessCalculator
{
    public static func CalculateFitness(_ objective:String,_ population:[Individual]) {
        for individual in population {
            let genesValue = GetGenesValue(objective, individual)
        
            let fitness = pow(2, Double(genesValue) / Double(objective.count)) - 1;
            individual.Fitness = Float(fitness) * 100;
        }
    }
    
    private static func GetGenesValue(_ objective:String,_ individual:Individual) -> Int {
        var countEqualsGene = 0
        for i in 0..<individual.Identity.count {
            let individualChar = individual.Identity.index(individual.Identity.startIndex, offsetBy: i)
            let objectiveChar = objective.index(objective.startIndex, offsetBy: i)
            if objective[individualChar] == individual.Identity[objectiveChar] {
                countEqualsGene += 1
            }
        }
    
        return countEqualsGene;
    }
}
