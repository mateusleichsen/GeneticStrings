//
//  ViewModel.swift
//  GeneticStrings
//
//  Created by Mateus Leichsenring on 30.08.18.
//  Copyright © 2018 Mateus Leichsenring. All rights reserved.
//

import Foundation
import UIKit

class ViewModel:ViewModelBase {
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
            guard let value:String = getValue("limitPopulationText"), value != "" else { return 0 }
            return Int(value) ?? 0
        }
        set {
            if newValue != limitPopulation {
                setValue("limitPopulationText", newValue: String(newValue))
            }
        }
    }
    
    var limitGeneration:Int {
        get {
            guard let value:String = getValue("limitGenerationText"), value != "" else { return 0 }
            return Int(value) ?? 0
        }
        set {
            if newValue != limitGeneration {
                setValue("limitGenerationText", newValue: String(newValue))
            }
        }
    }
    
    var mutationDeviant:Float {
        get {
            return getValue("mutationDeviantSlider")!
        }
        set {
            if newValue != mutationDeviant {
                setValue("mutationDeviantSlider", newValue: newValue)
            }
        }
    }
    
    var typeProcriation:Bool {
        get {
            return getValue("typeProcriationSwitch")!
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
    
    var inputAccessoryText:String {
        get {
            return getValue("inputAccessoryLabel") ?? ""
        }
        set {
            if newValue != inputAccessoryText {
                setValue("inputAccessoryLabel", newValue: newValue)
            }
        }
    }
    
    var identity:String? {
        get {
            return getValue("identityLabel")
        }
        set {
            if newValue != identity {
                setValue("identityLabel", newValue: newValue!)
            }
        }
    }
    
    var fitness:Float {
        get {
            guard let value:String = getValue("fitnessLabel"), value != "" else { return 0 }
            return (Float(value) ?? 0) / 100
        }
        set {
            if newValue != fitness {
                setValue("fitnessLabel", newValue: "\(newValue)%")
            }
        }
    }
    
    var generation:Int {
        get {
            guard let value:String = getValue("generationLabel"), value != "" else { return 0 }
            return Int(value) ?? 0
        }
        set {
            if newValue != generation {
                setValue("generationLabel", newValue: String(newValue))
            }
        }
    }
    var backgroundWorker:BackgroundWorker
    var populationManager:PopulationManager?
    weak var viewController:ViewController?
    var validation:Validation
    
    convenience init(uiComponentViewWrapper: UIComponentViewWrapper, viewController:ViewController) {
        self.init(uiComponentViewWrapper: uiComponentViewWrapper)
        self.viewController = viewController
    }
    
    required init(uiComponentViewWrapper: UIComponentViewWrapper) {
        self.backgroundWorker = BackgroundWorker()
        self.viewController = nil
        self.validation = Validation()
        super.init(uiComponentViewWrapper: uiComponentViewWrapper)
        
        setCommands()
        
        backgroundWorker.doWork = self.doWork
        backgroundWorker.progressChanged = self.progressChanged
        backgroundWorker.workCompleted = self.workCompleted
        
        validation.register(values: ("objectiveText", uiViews["objectiveText"]!, ValidationType.alphabeticString))
        validation.register(values: ("limitPopulationText", uiViews["limitPopulationText"]!, ValidationType.onlyNumber))
        validation.register(values: ("limitGenerationText", uiViews["limitGenerationText"]!, ValidationType.onlyNumber))
    }
    
    fileprivate func setCommands() {
        command("goButton", self, action: #selector(goButtonTapped), for: .touchUpInside)
        command("typeProcriationSwitch", self, action: #selector(typeProcriationChanged), for: .valueChanged)
        command("mutationDeviantSlider", self, action: #selector(sliderChanged), for: .valueChanged)
        command("objectiveText", self, action: #selector(textChanged), for: .editingChanged)
        command("limitGenerationText", self, action: #selector(textChanged), for: .editingChanged)
        command("limitPopulationText", self, action: #selector(textChanged), for: .editingChanged)
    }
    
    @objc func goButtonTapped(_ sender: UIButton) {
        if backgroundWorker.isRunning { backgroundWorker.cancel(); setValue("goButton", newValue: "Go!"); return }
        
        let resultValidations = validation.validateTextFields()
        var isValid = true
        var showPopover = false
        for result in resultValidations {
            if showPopover { break }
            switch result {
            case .success:
                break
            case .failure(let viewKey, let messageType, let message):
                if messageType == .emptyValue {
                    setPlaceHolderEmptyField(textField: uiViews[viewKey] as! UITextField)
                    animationShakeView(viewKey: viewKey)
                } else {
                    showPopoverValidationMessage(messageType.localized(), uiViews[viewKey]!)
                    print(message)
                    showPopover = true
                }
                isValid = false
            }
        }
        
        if !isValid { return }
        
        populationManager = PopulationManager(objective: self.objective!, limitPopulation: self.limitPopulation, limitGeneration: self.limitGeneration, mutationDeviant: self.mutationDeviant, type: self.typeProcriation ? .auto : .fixed)
        backgroundWorker.start()
        setValue("goButton", newValue: "Cancel")
    }
    
    @objc func typeProcriationChanged(_ sender: UISwitch) {
        self.typeProcriationText = self.typeProcriation ? ProcriationType.auto.rawValue : ProcriationType.fixed.rawValue
    }
    
    let step:Float = 5
    var previousValue:Float = 0
    @objc func sliderChanged(_ sender:UISlider) {
        let roundedValue = (round(mutationDeviant * 100 / step) * step) / 100
        mutationDeviant = roundedValue
        if previousValue != mutationDeviant {
            previousValue = mutationDeviant
            viewController?.view.makeToast("\(mutationDeviant)%")
        }
    }
    
    @objc func textChanged(_ sender: UITextField) {
        inputAccessoryText = sender.text ?? "?"
    }
    
    func doWork() {
        populationManager?.Procriate(self.backgroundWorker)
    }
    
    func progressChanged(_ progress:Any) {
        setResultLabels(progress)
    }
    
    func workCompleted(_ result:Any?) {
        setResultLabels(result)
        
        setValue("goButton", newValue: "Go!")
    }
    
    func setPlaceHolderEmptyField(textField:UITextField) {
        textField.attributedPlaceholder = NSAttributedString(string: "That field cannot be empty", attributes: [NSAttributedStringKey.foregroundColor: UIColor.red])
    }
    
    func animationShakeView(viewKey:String){
        guard let view = uiViews[viewKey] else { return }
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.07
        animation.repeatCount = 4
        animation.autoreverses = true
        animation.fromValue = CGPoint(x: view.center.x - 5, y: view.center.y)
        animation.toValue = CGPoint(x: view.center.x + 5, y: view.center.y)
        view.layer.add(animation, forKey: "position")
    }
    
    func showPopoverValidationMessage(_ message:String,_ view:UIView) {
        viewController?.popoverController = viewController?.storyboard?.instantiateViewController(withIdentifier: "textPopoverView") as? TextPopoverViewController
        
        viewController?.popoverController?.modalPresentationStyle = .popover
        viewController?.popoverController?.preferredContentSize = CGSize(width:350,height: 50)
        viewController?.popoverController?.popoverPresentationController?.delegate = viewController
        viewController?.popoverController?.message = message
        
        viewController?.popoverController?.popoverPresentationController?.sourceView = view
        viewController?.popoverController?.popoverPresentationController?.sourceRect = view.bounds
        
        viewController?.present((viewController?.popoverController)!, animated: true, completion: nil)
    }
    
    fileprivate func setResultLabels(_ result: Any?) {
        guard let resultIdentity = result as? (bestIndividual:Individual, generationCount:Int) else { return }
        self.identity = resultIdentity.bestIndividual.Identity
        self.fitness = resultIdentity.bestIndividual.Fitness
        self.generation = resultIdentity.generationCount
    }
}
