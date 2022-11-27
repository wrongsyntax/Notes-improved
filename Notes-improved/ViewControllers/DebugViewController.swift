//
//  DebugViewController.swift
//  Notes(improved)
//
//  Created by Uzair Tariq on 2022-11-14.
//  Copyright © 2022 Uzair Tariq. All rights reserved.
//

import UIKit


class DebugViewController: UIViewController, UIPencilInteractionDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeNavBar()
        
        if #available(iOS 12.1, *) {
            let pencilInteraction = UIPencilInteraction()
            pencilInteraction.delegate = self
            view.addInteraction(pencilInteraction)
        }
        
        clearGauges()
        minForceLabel.text = String(format: "%.3f", UserDefaults.minForceValue)
        maxForceLabel.text = String(format: "%.3f", UserDefaults.maxForceValue)
        doubleTapSettingLabel.text = String(UserDefaults.useSystemDoubleTap)
        
        doubleTapLabel.alpha = 0
    }
    
    // MARK: IBOutlet definitions
    @IBOutlet private var forceLabel: UILabel!
    @IBOutlet private var azimuthLabel: UILabel!
    @IBOutlet private var altitudeLabel: UILabel!
    @IBOutlet private var touchTypeLabel: UILabel!
    @IBOutlet private var locationLabel: UILabel!
    @IBOutlet private var maxForceLabel: UILabel!
    @IBOutlet private var minForceLabel: UILabel!
    @IBOutlet private var doubleTapLabel: UILabel!
    @IBOutlet private var doubleTapSettingLabel: UILabel!
    
    @IBOutlet private var gaugeLabelCollection: [UILabel]!
    
    @IBAction func dismissDebugButton(_ sender: Any) {
        dismiss(animated: true)
    }
    
    // MARK: Touch Handling
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        touches.forEach { (touch) in
            updateGauges(with: touch)
            
            let debugPointerView = initializeDebugPointerView(x: 0, y: 0)
            view.addSubview(debugPointerView)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        touches.forEach { (touch) in
            updateGauges(with: touch)
            updateDebugPointer(with: touch, scalingFactor: 10)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        touches.forEach { (touch) in
            clearGauges()
            
            for subview in self.view.subviews {
                if (subview.restorationIdentifier == "pointerView") {
                    subview.removeFromSuperview()
                }
            }
        }
    }
    
    // MARK: Updating Gauges
    private func updateGauges(with touch: UITouch) {
        // Update settings labels
        minForceLabel.text = String(format: "%.3f", UserDefaults.minForceValue)
        maxForceLabel.text = String(format: "%.3f", UserDefaults.maxForceValue)
        doubleTapSettingLabel.text = String(UserDefaults.useSystemDoubleTap)
        
        forceLabel.text = String(format: "%.3f", boundedForceValue(with: touch))
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
    
    // MARK: Pencil Interaction
    @available(iOS 12.1, *)
    func pencilInteractionDidTap(_ interaction: UIPencilInteraction) {
        if UserDefaults.useSystemDoubleTap {
            switch UIPencilInteraction.preferredTapAction {
            case .switchPrevious:
                showPencilInteraction(label: doubleTapLabel, str: "Switch Previous")
            case .showColorPalette:
                showPencilInteraction(label: doubleTapLabel, str: "Show Colour Palette")
            case .showInkAttributes:
                showPencilInteraction(label: doubleTapLabel, str: "Show Ink Attributes")
            case .switchEraser:
                showPencilInteraction(label: doubleTapLabel, str: "Switch Eraser")
            case .ignore:
                showPencilInteraction(label: doubleTapLabel, str: "Ignored")
            default:
                showPencilInteraction(label: doubleTapLabel, str: "Default Case")
            }
        } else {
            showPencilInteraction(label: doubleTapLabel, str: "Custom")
        }
    }
    
    // MARK: Convenience
    private func clearGauges() {
        gaugeLabelCollection.forEach { (label) in
            label.text = "***"
        }
    }
    
    private func boundedForceValue(with touch: UITouch) -> CGFloat {
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
    
    private func showPencilInteraction(label: UILabel, str: String) {
        label.text = str
        label.alpha = 1
        label.fadeOutAnimation(duration: 0.5, delay: 0.3)
    }
    
    private func initializeDebugPointerView(x atX: CGFloat, y atY: CGFloat) -> UIView {
        let pointerView = UIView()
        pointerView.restorationIdentifier = "pointerView"
        
        return pointerView
    }
    
    private func updateDebugPointer(with touch: UITouch, scalingFactor: CGFloat) {
        let location = touch.preciseLocation(in: view)
        let rectSize = boundedForceValue(with: touch) * scalingFactor
        
        for subview in self.view.subviews {
            if (subview.restorationIdentifier == "pointerView") {
                subview.center = touch.preciseLocation(in: view)
                
                subview.frame = CGRect(origin: CGPoint(x: location.x - (rectSize/2), y: location.y - (rectSize/2)),
                                       size: CGSize(width: rectSize, height: rectSize))
                
                subview.layer.borderColor = CGColor(red: 0.067, green: 0.682, blue: 0.569, alpha: 1)
                subview.layer.borderWidth = 2
                subview.layer.backgroundColor = CGColor(red: 0.067, green: 0.682, blue: 0.569, alpha: 0.2)
                subview.layer.cornerRadius = rectSize / 2
            }
        }
    }
    
    // MARK: Nav Bar
    private func initializeNavBar() {
        navigationItem.title = "Debug"
        
        var navBarRightItems: [UIBarButtonItem] = []
        let hierarchicalConfig = { (colour: UIColor) -> UIImage.SymbolConfiguration in
            return UIImage.SymbolConfiguration(hierarchicalColor: colour)
        }
        
        // Definitions
        let settingsImage = UIImage(systemName: "gearshape.circle", withConfiguration: hierarchicalConfig(UIColor.label))
        let settingsBarButton = UIBarButtonItem(image: settingsImage, style: .plain, target: self, action: #selector(didTapSettingsButton))
        
        navBarRightItems.append(settingsBarButton)
        
        navigationItem.rightBarButtonItems = navBarRightItems
    }
    
    @objc func didTapSettingsButton() {
        performSegue(withIdentifier: "debugViewToSettingsModalSegue", sender: self)
    }

}

