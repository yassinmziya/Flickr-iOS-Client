//
//  UIView+Extension.swift
//  Flickr Client
//
//  Created by Yassin Mziya on 1/12/19.
//  Copyright © 2019 Yassin Mziya. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    func add(_ child: UIViewController, to view: UIView) {
        DispatchQueue.main.async {
            self.addChild(child)
            view.addSubview(child.view)
            child.view.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
            child.didMove(toParent: self)
        }
    }
    
    func remove() {
        guard parent != nil else {
            return
        }
        DispatchQueue.main.async {
            self.willMove(toParent: nil)
            self.removeFromParent()
            self.view.removeFromSuperview()
        }
    }
    
}
