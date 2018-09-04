# GeneticStrings
App using MVVM pattern with customized bindings, validations and thread manager.
I used the ViewController only to manage configurations for buttons and text, things that isn's going to use data. And in the ViewModel where I manage and format all data that will be showed in the View.
My data doesn't come from a file or database, but from class PopulationManager. And that part is the Model.

The binding system is customized, where I get all UIButton, UILabel, UITextView, UITextField, UISwitch, UISlider. I use Mirror to get from the ViewController those components.
For each one I configured to receive a data or return the value or to set a command.
Since I need convert the UIView to a specific type (e.g. UILabel) to set a value. I only have implemented for those I needed, for other component it is necessary to add in the UIViewBinding.
(Mirror doesn't have a feature to set a value in a property, so I could use it to find the property "text", "isOn" or "value")

Toast.swift from: 
- https://github.com/Rannie/Toast-Swift

Validation references:
- https://medium.com/@sandshell811/generic-way-to-validate-textfield-inputs-in-swift-3-cc031b1e651e
- https://richa0305.wordpress.com/2015/08/14/ios-uitextfield-validation-in-swift-with-popups/
