//
//  FeedVC.swift
//  StarterSocialApp
//
//  Created by Peter-Jon Grant on 2016-10-29.
//  Copyright © 2016 Peter-Jon Grant. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper

class FeedVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tableview: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

     tableview.delegate = self
     tableview.dataSource = self
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       return tableview.dequeueReusableCell(withIdentifier: "PostCell")!
    }

    
    
    @IBAction func signOutTapped(_ sender: AnyObject) {
        
        let keychainResult = KeychainWrapper.standard.removeObject(forKey: KEY_UID)
        print("PETER-JON: ID Removed from keychain \(keychainResult)")
        try! FIRAuth.auth()?.signOut()
        performSegue(withIdentifier: "goToSignIn", sender: nil)
    }
    

}
