//
//  EmptyStateCell.swift
//  Flickr Client
//
//  Created by Yassin Mziya on 1/18/19.
//  Copyright © 2019 Yassin Mziya. All rights reserved.
//

import UIKit
import SnapKit

class EmptyStateCell: UICollectionViewCell {
    
    var imageView: UIImageView!
    var messegeLabel: UILabel!
    var actionButton: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        imageView = UIImageView()
        // imageView.backgroundColor = .gray
        contentView.addSubview(imageView)
        
        messegeLabel = UILabel()
        messegeLabel.numberOfLines = 3
        messegeLabel.text = "Empty State. No results found."
        messegeLabel.textAlignment = .center
        messegeLabel.textColor = .gray
        contentView.addSubview(messegeLabel)
        
        actionButton = UIButton()
        actionButton.layer.borderColor = UIColor.gray.cgColor
        actionButton.setTitle("Try Again", for: .normal)
        actionButton.setTitleColor(.lightGray, for: .normal)
        actionButton.layer.borderWidth = 2
        actionButton.layer.cornerRadius = 8
        contentView.addSubview(actionButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        imageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-30)
            make.width.height.equalTo(100)
        }
        
        messegeLabel.snp.makeConstraints { make in
            make.centerX.equalTo(imageView)
            make.top.equalTo(imageView.snp.bottom).offset(4)
            make.width.equalTo(imageView).offset(60)
        }
        
        actionButton.snp.makeConstraints { make in
            make.top.equalTo(messegeLabel.snp.bottom).offset(24)
            make.width.equalTo(imageView).offset(-10)
            make.centerX.equalTo(messegeLabel)
            make.height.equalTo(30)
        }
    }
    
}
