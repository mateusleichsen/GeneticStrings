//
//  PopulationCrafter.swift
//  GeneticStrings
//
//  Created by Mateus Leichsenring on 30.08.18.
//  Copyright © 2018 Mateus Leichsenring. All rights reserved.
//

import Foundation

class PopulationCrafter
{
    private var bodyLength:Int
    private var limitMultiplicatePopulation:Int
    private var mutationDeviant:Float
    private var randomCharacter:() -> Character = { RandomHelper.randomCharacter(minValue: 33, maxValue: 126) }
    
    public var Individuals:[Individual]!
    
    init(bodyLength:Int, limitMultiplicatePopulation:Int = 2, mutationDeviant:Float = 0.2)
    {
        self.bodyLength = bodyLength
        self.limitMultiplicatePopulation = limitMultiplicatePopulation
        self.mutationDeviant = mutationDeviant
    }
    
    public func ProcreateByOldPopulation()
    {
        Individuals = MatchPopulation(oldPopulation: Individuals)
        Individuals = MutatePopulation(Individuals)
    }
    
    public func ProcreateBySelectedPopulation(oldIndividuals:[Individual], populationLimit:Int)
    {
        Individuals = MatchPopulation(oldPopulation: oldIndividuals, populationLimit: populationLimit)
        Individuals = MutatePopulation(Individuals)
    }
    
    private func MutatePopulation(_ population: [Individual]) -> [Individual]
    {
        var newPopulation = population
        for _ in 0...Int(Float(newPopulation.count) * mutationDeviant)
        {
            let index = RandomHelper.random(newPopulation.count)
            newPopulation[index] = Mutate(individual: population[index])
        }
        
        return newPopulation
    }
    
    private func MatchPopulation(oldPopulation:[Individual]) -> [Individual]
    {
        return MatchPopulation(oldPopulation: oldPopulation, populationLimit: oldPopulation.count * limitMultiplicatePopulation)
    }
    
    private func MatchPopulation(oldPopulation:[Individual], populationLimit:Int) -> [Individual] {
        var newPopulation = [Individual]()
        
        repeat
        {
            let firstIndividualIndex = RandomHelper.random(oldPopulation.count - 1)
            let secondIndividualIndex = RandomHelper.random(oldPopulation.count - 1)
            
            let firstIndividual = oldPopulation[firstIndividualIndex]
            let secondIndividual = oldPopulation[secondIndividualIndex]
            
            let nextGeneration = Crossover(firstIndividual: firstIndividual, secondIndividual: secondIndividual)
            
            newPopulation.append(contentsOf: nextGeneration)
        } while (newPopulation.count < populationLimit)
        
        return newPopulation
    }
    
    public func EliminateWeaks(_ takeQuantity:Int) {
        Individuals.sort(by: {
            if $0.Fitness > $1.Fitness {
                return true
            } else {
                return false
            }
        })
        Individuals = Array(Individuals.prefix(takeQuantity))
    }
    
    public func Crossover(firstIndividual:Individual, secondIndividual:Individual) -> [Individual] {
        let bodySeparation = firstIndividual.Identity.count / 2
        let oddGene = firstIndividual.Identity.count % 2
    
        let oneIdentityFirstPart = firstIndividual.Identity.prefix(bodySeparation + oddGene)
        let twoIdentityFirstPart = secondIndividual.Identity.prefix(bodySeparation + oddGene)
        let oneIdentityLastPart = firstIndividual.Identity.suffix(bodySeparation)
        let twoIdentityLastPart = secondIndividual.Identity.suffix(bodySeparation)
    
        let individualChildOne = Individual(identity: String(oneIdentityFirstPart + twoIdentityLastPart))
        let individualChildTwo = Individual(identity: String(twoIdentityFirstPart + oneIdentityLastPart))
    
        return [ individualChildOne, individualChildTwo ]
    }
    
    private func Mutate(individual:Individual) -> Individual {
        return Mutate(identity: individual.Identity)
    }
    
    private func Mutate(identity:String) -> Individual {
        var individualMutated = identity
        while identity == individualMutated {
            for _ in 0...Int(Float(identity.count) * self.mutationDeviant)
            {
                let randomIndex = RandomHelper.random(identity.count)
                let geneToMutateIndex = individualMutated.index(individualMutated.startIndex, offsetBy: randomIndex)
                let gene = randomCharacter()
                
                individualMutated = individualMutated.replacingCharacters(in: geneToMutateIndex...geneToMutateIndex, with: String(gene))
            }
        }
        return Individual(identity: individualMutated)
    }
    
    public func CreateFirstPopulation(populationLimit:Int) -> [Individual] {
        var population = [Individual]()
    
        for _ in 0...populationLimit {
            let individual = CreateIndividual()
            population.append(individual)
        }
    
        return population;
    }
    
    public func CreateIndividual() -> Individual {
        var identity = "";
    
        for _ in 0..<self.bodyLength
        {
            let gene = randomCharacter()
            identity.append(String(gene))
        }
        
        return Individual(identity: identity)
    }
}
