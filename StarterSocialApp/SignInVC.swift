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
import SwiftKeychainWrapper

class SignInVC: UIViewController {
    
    @IBOutlet weak var emailField: FancyField!
    
    @IBOutlet weak var passwordField: FancyField!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if let _ = KeychainWrapper.standard.string(forKey: KEY_UID) {
            print("PETER-JON: ID found in keychain")
            performSegue(withIdentifier: "goToFeed", sender: nil)
        }
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
                if let user = user {
                    let userData = ["provider": credential.provider]
                    self.completeSignIn(id: user.uid, userData: userData)
                }
            }
    })

}
    
    @IBAction func signInTapped(_ sender: AnyObject) {
        if let email = emailField.text, let password = passwordField.text {
            FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
                if error == nil {
                    print("PETER-JON: Email user authenticated with Firebase")
                    if let user = user {
                        let userData = ["provider": user.providerID]
                       self.completeSignIn(id: user.uid, userData: userData)
                    }
                } else {
                    FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in
                        if error != nil {
                            print("PETER-JON: Unable to authenitcate with firebase ")
                        } else {
                            print("PETER-JON: Successfully email authenticated with Firebase")
                            if let user = user {
                                let userData = ["provider": user.providerID]
                                self.completeSignIn(id: user.uid, userData: userData)
                            }
                            
                        }
                    })
                }
            })
        }
        
    }
    
    func completeSignIn(id: String, userData: Dictionary<String, String>) {
        
        DataService.ds.createFirebaseDBUser(uid: id, userData: userData)
        let KeychainResult: Bool = KeychainWrapper.standard.set(id, forKey: KEY_UID)
        print("PETER-JON: Data saved to Keychain - \(KeychainResult)")
        performSegue(withIdentifier: "goToFeed", sender: nil)
        
    }

}
