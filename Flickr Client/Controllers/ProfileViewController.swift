//
//  ProfileViewController.swift
//  Flickr Client
//
//  Created by Yassin Mziya on 1/12/19.
//  Copyright © 2019 Yassin Mziya. All rights reserved.
//

import UIKit
import SnapKit
import FlickrKit

class ProfileViewController: UIViewController {

    var logoutButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .flickrGray
        
        logoutButton = UIButton()
        logoutButton.setImage(UIImage(named: "logout"), for: .normal)
        logoutButton.addTarget(self, action: #selector(logoutButtonPressed), for: .touchUpInside)
        view.addSubview(logoutButton)
        
        setupConstraints()
    }
    
    func setupConstraints() {
        logoutButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.trailing.equalToSuperview().offset(-15)
        }
    }
    
    @objc func logoutButtonPressed() {
        FlickrKit.shared().logout()
        self.parent?.removeFromParent()
        UIApplication.shared.keyWindow?.rootViewController = LoginViewController()
    }
    
}
