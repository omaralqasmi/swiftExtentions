//
//  UIButtonActionExt.swift
//  Created by LYNX ART on 09/05/2021.
//

import UIKit
import AVFoundation

extension UIButton {
/**
     Use it to add functions as button actions and *optionally* to add button touch animation
          
     * USAGE:
      
          1. Connect a button as outlet
          2. In viewDidLoad add action to the button by using a clouser or a function
       
     * EXAMPLES:
       
         using a clouser:
         ````
         btn.setActionExt(action: { [self] in
          print("EXECUTE THE BUTTON ACTION")
         }, animations: [.fade], feedback: .soft)
         ````

         using a function:
         ````
         btn.setActionExt(action: sampleFunction, animations: [.scale], feedback: .soft)
         func sampleFunction() {
          print("EXECUTE THE BUTTON ACTION")
         }
         ````

         without animations and feedback:
         ````
         btn.setActionExt(action: sampleFunction)
         ````
         
         full example:
         ````
         @IBOutlet weak var btn: UIButton!
         
         override func viewDidLoad() {
             super.viewDidLoad()
             addActionsToButtons()
         }
         
         func addActionsToButtons(){
             btn.setActionExt(action: sampleFunction, animations: [.fade, .scale], feedback: .soft)
         }
         
         func sampleFunction() {
             print("EXECUTE THE BUTTON ACTION")
         }
         ````
     
        Adding multiple actions
        ````
        @IBOutlet weak var btn: UIButton!

        override func viewDidLoad() {
         super.viewDidLoad()
         addActionsToButtons()
        }

        func addActionsToButtons(){
         btn.setActionExt(action: { [self] in
             run1()
             run2()
             run3()
             run4()
             run5()
             return nil
         }, animations: [.fade, .scale], feedback: .light)
        }

        func run1() {
         print("RUN 1")
        }

        func run2() {
         print("RUN 2")
        }

        func run3() {
         print("RUN 3")
        }

        func run4() {
         print("RUN 4")
        }

        func run5() {
         print("RUN 5")
        }
        ````
      
     * TO ADD YOUR OWN ANIMATIONS:
          
          (1) Add  new entery to the enum. *below the pragma MARK*
          ````
          //MARK: - UIButton animations names
          enum ButtonAnimationType {
              ...
              case yournew
          }
          ````
          
          (2)  Add animations for both touchDown & touchUp as functions. *below the pragma MARK*
          ````
          //MARK: - UIButton touch animations
          func yourTouchDownAnimation() {
              UIView.animate(withDuration: 0.05, delay: 0) {
                  //your new animation
              }
          }
          func yourTouchUpAnimation() {
              UIView.animate(withDuration: 0.2, delay: 0) {
                  //your new animation
              }
          }
          ````
          
          (3)  Add switch case options with your animation for both tuchDown & touchUp. *below Start animating*
          ````
          //Start animating
          func downAnimation(){
             for anim in animations {
                 switch anim {
                 ...
                 case .yournew:
                     self.yourTouchDownAnimation()
                 }
             }
          }
     
          func upAnimation(){
             for anim in animations {
                 switch anim {
                 ...
                 case .yournew:
                     self.yourTouchUpAnimation()
                 }
             }

          }
          ````
     - Note:
          - you can add more than one action to the button, see the examples
     
     - Important:
          - Avoid calling this function in viewDidAppear if not intended, because just avoid it

     - Parameters:
         - action: select a local function to be excecuted when button clicked
         - animations: add an array of button animations ex. [.fade, .scale], Default animation types none = no animation,  scale = shrink the button on touchDown, fade = reduce the button opacity on touchDown
         - feedback: add a haptic feedback to touchDown

     - Author:
         Omar Al Qasmi
     - Version:
         2.0 (iOS 12 support)
*/
    
