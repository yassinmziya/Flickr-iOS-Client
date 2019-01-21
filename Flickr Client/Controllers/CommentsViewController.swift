//
//  CommentsViewController.swift
//  Flickr Client
//
//  Created by Yassin Mziya on 1/13/19.
//  Copyright © 2019 Yassin Mziya. All rights reserved.
//

import UIKit
import SnapKit
import FlickrKit

class CommentsViewController: UIViewController {

    var imageId: String!
    var tableView = UITableView()
    var comments: [FKComment] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    var divider: UIView!
    var commentTextView: UITextView!
    var postButton: UIButton!
    var commentAreaContainer: UIView!
    
    var activityIndicator: UIActivityIndicatorView!
    var loadingView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(CommentCell.self, forCellReuseIdentifier: CommentCell.identifier)
        tableView.tableFooterView = UIView()
        view.addSubview(tableView)
        
        divider = UIView()
        divider.backgroundColor = .lightGray
        view.addSubview(divider)
        
        commentTextView = UITextView()
        commentTextView.delegate = self
        commentTextView.text = "Add a comment..."
        commentTextView.textColor = UIColor.lightGray
        commentTextView.font = UIFont.systemFont(ofSize: 14)
        
//        postButton = UIButton()
//        postButton.addTarget(self, action: #selector(postComment), for: .touchUpInside)
//        postButton.setTitle("Post", for: .normal)
//        postButton.setTitleColor(.flickrGray, for: .normal)
//        postButton.setTitleColor(.lightGray, for: .disabled)
//        postButton.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .bold)
//        postButton.isEnabled = false
        
        commentAreaContainer = UIView()
        commentAreaContainer.backgroundColor  = .white
        commentAreaContainer.addSubview(commentTextView)
        // commentAreaContainer.addSubview(postButton)
        view.addSubview(commentAreaContainer)
        
        activityIndicator = UIActivityIndicatorView()
        loadingView = UIView()
        loadingView.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        activityIndicator.style = .gray
        loadingView.backgroundColor = .white
        view.addSubview(loadingView)
        
        setupConstraints()
        getComments()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationItem.title = "Comments (\(comments.count))"
    }
    
    func setupConstraints() {
        commentAreaContainer.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.height.equalTo(60)
        }
        
        commentTextView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.equalTo(40)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
        
        divider.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(commentAreaContainer.snp.top)
            make.height.equalTo(0.5)
        }
        
        
        tableView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.bottom.equalTo(divider.snp.top)
        }
        
        loadingView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        activityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    func getComments() {
        let method = FKFlickrPhotosCommentsGetList()
        method.photo_id = imageId
        FlickrKit.shared().call(method) { (response, error) in
            if let error = error {
                print(error.localizedDescription)
            } else if let response = response {
                DispatchQueue.main.async {
                    print(response)
                    if let commentsData = response["comments"] as! [String: Any]?, let comments = commentsData["comment"] as! [[String: Any]]? {
                        var accum: [FKComment] = []
                        for comment in comments {
                            if let decodedComment = self.decodeComment(comment: comment) { accum.append(decodedComment) }
                        }
                        self.comments = accum
                    }
                    
                    self.loadingView.removeFromSuperview()
                }
            }
        }
    }
    
    func decodeComment(comment: [String: Any]) -> FKComment? {
        if let id = comment["id"], let authorId = comment["author"], let content = comment["_content"], let timestamp = comment["datecreate"], let author = comment["authorname"] {
            
            let fkComment = FKComment(id: id as! String, content: content as! String, authorId: authorId as! String, author: author as! String, timestamp: timestamp as! String)
            return fkComment
        }
        return nil
    }
    
    @objc func postComment() {
        guard commentTextView.text?.trimmingCharacters(in: .whitespacesAndNewlines).count != 0 else { return }
        let method = FKFlickrPhotosCommentsAddComment()
        method.photo_id = imageId
        method.comment_text = commentTextView.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        FlickrKit.shared().call(method) { (result, error) in
            if let error = error {
                print(error.localizedDescription)
            } else if let result = result {
                print(result)
            }
        }
    }

}

// MARK:- UITableViewDataSource & UITableViewDelegate
extension CommentsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CommentCell.identifier) as! CommentCell
        let comment = comments[indexPath.row]
        cell.usernameLabel.text = comment.author
        cell.commentTextField.text = comment.content
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        let cell = tableView.cellForRow(at: indexPath) as! CommentCell
//        cell.commentTextField.intrinsicContentSize.height
        return view.frame.width/5
    }
    
}


// MARK:- UITextViewDelegate
extension CommentsViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Add a comment..." {
            textView.text = ""
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let size = CGSize(width: view.frame.width, height: .infinity)
        let estimatedSize = textView.sizeThatFits(size)
        textView.snp.updateConstraints { make in
            make.height.equalTo(estimatedSize.height)
        }
        commentAreaContainer.snp.updateConstraints { make in
            make.height.equalTo(estimatedSize.height + 20)
        }
    }
    
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n") {
            postComment()
            textView.resignFirstResponder()
            textView.text = "Add a comment..."
            textView.textColor = UIColor.lightGray
        }
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            textView.text = "Add a comment..."
            textView.textColor = UIColor.lightGray
        }
    }
    
}
