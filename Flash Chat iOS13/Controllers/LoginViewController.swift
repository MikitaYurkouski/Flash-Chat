//
//  LoginViewController.swift
//  Flash Chat iOS13
//
//  Created by Никита Юрковский on 6.03.23.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    

    @IBAction func loginPressed(_ sender: UIButton) {
        
        // Код с файрбэса поменяли, т.к он устарел
        if let email = emailTextfield.text, let password = passwordTextfield.text {
            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                if let e = error {
                    print(e)
                } else {
                    // Navigate to the ChatViewController. Если ошибок нет, переходим на другую вью
                    self.performSegue(withIdentifier: K.loginSegue, sender: self)

                }
                
            }
        }
    }
    
}
