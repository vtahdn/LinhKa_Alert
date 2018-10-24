//
//  ViewController.swift
//  LinhKa_Alert
//
//  Created by Viet Asc on 10/24/18.
//  Copyright © 2018 Viet Asc. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var alertButton: UIButton!
    
    var alertView: UIView!
    var animator: UIDynamicAnimator!
    var attachmentBehavior: UIAttachmentBehavior!
    var snapBehavior: UISnapBehavior!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        animator = UIDynamicAnimator(referenceView: view)
        alertButton.layer.cornerRadius = 5
        alertButton.layer.borderWidth = 1
    }
    
    @objc func handlePan(gesture: UIPanGestureRecognizer) {
        if alertView != nil {
            let panLocationInView = gesture.location(in: view)
            let panLocationInAlertView = gesture.location(in: alertView)
            if gesture.state == .began {
                let offset = UIOffset(horizontal: panLocationInAlertView.x - alertView.bounds.midX, vertical: panLocationInAlertView.y - alertView.bounds.midY)
                attachmentBehavior = UIAttachmentBehavior(item: alertView, offsetFromCenter: offset, attachedToAnchor: panLocationInView)
                animator.addBehavior(attachmentBehavior)
            } else if gesture.state == .changed {
                // Moving
                attachmentBehavior.anchorPoint = panLocationInView
            } else if gesture.state == .ended {
                animator.removeAllBehaviors()
                snapBehavior = UISnapBehavior(item: alertView, snapTo: view.center)
            }
            if panLocationInView.y >= self.view.bounds.height - 50 {
                animator.removeAllBehaviors()
                self.alertView.removeFromSuperview()
                self.alertView = nil
            }
        }
    }
    
    @objc func dismissAlert() {
        
        animator.removeAllBehaviors()
        UIView.animate(withDuration: 0.5, animations: {
            self.alertView.alpha = 0.0
        }) { (finished) in
            self.alertView.removeFromSuperview()
            self.alertView = nil
        }
    
    }
    
    func createGestureRecognizer() {
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        view.addGestureRecognizer(panGestureRecognizer)
    }
    
    func addButton(title: String, x: CGFloat, y: CGFloat, w: CGFloat, h: CGFloat, v: UIView) {
        let button = UIButton(type: .custom)
        button.setTitle(title , for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .white
        button.frame = CGRect(x: x, y: y, width: w, height: h)
        button.addTarget(self, action: #selector(dismissAlert), for: .touchUpInside)
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 1
        v.addSubview(button)
    }
    
    func createAlert() {
        let alertWidth: CGFloat = 250
        let alertHeight: CGFloat = 150
        let buttonWidth: CGFloat = 40
        let alertViewFrame = CGRect(x: 0, y: 0, width: alertWidth, height: alertHeight)
        alertView = UIView(frame: alertViewFrame)
        alertView.backgroundColor = .black
        alertView.alpha = 0
        // Decoration
        alertView.layer.cornerRadius = 10
        alertView.layer.shadowColor = UIColor.black.cgColor
        alertView.layer.shadowOffset = CGSize(width: 0, height: 5)
        alertView.layer.shadowOpacity = 0.3
        alertView.layer.shadowRadius = 10.0
        // Dismiss Button
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "dismiss"), for: .normal)
        button.backgroundColor = UIColor.clear
        button.frame = CGRect(x: alertWidth/2 - buttonWidth/2, y: -buttonWidth/2, width: buttonWidth, height: buttonWidth)
        button.addTarget(self, action: #selector(dismissAlert), for: .touchUpInside)
        let rect = CGRect(x: 0, y: button.frame.origin.y + button.frame.height - 10, width: alertWidth, height: alertHeight - buttonWidth)
        let label = UILabel(frame: rect)
        // Auto return if the sentence is too long.
        label.numberOfLines = 0
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.text = "Linh Ka Team ..."
        label.textAlignment = .center
        label.textColor = .white
        alertView.addSubview(label)
        alertView.addSubview(button)
        // Cancel Button
        addButton(title: "Cancel", x: 140, y: 110, w: 80, h: 30, v: alertView)
        // Ok Button
        addButton(title: "Ok", x: 30, y: 110, w: 80, h: 30, v: alertView)
        view.addSubview(alertView)
    }
    
    func showAlert() {
        if alertView == nil {
            createAlert()
        }
        // Pan gesture
        createGestureRecognizer()
        
        animator.removeAllBehaviors()
        
        alertView.alpha = 1.0
        let snapBehavior = UISnapBehavior(item: alertView, snapTo: view.center)
        animator.addBehavior(snapBehavior)
    }
    

    @IBAction func alertAction(_ sender: UIButton) {
        showAlert()
    }
    
    
    
    
    
    
    
    
    
    
}

