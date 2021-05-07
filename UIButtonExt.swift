//
//  UIButtonExt.swift
//  Created by LYNX ART on 05/05/2021.
//

import UIKit

extension UIButton {
/**
     Use it to add functions as button actions and *optionally* to add button touch animation
          
     * USAGE:
      
          1. Connect a button as outlet
          2. In viewDidLoad add action to the button using this function
       
     * EXAMPLES:
       
         using a clouser:
         ````
         btn.setActionExt(action: { [self] in
          print("EXECUTE THE BUTTON ACTION")
         }, animations: [.fade])
         ````

         using a function:
         ````
         btn.setActionExt(action: sampleFunction, animations: [.scale])
         func sampleFunction() {
          print("EXECUTE THE BUTTON ACTION")
         }
         ````

         without animations:
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
             btn.setActionExt(action: sampleFunction, animations: [.fade, .scale])
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
      
     - Author:
         Omar Al Qasmi
     - Version:
         1.0
*/
    
    func setActionExt(action: @escaping () -> Void, animations: [ButtonAnimationType] = [.none])  {
        //Logging
        let logging: Bool = false
        
        //MARK: - ADD Touch events to the UIButton
        self.addAction(UIAction(handler: down), for: .touchDown)
        self.addAction(UIAction(handler: up), for: .touchUpInside)
        self.addAction(UIAction(handler: exit), for: .touchDragExit)
        self.addAction(UIAction(handler: upOutside), for: .touchUpOutside)
        self.addAction(UIAction(handler: cancel), for: .touchCancel)
        
        //MARK: - Nested functions to handle touch events
        //Handlers
        func down(_: UIAction) {
            if logging {print("button touch down")}
            downAnimation()
        }
        func up(_: UIAction) {
            if logging {print("button touch up")}
            upAnimation()
            //Execute Action
            if logging {print("button Execute Action")}
            action()
        }
        func exit(_: UIAction) {
            if logging {print("button touch exit")}
        }
        func upOutside(_: UIAction) {
            if logging {print("button touch up outside")}
            upAnimation()
        }
        func cancel(_: UIAction) {
            if logging {print("button touch cancel")}
            upAnimation()
        }
        //Start animating
        func downAnimation(){
            for anim in animations {
                switch anim {
                case .none:
                    if logging {print("button down animation => none")}
                case .fade:
                    if logging {print("button down animation => fade")}
                    self.touchDownAnimAlpha()
                case .scale:
                    if logging {print("button down animation => scale")}
                    self.touchDownAnimScale()
                }
            }
        }
        func upAnimation(){
            for anim in animations {
                switch anim {
                case .none:
                    if logging {print("button up animation => none")}
                case .fade:
                    if logging {print("button up animation => fade")}
                    self.touchUpAnimAlpha()
                case .scale:
                    if logging {print("button up animation => scale")}
                    self.touchUpAnimScale()
                }

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
        
        UIView.animate(withDuration: 0.2, delay: 0) {
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