    func setActionExt(action: (@escaping () -> Void?), animations: [ButtonAnimationType] = [.none], feedback: VibrationFeedback = .none)  {
        
        self.voidAction = action
        self.animations = animations
        self.feedback = feedback
        
    }
    private struct Holder {
        static var action = [String:(() -> Void?)]()
        static var animations : [String:[ButtonAnimationType]] = ["":[.none]]
        static var feedback : [String:VibrationFeedback] = ["":.none]
        static var incrementer = 0
        //Logging
        static let logging: Bool = false

    }
    private var voidAction : (() -> Void?)? {
        get{
            return Holder.action[getTag()] ?? nil
        }
        set(newValue){
            Holder.action[getTag()] = newValue
            //MARK: - ADD Touch events to the UIButton
            self.addTarget(self, action: #selector(touchDown), for: .touchDown)
            self.addTarget(self, action: #selector(touchUpInside), for: .touchUpInside)
            self.addTarget(self, action: #selector(touchDragExit), for: .touchDragExit)
            self.addTarget(self, action: #selector(touchDragEnter), for: .touchDragEnter)
            self.addTarget(self, action: #selector(touchUpOutside), for: .touchUpOutside)
            self.addTarget(self, action: #selector(touchCancel), for: .touchCancel)
        }
    }
    private var feedback : VibrationFeedback {
        get{
            return Holder.feedback[getTag()] ?? .none
        }
        set(newValue){
            Holder.feedback[getTag()] = newValue
        }
    }
    private var animations : [ButtonAnimationType] {
        get{
            return Holder.animations[getTag()] ?? [.none]
        }
        set(newValue){
            Holder.animations[getTag()] = newValue
        }
    }
    private func getTag() -> String {
        
        let tag=self.tag
        if tag==0 {
            self.tag=Int(Date().timeIntervalSince1970.rounded()) + Holder.incrementer
            Holder.incrementer += 1
        }
        return String(self.tag)
    }

    //MARK: - functions to handle touch events
    //Handlers
    @objc private func touchDown() {
            printLogs("button touchDown")
            UIDevice.touchDownFeedBack(feedback)
            downAnimation()
        }
    @objc private func touchDragExit() {
            printLogs("button touchDragExit")
            upAnimation()
        }
    @objc private func touchDragEnter() {
            printLogs("button touchDragEnter")
            downAnimation()
        }
    @objc private func touchUpOutside() {
            printLogs("button touch touchUpOutside")
        }
    @objc private func touchCancel() {
            printLogs("button touchCancel")
            upAnimation()
        }

    @objc private func touchUpInside() {
            printLogs("button touchUpInside")
            upAnimation()
            //Execute Action
            printLogs("button Execute Action")
            voidAction!()
    }
    //Start animating
    private func downAnimation(){
        for anim in animations {
            switch anim {
            case .none:
                printLogs("button down animation => none")
            case .fade:
                printLogs("button down animation => fade")
                self.touchDownAnimAlpha()
            case .scale:
                printLogs("button down animation => scale")
                self.touchDownAnimScale()
            }
        }
    }
    private func upAnimation(){
        for anim in animations {
            switch anim {
            case .none:
                printLogs("button up animation => none")
            case .fade:
                printLogs("button up animation => fade")
                self.touchUpAnimAlpha()
            case .scale:
                printLogs("button up animation => scale")
                self.touchUpAnimScale()
            }

        }
    }

    //MARK: - UIButton touch animations
    
    //Scale
    private func touchDownAnimScale() {
        UIView.animate(withDuration: 0.05, delay: 0) {
            self.transform = .init(scaleX: 0.95, y: 0.95)
        }
    }
    
    private func touchUpAnimScale() {
        UIView.animate(withDuration: 0.2, delay: 0.05) {
            self.transform = .init(scaleX: 1, y: 1)
        }
    }
    
    //Fade
    private func touchDownAnimAlpha() {
        UIView.animate(withDuration: 0.05, delay: 0) {
            self.alpha = 0.5
        }
    }
    
    private func touchUpAnimAlpha() {
        UIView.animate(withDuration: 0.2, delay: 0) {
            self.alpha = 1
        }
    }
    
    
    
    //Debug logging
    private func printLogs(_ msg: String){
        if Holder.logging {
            print(msg)
        }
    }

    
    //MARK: - UIButton animations names
    enum ButtonAnimationType {
        case none
        case scale
        case fade
    }

}

//MARK: - Vibration feedback
//Inspired by muhasturk answer - https://stackoverflow.com/questions/26455880/how-to-make-iphone-vibrate-using-swift/57162220
enum VibrationFeedback {
    case none
    case error
    case success
    case warning
    case light
    case medium
    case heavy
    @available(iOS 13.0, *)
    case soft
    @available(iOS 13.0, *)
    case rigid
    case selection
    case oldSchool
}

extension UIDevice {
    static func touchDownFeedBack(_ vibrationType : VibrationFeedback) {
        switch vibrationType {
        case .none:
            break
        case .error:
            UINotificationFeedbackGenerator().notificationOccurred(.error)
        case .success:
            UINotificationFeedbackGenerator().notificationOccurred(.success)
        case .warning:
            UINotificationFeedbackGenerator().notificationOccurred(.warning)
        case .light:
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
        case .medium:
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        case .heavy:
            UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
        case .soft:
            if #available(iOS 13.0, *) {
                UIImpactFeedbackGenerator(style: .soft).impactOccurred()
            }
        case .rigid:
            if #available(iOS 13.0, *) {
                UIImpactFeedbackGenerator(style: .rigid).impactOccurred()
            }
        case .selection:
            UISelectionFeedbackGenerator().selectionChanged()
        case .oldSchool:
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
        }
    }
}
