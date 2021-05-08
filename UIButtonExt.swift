//
//  UIButtonExt.swift
//  Created by LYNX ART on 05/05/2021.
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
          - you can add more than one action to the button simply by calling *setActionExt* mutiple times
              - btn.setActionExt(action: sampleFunction1)
              btn.setActionExt(action: sampleFunction2)
              btn.setActionExt(action: sampleFunction3)
     - Important:
          - Avoid calling this function in viewDidAppear if not intended, because it will add the same action multiple times. *everytime the screen appears*

     - Parameters:
         - action: select a local function to be excecuted when button clicked
         - animations: add an array of button animations ex. [.fade, .scale], Default animation types none = no animation,  scale = shrink the button on touchDown, fade = reduce the button opacity on touchDown
         - feedback: add a haptic feedback to touchDown

     - Author:
         Omar Al Qasmi
     - Version:
         1.0
*/
    
    func setActionExt(action: @escaping () -> Void, animations: [ButtonAnimationType] = [.none], feedback: VibrationFeedback = .none)  {
        //Logging
        let logging: Bool = false
        
        //MARK: - ADD Touch events to the UIButton
        self.addAction(UIAction(handler: touchDown), for: .touchDown)
        self.addAction(UIAction(handler: touchUpInside), for: .touchUpInside)
        self.addAction(UIAction(handler: touchDragExit), for: .touchDragExit)
        self.addAction(UIAction(handler: touchDragEnter), for: .touchDragEnter)
        self.addAction(UIAction(handler: touchUpOutside), for: .touchUpOutside)
        self.addAction(UIAction(handler: touchCancel), for: .touchCancel)
        
        //MARK: - Nested functions to handle touch events
        //Handlers
        func touchDown(_: UIAction) {
            printLogs("button touchDown")
            UIDevice.touchDownFeedBack(feedback)
            downAnimation()
        }
        func touchUpInside(_: UIAction) {
            printLogs("button touchUpInside")
            upAnimation()
            //Execute Action
            printLogs("button Execute Action")
            action()
        }
        func touchDragExit(_: UIAction) {
            printLogs("button touchDragExit")
            upAnimation()
        }
        func touchDragEnter(_: UIAction) {
            printLogs("button touchDragEnter")
            downAnimation()
        }
        func touchUpOutside(_: UIAction) {
            printLogs("button touch touchUpOutside")
        }
        func touchCancel(_: UIAction) {
            printLogs("button touchCancel")
            upAnimation()
        }
        //Start animating
        func downAnimation(){
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
        func upAnimation(){
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
        //Debug logging
        func printLogs(_ msg: String){
            if logging {
                print(msg)
            }
        }
    }
    
    //MARK: - UIButton touch animations
    func touchDownAnimScale() {
        UIView.animate(withDuration: 0.05, delay: 0) {
            self.transform = .init(scaleX: 0.95, y: 0.95)
        }
    }
    
    func touchUpAnimScale() {
        UIView.animate(withDuration: 0.2, delay: 0.05) {
            self.transform = .init(scaleX: 1, y: 1)
        }
    }
    
    func touchDownAnimAlpha() {
        UIView.animate(withDuration: 0.05, delay: 0) {
            self.alpha = 0.5
        }
    }
    
    func touchUpAnimAlpha() {
        UIView.animate(withDuration: 0.2, delay: 0) {
            self.alpha = 1
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
