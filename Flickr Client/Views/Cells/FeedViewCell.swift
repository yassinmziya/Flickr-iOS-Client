//
//  FeedViewCell.swift
//  Flickr Client
//
//  Created by Yassin Mziya on 1/13/19.
//  Copyright © 2019 Yassin Mziya. All rights reserved.
//

import UIKit
import SnapKit

protocol FeedViewCellDelegate {
    func commentsButtonTapped(id: String)
    func animateImageZoom(imageView: UIImageView)
}

class FeedViewCell: UICollectionViewCell {
    
    static let identifier = "feedViewCell"
    var delegate: FeedViewCellDelegate?
    var imageId: String!
    var startingImageFrame: CGRect!
    
    var imageView: UIImageView!
    var interactionsStackView: UIStackView!
    var interactionButtons: [UIButton] = ["star", "speech-bubble"].map { (iconName) -> UIButton in
        var button = UIButton()
        button.setImage(UIImage(named: iconName), for: .normal)
        return button
    }
    var titleLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = .white
        
        imageView = UIImageView()
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onImageTap)))
        imageView.isUserInteractionEnabled = true
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .lightGray
        contentView.addSubview(imageView)
        
        interactionsStackView = UIStackView(arrangedSubviews: interactionButtons)
        interactionsStackView.axis = .horizontal
        interactionsStackView.distribution = .fillEqually
        contentView.addSubview(interactionsStackView)
        
        titleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 14)
        contentView.addSubview(titleLabel)
        
        interactionButtons[1].addTarget(self, action: #selector(viewComments), for: .touchUpInside)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        imageView.snp.makeConstraints { make in
            make.leading.top.equalToSuperview().offset(4)
            make.trailing.equalToSuperview().offset(-4)
            make.bottom.equalToSuperview().multipliedBy(0.75)
        }
        startingImageFrame = imageView.frame
        
        interactionsStackView.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(8)
            make.leading.equalTo(imageView)
            make.height.equalTo(50)
            make.width.equalTo(interactionButtons.count * 50)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.trailing.equalTo(imageView)
            make.top.equalTo(interactionsStackView.snp.bottom)
        }
    }
    
    @objc func viewComments() {
        delegate?.commentsButtonTapped(id: imageId)
    }
    
    @objc func onImageTap(_ recognizer: UITapGestureRecognizer) {
        delegate?.animateImageZoom(imageView: imageView)
    }
    
}
