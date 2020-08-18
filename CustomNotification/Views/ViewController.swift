//
//  ViewController.swift
//  CustomNotification
//
//  Created by Jacob Ahlberg on 2020-08-18.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func sendNotificationPressed(_ sender: Any?) {
        NotificationManager.current.sendNotification { (result) in
            guard case .failure(let error) = result else {
                return
            }

            // Handle error
            
        }
    }


}

