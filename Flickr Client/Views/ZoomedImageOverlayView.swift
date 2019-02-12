//
//  ZoomedImageOverlayView.swift
//  Flickr Client
//
//  Created by Yassin Mziya on 1/17/19.
//  Copyright © 2019 Yassin Mziya. All rights reserved.
//

import UIKit
import SnapKit

protocol ZoomedImageOverlayViewDelegate {
    func commentButtonPressed()
    func favoriteButtonPressed(id: String)
}

class ZoomedImageOverlayView: UIView {
    var delegate: ZoomedImageOverlayViewDelegate?
    
    var imageId: String!
    var isFavorite = false {
        didSet {
            let imageName = isFavorite ? "gold-star" : "star"
            photoInteractions[0].setImage(UIImage(named: imageName), for: .normal)
        }
    }
    var stackView: UIStackView!
    var photoInteractions = [(image: UIImage(named: "star"), function: #selector(favoriteButtonPressed)),
                             (image: UIImage(named: "speech-bubble"), function: #selector(commentButtonPressed))
        ].map { interaction -> UIButton in
        let button = UIButton()
        button.addTarget(self, action: interaction.function, for: .touchUpInside)
        button.setImage(interaction.image, for: .normal)
        return button
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .black
        
        stackView = UIStackView(arrangedSubviews: photoInteractions)
        addSubview(stackView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func commentButtonPressed() {
        delegate?.commentButtonPressed()
    }
    
    @objc func favoriteButtonPressed() {
        delegate?.favoriteButtonPressed(id: imageId)
        isFavorite = !isFavorite
    }
    
    override func layoutSubviews() {
        stackView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().offset(-20)
            make.height.equalTo(40)
            make.width.equalTo(40 * photoInteractions.count)
        }
    }
    
}
