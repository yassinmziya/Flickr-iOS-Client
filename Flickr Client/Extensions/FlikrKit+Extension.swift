//
//  FlikrKit+Extension.swift
//  Flickr Client
//
//  Created by Yassin Mziya on 2/12/19.
//  Copyright © 2019 Yassin Mziya. All rights reserved.
//

import Foundation
import FlickrKit

extension FlickrKit {
    
    func getFavourites(completion: @escaping (Set<String>) -> Void){
        let method  = FKFlickrFavoritesGetList()
        method.per_page = "500"
        
        FlickrKit.shared().call(method) { (response, error) in
            if let error = error {
                print(error.localizedDescription)
            } else if let response = response, let photoArray = FlickrKit.shared().photoArray(fromResponse: response) {
                print(photoArray)
                var ids: Set<String> = []
                photoArray.forEach { photo in
                    ids.insert(photo["id"] as! String)
                }
                completion(ids)
            }
        }
    }
    
}
