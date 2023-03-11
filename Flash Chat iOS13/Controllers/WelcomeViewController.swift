//
//  WelcomeViewController.swift
//  Flash Chat iOS13
//
//  Created by Никита Юрковский on 6.03.23.
//

import UIKit
import CLTypingLabel

class WelcomeViewController: UIViewController {

    
    //@IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var titleLabel: CLTypingLabel!
    
    
    // Прячем панель навигации на начальном экране
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    // Прячем панель навигации на начальном экране
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = "⚡️FlashChat"
        
        
        
        // Make a heading cycle
        titleLabel.text = ""
        var charIndex = 0.0
       let titleText = "⚡️FlashChat"
        for letter in titleText {
            print("-")
            print(0.1 * charIndex)
            print(letter)
            Timer.scheduledTimer(withTimeInterval: 0.1 * charIndex, repeats: false) { timer in
                self.titleLabel.text?.append(letter)
            }
            charIndex += 1

        }

       
    }
    

}
