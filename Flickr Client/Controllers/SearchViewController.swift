//
//  SearchViewController.swift
//  Flickr Client
//
//  Created by Yassin Mziya on 1/12/19.
//  Copyright © 2019 Yassin Mziya. All rights reserved.
//

import UIKit
import SnapKit
import FlickrKit
import Kingfisher

class SearchViewController: UIViewController {
    
    var searchFieldContainer: UIView!
    var searchField: UITextField!
    var collectionView: UICollectionView!
    
    var zoomedImageView: UIImageView!
    var zoomedImageOverlayView: ZoomedImageOverlayView!
    var zoomedCell: SearchResultCell? = nil
    var startingFrame: CGRect? = nil
    
    var page = 1
    var totalPages = 0
    var isRetrievingMore = false
    var query: String? = nil
    
    var photoUrls: [URL] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    var imageMeta: [[String: Any]] = []
    let padding: CGFloat = 2
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        view.backgroundColor = .flickrGray
        
        searchField = UITextField()
        searchField.placeholder = "Search..."
        searchField.backgroundColor = .flickrGray
        searchField.textColor = .lightGray
        searchField.font = UIFont.systemFont(ofSize: 25, weight: .bold)
        searchField.becomeFirstResponder()
        searchField.delegate = self
        
        searchFieldContainer = UIView()
        searchFieldContainer.addSubview(searchField)
        view.addSubview(searchFieldContainer)
        
        let layout = UICollectionViewFlowLayout()
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(SearchResultCell.self, forCellWithReuseIdentifier: SearchResultCell.identifier)
        collectionView.register(NoSerachResultsCell.self, forCellWithReuseIdentifier: NoSerachResultsCell.identifier)
        view.addSubview(collectionView)
        
        zoomedImageOverlayView = ZoomedImageOverlayView()
        zoomedImageOverlayView.delegate = self
        zoomedImageOverlayView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissZoomedImage)))
        zoomedImageOverlayView.alpha = 0
        view.addSubview(zoomedImageOverlayView)
        
        setupConstraints()
    }
    
    func setupConstraints() {
        searchFieldContainer.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(60)
        }
        
        searchField.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(40)
            make.centerY.equalToSuperview()
        }
        
        collectionView.snp.makeConstraints { make in
            make.leading.bottom.trailing.equalToSuperview()
            make.top.equalTo(searchFieldContainer.snp.bottom)
        }
        
        zoomedImageOverlayView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
    }
    
    func retrieveImages(query: String, retrieveMore: Bool) {
        let method = FKFlickrPhotosSearch()
        method.text = query
        if retrieveMore {
            if page > totalPages  { return }
            page  += 1
            method.page = String(page)
        }
        FlickrKit.shared().call(method) { (result, error) in
            DispatchQueue.main.async {
                if let error = error {
                    print(error.localizedDescription)
                } else if let result = result, let searchMetadata = result["photos"] {
                    self.isRetrievingMore = false
                    self.page = (searchMetadata as! [String: Any])["page"] as! Int
                    self.totalPages = (searchMetadata as! [String: Any])["pages"] as! Int
                    if let photosArray = FlickrKit.shared().photoArray(fromResponse: result) {
                        var accum: [URL]  = []
                        for photoDict in photosArray {
                            accum.append(FlickrKit.shared().photoURL(for: FKPhotoSize.large1024, fromPhotoDictionary: photoDict))
                        }
                        if retrieveMore {
                            self.photoUrls.append(contentsOf: accum)
                            self.imageMeta.append(contentsOf: photosArray)
                            print(self.page)
                        } else {
                            self.photoUrls = accum
                            self.imageMeta = photosArray
                        }
                    }
                }
            }
        }
    }
    
    func presentZoomedImage(cell: SearchResultCell) {
        startingFrame = view.convert(cell.imageView.frame, from: cell)
        zoomedCell = cell
        zoomedImageView = UIImageView(frame: startingFrame!)
        zoomedImageView.image = cell.imageView.image
        zoomedImageView.contentMode = .scaleAspectFit
        zoomedImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissZoomedImage)))
        zoomedImageView.isUserInteractionEnabled = true
        zoomedImageOverlayView.isUserInteractionEnabled = true
        view.addSubview(zoomedImageView)
        
        UIView.animate(
            withDuration: 0.4,
            delay: 0,
            options: .curveEaseOut,
            animations: {
                let width = self.view.frame.width
                let y = self.view.frame.height/2 - self.view.frame.width/2
                cell.alpha = 0
                self.zoomedImageView.frame = CGRect(x: 0, y: y, width: width, height: width)
                self.zoomedImageOverlayView.alpha = 1
        },
            completion: nil)
    }
    
    @objc func dismissZoomedImage(_ recognizer: UITapGestureRecognizer) {
        UIView.animate(
            withDuration: 0.4,
            delay: 0,
            options: .curveEaseOut,
            animations: {
                self.zoomedImageOverlayView.alpha = 0
                self.zoomedImageView.frame = self.startingFrame!
                self.zoomedCell?.alpha = 1
        }) { _ in
            self.zoomedImageView.removeFromSuperview()
            self.zoomedImageOverlayView.isUserInteractionEnabled = false
            self.zoomedCell = nil
            self.startingFrame = nil
        }
    }
    
}

// MARK:- UICollectionViewDataSource and UICollectionViewDelegate
extension SearchViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard !photoUrls.isEmpty else { return }
        
        let cell = collectionView.cellForItem(at: indexPath) as! SearchResultCell
        presentZoomedImage(cell: cell)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return max(photoUrls.count, 1)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if photoUrls.isEmpty {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NoSerachResultsCell.identifier, for: indexPath) as! NoSerachResultsCell
            cell.query = self.query
            return cell
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchResultCell.identifier, for: indexPath) as! SearchResultCell
        cell.imageId = imageMeta[indexPath.row]["id"] as! String
        cell.imageView.kf.setImage(with: photoUrls[indexPath.row])
        return cell
    }
    
}

// MARK:- UICollectionViewDelegateFlowLayout
extension SearchViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if photoUrls.isEmpty {
            return CGSize(width: view.frame.width, height: collectionView.frame.height)
        }
        return CGSize(width: (view.frame.width/3.0) - padding, height: (view.frame.width/3.0) - padding)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return padding
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return padding
    }
    
}

// MARK:- UITextFieldDelegate
extension SearchViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let text = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines), text != "" else { return false }

        retrieveImages(query: text, retrieveMore: false)
        self.query = text
        textField.resignFirstResponder()
        return true
    }
    
}

// MARK:- UIScrollViewDelegate
extension SearchViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let y = scrollView.bounds.origin.y + scrollView.bounds.height
        let threshold = view.frame.width
        // print(scrollView.contentSize.height)
        
        if y > scrollView.contentSize.height - threshold && !isRetrievingMore {
            if let query = query {
                isRetrievingMore = true
                retrieveImages(query: query, retrieveMore: true)
            }
        }
    }
    
}


// MARK:- ZoomedImageOverlayViewDelegate
extension SearchViewController: ZoomedImageOverlayViewDelegate {
    
    func commentButtonPressed() {
        let commentsVC = CommentsViewController()
        commentsVC.imageId = zoomedCell?.imageId
        navigationController?.pushViewController(commentsVC, animated: true)
    }
    
    func favoriteButtonPressed() {
        return
    }
    
}
