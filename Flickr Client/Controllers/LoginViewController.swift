//
//  LoginViewController.swift
//  Flickr Client
//
//  Created by Yassin Mziya on 1/11/19.
//  Copyright © 2019 Yassin Mziya. All rights reserved.
//

import UIKit
import FlickrKit
import SnapKit
import AuthenticationServices
import SafariServices

class LoginViewController: UIViewController {
    
    var authSession: ASWebAuthenticationSession!
    var bgImageView: UIImageView!
    var loginButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        bgImageView = UIImageView(image: UIImage(named: "login-background"))
        bgImageView.contentMode = .scaleAspectFill
        view.addSubview(bgImageView)
        
        loginButton = UIButton()
        loginButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        loginButton.layer.cornerRadius = 12
        loginButton.backgroundColor = .flickrBlue
        loginButton.setTitleColor(.white, for: .normal)
        loginButton.setTitle("Sign in with Flickr", for: .normal)
        loginButton.addTarget(self, action: #selector(loginButtonPressed), for: .touchUpInside)
        view.addSubview(loginButton)
        
        setupConstraints()
    }
    
    func setupConstraints() {
        bgImageView.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }
        
        loginButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview().multipliedBy(1.75)
            make.centerX.equalToSuperview()
            make.width.equalTo(view.frame.width * 0.8)
            make.height.equalTo(40)
        }
    }
    
    @objc func loginButtonPressed() {
        let callbackUrlString = "flickrclient://auth"
        let url =  URL(string: callbackUrlString)

        // 1. prepare flickrkit for auth
        FlickrKit.shared().beginAuth(withCallbackURL: url!, permission: FKPermission.write
        ) { (url, error) in
            if let error = error {
                self.showAlert(title: "Error", error: error)
            }
            
            // 2. use ASWebAuthSession to handle oauth flow. calls back to predefined url scheme.
            self.authSession = ASWebAuthenticationSession(url: url!, callbackURLScheme: callbackUrlString, completionHandler: { (url, error) in
                if let error = error {
                    self.showAlert(title: "Auth Error", error: error)
                }
                
                // 3. pass callback url to flickrkit to set token
                FlickrKit.shared().completeAuth(with: url!, completion: { (s1, s2, s3, error) in
                    if let error = error {
                        self.showAlert(title: "Auth Error", error: error)
                    }
                    
                    // 4. present home view on succ
                    DispatchQueue.main.async {
                        UIApplication.shared.keyWindow?.rootViewController = TabBarController()
                        self.removeFromParent()
                    }
                })
            })
            self.authSession.start()
        }
    }
    
    func showAlert(title: String, error: Error) {
        let alert = UIAlertController(title: title, message: error.localizedDescription, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }

}
