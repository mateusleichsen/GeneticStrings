//
//  ViewController.swift
//  GeneticStrings
//
//  Created by Mateus Leichsenring on 30.08.18.
//  Copyright © 2018 Mateus Leichsenring. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITextFieldDelegate,UIPopoverPresentationControllerDelegate {
    var viewModel:ViewModel!
    var popoverController:TextPopoverViewController?
    @IBOutlet weak var objectiveText: UITextField!
    @IBOutlet weak var limitPopulationText: UITextField!
    @IBOutlet weak var limitGenerationText: UITextField!
    @IBOutlet weak var mutationDeviantSlider: UISlider!
    @IBOutlet weak var typeProcriationSwitch: UISwitch!
    @IBOutlet weak var typeProcriationLabel: UILabel!
    @IBOutlet weak var goButton: UIButton!
    @IBOutlet weak var identityLabel: UILabel!
    @IBOutlet weak var fitnessLabel: UILabel!
    @IBOutlet weak var generationLabel: UILabel!
    var inputAccessoryLabel:UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.objectiveText.delegate = self
        self.limitPopulationText.delegate = self
        self.limitGenerationText.delegate = self
        
        inputAccessoryLabel = UITextField(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50))
        inputAccessoryLabel.textAlignment = .center
        inputAccessoryLabel.backgroundColor = UIColor.lightGray
        self.objectiveText.inputAccessoryView = inputAccessoryLabel
        self.limitGenerationText.inputAccessoryView = inputAccessoryLabel
        self.limitPopulationText.inputAccessoryView = inputAccessoryLabel
        
        let uiComponentViewWrapper = UIComponentViewWrapper(viewController: self)
        viewModel = ViewModel(uiComponentViewWrapper: uiComponentViewWrapper, viewController: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        self.inputAccessoryLabel.text = ""
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        self.inputAccessoryLabel.text = ""
        return false
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }
    
    func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {
        self.popoverController = nil
    }
}
