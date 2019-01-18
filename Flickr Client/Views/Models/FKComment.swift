//
//  FKComment.swift
//  Flickr Client
//
//  Created by Yassin Mziya on 1/14/19.
//  Copyright © 2019 Yassin Mziya. All rights reserved.
//

import Foundation

struct FKComment {
    var id: String
    var content: String
    var authorId: String
    var author: String
    var timestamp: String
    
    init(id: String, content: String, authorId: String, author: String, timestamp: String) {
        self.id = id
        self.content = content
        self.authorId = authorId
        self.author = author
        self.timestamp = timestamp
    }
}
