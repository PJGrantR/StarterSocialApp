//
//  ViewController.swift
//  StarterSocialApp
//
//  Created by Peter-Jon Grant on 2016-10-26.
//  Copyright © 2016 Peter-Jon Grant. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Firebase

class SignInVC: UIViewController {
    
    @IBOutlet weak var emailField: FancyField!
    
    @IBOutlet weak var passwordField: FancyField!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func facebookButtonTapped(_ sender: AnyObject) {
        
        let facebookLogin = FBSDKLoginManager()
        
        facebookLogin.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            if error != nil {
                print("PETER-JON: Unable to Authenticate with facebook - \(error)")
            } else if result?.isCancelled == true {
                print("PETER-JON: User cancelled FB Authentication")
            } else {
                print("PETER-JON: Successfully authenticated with FB")
                let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                self.firebaseAuth(credential)
            }
        }
        
    }
    
    func firebaseAuth(_ credential: FIRAuthCredential) {
        FIRAuth.auth()?.signIn(with: credential, completion: { (user, error) in
            if error != nil {
                print("PETER-JON: unable to authenticate with FireBase -\(error)")
            } else {
                print("PETER-JON: Sucessfully authenticated with FireBase")
            }
    })

}
    
    @IBAction func signInTapped(_ sender: AnyObject) {
        if let email = emailField.text, let password = passwordField.text {
            FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
                if error == nil {
                    print("PETER-JON: Email user authenticated with Firebase")
                } else {
                    FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in
                        if error != nil {
                            print("PETER-JON: Unable to authenitcate with firebase ")
                        } else {
                            print("PETER-JON: Successfully email authenticated with Firebase")
                        }
                    })
                }
            })
        }
        
    }

}
