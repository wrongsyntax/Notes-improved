//
//  SettingsViewController.swift
//  Notes(improved)
//
//  Created by Uzair Tariq on 2022-11-14.
//

import UIKit

class SettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadDefaults()
    }
    
    // MARK: IBOutlet Definitions
    @IBOutlet private var minLabel: UILabel!
    @IBOutlet private var maxLabel: UILabel!
    @IBOutlet private var minSliderOutlet: UISlider!
    @IBOutlet private var maxSliderOutlet: UISlider!
    @IBOutlet private var sysDoubleTapToggleOutlet: UISwitch!
    
    // MARK: IBAction Definitions
    @IBAction func resetAllBtn(_ sender: Any) {
        let confirmationAlert = UIAlertController(
            title: "Reset all settings?",
            message: "This action cannot be undone.",
            preferredStyle: .alert)
        
        confirmationAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        confirmationAlert.addAction(UIAlertAction(title: "Reset", style: .destructive, handler: { _ in
            UserDefaults.resetDefaults()
            self.loadDefaults()
        }))
        
        self.present(confirmationAlert, animated: true)
    }
    
    @IBAction func sysDoubleTapToggle(_ sender: UISwitch) {
        if sender.isOn {
            updateUseSysDoubleTap(newValue: true)
        } else if !sender.isOn {
            updateUseSysDoubleTap(newValue: false)
        }
    }
    
    @IBAction func minSlider(_ sender: UISlider) {
        let currentVal: CGFloat = CGFloat(sender.value)
        updateMinForceValue(newValue: currentVal)
        minLabel.text = String(format: "%.3f", currentVal)
    }
 
    @IBAction func maxSlider(_ sender: UISlider) {
        let currentVal: CGFloat = CGFloat(sender.value)
        updateMaxForceValue(newValue: currentVal)
        maxLabel.text = String(format: "%.3f", currentVal)
    }
    
    // MARK: Update Defaults
    
    private func updateMinForceValue(newValue: CGFloat) {
        UserDefaults.minForceValue = newValue
    }
    
    private func updateMaxForceValue(newValue: CGFloat) {
        UserDefaults.maxForceValue = newValue
    }
    
    private func updateUseSysDoubleTap(newValue: Bool) {
        UserDefaults.useSystemDoubleTap = newValue
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    // TODO: implement function that checks type of UIView and uses `for each` to set values to UserDefault
    private func loadDefaults() {
        /// Load defaults and show them
        // Pressure bound sliders:
        minSliderOutlet.value = Float(UserDefaults.minForceValue)
        minLabel.text = String(format: "%.3f", UserDefaults.minForceValue)
        maxSliderOutlet.value = Float(UserDefaults.maxForceValue)
        maxLabel.text = String(format: "%.3f", UserDefaults.maxForceValue)
        
        // System double-tap setting toggle:
        sysDoubleTapToggleOutlet.isOn = UserDefaults.useSystemDoubleTap
    }

}

// https://www.avanderlee.com/swift/property-wrappers/#how-to-create-a-property-wrapper
@propertyWrapper
struct UserDefault<Value> {
    let key: String
    let defaultValue: Value
    var container: UserDefaults = .standard
    
    var wrappedValue: Value {
        get {
            return container.object(forKey: key) as? Value ?? defaultValue
        }
        set {
            container.set(newValue, forKey: key)
        }
    }
}

// MARK: Define Defaults
extension UserDefaults {
    @UserDefault(key: "min_force_value", defaultValue: 0.0)
    static var minForceValue: CGFloat
    
    @UserDefault(key: "max_force_value", defaultValue: 5.0)
    static var maxForceValue: CGFloat
    
    @UserDefault(key: "use_system_double_tap", defaultValue: true)
    static var useSystemDoubleTap: Bool
    
    static func resetDefaults() {
            if let bundleID = Bundle.main.bundleIdentifier {
                UserDefaults.standard.removePersistentDomain(forName: bundleID)
            }
        }
}
