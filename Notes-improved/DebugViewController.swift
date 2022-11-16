//
//  DebugViewController.swift
//  Notes(improved)
//
//  Created by Uzair Tariq on 2022-11-14.
//

import UIKit

class DebugViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        clearGauges()
        minForceLabel.text = String(format: "%.3f", UserDefaults.minForceValue)
        maxForceLabel.text = String(format: "%.3f", UserDefaults.maxForceValue)
    }
    
    // MARK: IBOutlet definitions
    @IBOutlet private var forceLabel: UILabel!
    @IBOutlet private var azimuthLabel: UILabel!
    @IBOutlet private var altitudeLabel: UILabel!
    @IBOutlet private var touchTypeLabel: UILabel!
    @IBOutlet private var locationLabel: UILabel!
    @IBOutlet private var maxForceLabel: UILabel!
    @IBOutlet private var minForceLabel: UILabel!
    
    @IBOutlet private var gaugeLabelCollection: [UILabel]!
    
    // MARK: Touch Handling
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        touches.forEach { (touch) in
            updateGauges(with: touch)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        touches.forEach { (touch) in
            updateGauges(with: touch)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        touches.forEach { (touch) in
            clearGauges()
        }
    }
    
    private func boundForceValue(with touch: UITouch) -> CGFloat {
        var boundedForceValue: CGFloat = touch.force
        let minValue: CGFloat = UserDefaults.minForceValue
        let maxValue: CGFloat = UserDefaults.maxForceValue
        
        if touch.type == .pencil {
            if boundedForceValue > maxValue {
                boundedForceValue = maxValue
            } else if boundedForceValue < minValue {
                boundedForceValue = minValue
            }
        }
        
        return boundedForceValue
    }
    
    // MARK: Updating Gauges
    private func updateGauges(with touch: UITouch) {
        // TODO: Display min and max values that are stored in UserDefaults
        forceLabel.text = String(format: "%.3f", boundForceValue(with: touch))
        minForceLabel.text = String(format: "%.3f", UserDefaults.minForceValue)
        maxForceLabel.text = String(format: "%.3f", UserDefaults.maxForceValue)
        
        azimuthLabel.text = String(format: "%.3f", touch.azimuthAngle(in: view)) + " rad"
        altitudeLabel.text = String(format: "%.3f", touch.altitudeAngle) + " rad"
        
        locationLabel.text = "(\(String(format: "%.3f", touch.preciseLocation(in: view).x)), " +
                              "\(String(format: "%.3f", touch.preciseLocation(in: view).y)))"
        
        switch touch.type {
        case .pencil:
            touchTypeLabel.text = "Pencil"
        case .direct:
            touchTypeLabel.text = "Direct"
        case .indirect:
            touchTypeLabel.text = "Indirect"
        case .indirectPointer:
            touchTypeLabel.text = "Indirect Pointer"
        default:
            touchTypeLabel.text = "Unknown"
        }
    }
    
    private func clearGauges() {
        gaugeLabelCollection.forEach { (label) in
            label.text = "***"
        }
    }

}

