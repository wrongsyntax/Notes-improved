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
        updateMinForceValue(newValue: 0.1)
        updateMaxForceValue(newValue: 3)
        // Do any additional setup after loading the view.
    }
    
    // MARK: Update Defaults
    
    private func updateMinForceValue(newValue: CGFloat) {
        UserDefaults.minForceValue = newValue
    }
    
    private func updateMaxForceValue(newValue: CGFloat) {
        UserDefaults.maxForceValue = newValue
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

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
}
