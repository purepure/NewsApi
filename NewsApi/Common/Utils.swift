//
//  Utils.swift
//  NewsApi
//
//  Created by conga phucanh on 10/29/17.
//  Copyright © 2017 conga phucanh. All rights reserved.
//

import UIKit
import MBProgressHUD

class Utils: NSObject {
    static func showMessage(_ controller: UIViewController, _ title:String, _ message: String) -> UIAlertController{
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        controller.present(alert, animated: true, completion: nil)

        return alert
    }

    static func window()->UIWindow{
        let app = UIApplication.shared.delegate as! AppDelegate
        return app.window!
    }

    static func showLoader(){
        MBProgressHUD.showAdded(to: Utils.window(), animated: true)
    }

    static func hideLoader(){
        MBProgressHUD.hide(for: Utils.window(), animated: true)
    }
}
