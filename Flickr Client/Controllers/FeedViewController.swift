//
//  FeedViewController.swift
//  Flickr Client
//
//  Created by Yassin Mziya on 1/12/19.
//  Copyright © 2019 Yassin Mziya. All rights reserved.
//

import UIKit
import SnapKit
import FlickrKit
import Kingfisher

class FeedViewController: UIViewController {
    
    var collectionView: UICollectionView!
    var photoData : [[String : Any]] = []
    var photos: [URL] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    // zoomed image logic
    var startingFrame: CGRect?
    var originalImageView: UIImageView?
    var overlayView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        let layout = UICollectionViewFlowLayout()
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .flickrGray
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(FeedViewCell.self, forCellWithReuseIdentifier: FeedViewCell.identifier)
        view.addSubview(collectionView)
        
        overlayView = UIView()
        overlayView.backgroundColor = .black
        overlayView.alpha = 0
        view.addSubview(overlayView)
        
        setupConstraints()
        getPhotos()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
    }
 
    func setupConstraints() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        overlayView.snp.makeConstraints { make in
            make.edges.equalTo(view.snp.edges)
        }
    }
    
    func getPhotos() {
        FlickrKit.shared().call(FKFlickrInterestingnessGetList()) { (response, error) in
            DispatchQueue.main.async {
                if let response = response, let photoArray = FlickrKit.shared().photoArray(fromResponse: response) {
                    for photoDict in photoArray {
                        // print(photoDict)
                        let photoUrl = FlickrKit.shared().photoURL(for: FKPhotoSize.large1024, fromPhotoDictionary: photoDict)
                        self.photos.append(photoUrl)
                        self.photoData.append(photoDict)
                    }
                } else if let error = error{
                    print(error)
                    return
                }
            }
        }
    }
    
}

// MARK:- UICollectionViewDataSource
extension FeedViewController: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let photoData = self.photoData[indexPath.row]
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeedViewCell.identifier, for: indexPath) as! FeedViewCell
        cell.imageView.kf.setImage(with: photos[indexPath.row])
        if let title = photoData["title"] as? String {
            cell.titleLabel.text = title
        }
        if let id = photoData["id"] as? String {
            cell.imageId = id
        }
        cell.delegate = self
        
        return cell
    }

}

// MARK:- UICollectionViewDelegateFlowLayout
extension FeedViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: (view.frame.height / 2))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(8)
    }
    
}

// MARK:- FeedViewCellDelegate
extension FeedViewController: FeedViewCellDelegate {
    
    func commentsButtonTapped(id: String) {
       //  print("func " + id)
        let commentsVC = CommentsViewController()
        commentsVC.imageId = id
        navigationController?.pushViewController(commentsVC, animated: true)
    }
    
    func animateImageZoom(imageView: UIImageView) {
        // to allow for cleanup
        startingFrame = view.convert(imageView.frame, from: imageView.superview)
        originalImageView = imageView
        
        let zoomedImageView = UIImageView(frame: startingFrame!)
        zoomedImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(zoomedImageTapped)))
        zoomedImageView.isUserInteractionEnabled = true
        zoomedImageView.contentMode = .scaleAspectFill
        zoomedImageView.clipsToBounds = true
        zoomedImageView.image = imageView.image
        zoomedImageView.backgroundColor = .red
        view.addSubview(zoomedImageView)
        imageView.alpha = 0
            
        UIView.animate(
            withDuration: 0.4,
            delay: 0,
            options: .curveEaseOut,
            animations: {
                let y = self.view.frame.height/2 - zoomedImageView.frame.height/2
                let height = (zoomedImageView.frame.height / zoomedImageView.frame.width) * self.view.frame.width
                self.overlayView.alpha = 1
                zoomedImageView.frame = CGRect(x: zoomedImageView.frame.origin.x - 4, y: y, width: self.view.frame.width, height: height)
        },
            completion: nil
        )
    }
    
    @objc private func zoomedImageTapped(_ recognizer: UITapGestureRecognizer) {
        let zoomedImageView = recognizer.view
        
        UIView.animate(
            withDuration: 0.4,
            delay: 0,
            options: .curveEaseOut,
            animations: {
                self.overlayView.alpha = 0
                zoomedImageView?.frame = self.startingFrame!
        }) { _ in
            self.originalImageView?.alpha = 1
            self.originalImageView = nil
            self.startingFrame = nil
            zoomedImageView?.removeFromSuperview()
        }
    }
    
}
