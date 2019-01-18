//
//  SearchResultCell.swift
//  Flickr Client
//
//  Created by Yassin Mziya on 1/16/19.
//  Copyright © 2019 Yassin Mziya. All rights reserved.
//

import UIKit

class SearchResultCell: UICollectionViewCell {
    
    static let identifier = "searchResultCell"
    var imageId: String!
    var imageView: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .darkGray
        imageView.clipsToBounds = true
        contentView.addSubview(imageView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
}
