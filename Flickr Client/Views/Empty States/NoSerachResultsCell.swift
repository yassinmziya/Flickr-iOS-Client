//
//  NoSerachResultsCell.swift
//  Flickr Client
//
//  Created by Yassin Mziya on 1/18/19.
//  Copyright © 2019 Yassin Mziya. All rights reserved.
//

import UIKit

class NoSerachResultsCell: EmptyStateCell {
    
    static let identifier = "searchEmptyStateCell"
    var query: String? = nil {
        didSet {
            self.messegeLabel.text = "No results found for search term \"\(query ?? nil)\""
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.imageView.image = UIImage(named: "magnifying-glass-gray")
        print(query)
        self.messegeLabel.text = "No results found for search term \"\(query)\""
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
