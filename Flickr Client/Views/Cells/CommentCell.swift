//
//  CommentCell.swift
//  Flickr Client
//
//  Created by Yassin Mziya on 1/13/19.
//  Copyright © 2019 Yassin Mziya. All rights reserved.
//

import UIKit
import SnapKit

class CommentCell: UITableViewCell {
    
    static let identifier = "commentCell"
    
    var profileImageView: UIImageView!
    var usernameLabel: UILabel!
    var commentTextField: UITextView!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        profileImageView = UIImageView()
        profileImageView.contentMode = .scaleAspectFit
        profileImageView.clipsToBounds = true
        profileImageView.layer.cornerRadius = 20
        profileImageView.backgroundColor = .cyan
        // contentView.addSubview(profileImageView)
        
        usernameLabel = UILabel()
        usernameLabel.text = "John Doe"
        usernameLabel.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        contentView.addSubview(usernameLabel)
        
        commentTextField = UITextView()
        commentTextField.isEditable = false
        commentTextField.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce a lorem eget magna ultricies ultricies ut eu mi."
        commentTextField.textContainerInset = UIEdgeInsets.zero
        commentTextField.textContainer.lineFragmentPadding = 0
        commentTextField.font = UIFont.systemFont(ofSize: 14)
        commentTextField.isScrollEnabled = false
        contentView.addSubview(commentTextField)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
//        profileImageView?.snp.makeConstraints({ make in
//            make.height.width.equalTo(40)
//            make.leading.top.equalToSuperview().offset(12)
//        })
        
        usernameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.leading.equalToSuperview().offset(12)
            make.trailing.equalToSuperview().offset(-12)
            make.height.equalTo(usernameLabel.intrinsicContentSize.height)
        }
        
        commentTextField.snp.makeConstraints { make in
            make.top.equalTo(usernameLabel.snp.bottom)
            make.leading.trailing.equalTo(usernameLabel)
            make.bottom.equalToSuperview().offset(-8)
        }
    }
    
}
