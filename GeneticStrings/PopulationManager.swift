//
//  PopulationManager.swift
//  GeneticStrings
//
//  Created by Mateus Leichsenring on 31.08.18.
//  Copyright © 2018 Mateus Leichsenring. All rights reserved.
//

import Foundation

class PopulationManager {
    var objective:String
    var limitPopulation:Int
    var limitGeneration:Int
    var mutationDeviant:Float
    var type:ProcriationType
    
    init(objective:String, limitPopulation:Int, limitGeneration:Int, mutationDeviant: Float, type: ProcriationType) {
        self.objective = objective
        self.limitGeneration = limitGeneration
        self.limitPopulation = limitPopulation
        self.mutationDeviant = mutationDeviant
        self.type = type
    }
    
    func Procriate(_ backgroundWorker:BackgroundWorker?) {
        switch type {
        case .auto:
            AutoGenerate(backgroundWorker)
        case .fixed:
            FixedGenerate(backgroundWorker)
        }
    }
    
    private func AutoGenerate(_ backgroundWorker:BackgroundWorker?) {
        let populationCrafter = PopulationCrafter(bodyLength: objective.count, limitMultiplicatePopulation: 2, mutationDeviant: self.mutationDeviant)
        
        populationCrafter.Individuals = [populationCrafter.CreateIndividual(), populationCrafter.CreateIndividual()]
        
        var generationCount:Int = 0
        var bestIndividual:Individual
        repeat {
            if (backgroundWorker?.isCancelled)! { return }
            generationCount += 1
            populationCrafter.ProcreateByOldPopulation()
        
            IndividualFitnessCalculator.CalculateFitness(objective, populationCrafter.Individuals);
            populationCrafter.Individuals.sort() { $0.Fitness > $1.Fitness }
        
            bestIndividual = populationCrafter.Individuals.first!
            
            while (populationCrafter.Individuals.count > self.limitPopulation) {
                populationCrafter.EliminateWeaks(Int(Double(self.limitPopulation) * 0.80));
            }
            backgroundWorker?.reportProgress((bestIndividual, generationCount))
        } while (bestIndividual.Fitness < 100 && generationCount < self.limitGeneration)
        
        backgroundWorker?.result = (bestIndividual, generationCount)
    }
    
    private func FixedGenerate(_ backgroundWorker:BackgroundWorker?) {
        let populationCrafter = PopulationCrafter(bodyLength: objective.count)
        populationCrafter.Individuals = populationCrafter.CreateFirstPopulation(populationLimit: self.limitPopulation)
        
        IndividualFitnessCalculator.CalculateFitness(objective, populationCrafter.Individuals)
        populationCrafter.Individuals.sort() { $0.Fitness > $1.Fitness }
        var bestIndividuals = Array(populationCrafter.Individuals.prefix(self.limitPopulation / 2))
        
        var generationCount:Int = 0
        var bestIndividual:Individual
        repeat {
            if (backgroundWorker?.isCancelled)! { return }
            generationCount += 1
            populationCrafter.ProcreateBySelectedPopulation(oldIndividuals: bestIndividuals, populationLimit: self.limitPopulation)
            IndividualFitnessCalculator.CalculateFitness(objective, populationCrafter.Individuals)
            populationCrafter.Individuals.sort() { $0.Fitness > $1.Fitness }
            bestIndividuals = Array(populationCrafter.Individuals.prefix(self.limitPopulation / 2))
            
            bestIndividual = bestIndividuals.first!
            backgroundWorker?.reportProgress((bestIndividual, generationCount))
        } while (bestIndividual.Fitness < 100 && generationCount < self.limitGeneration)
        
        backgroundWorker?.result = (bestIndividual, generationCount)
    }
}

enum ProcriationType:String {
    case auto = "Auto", fixed = "Fixed"
}
