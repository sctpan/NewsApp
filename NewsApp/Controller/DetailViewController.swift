//
//  DetailViewController.swift
//  NewsApp
//
//  Created by 潘一帆 on 2020/4/13.
//  Copyright © 2020 Yifan. All rights reserved.
//

import UIKit
import SwiftSpinner
import Toast_Swift

class DetailViewController: UIViewController {
    var news: News!
    var detailNews: News!
    var twitterBtn: UIBarButtonItem!
    var bookmarkBtn: UIBarButtonItem!
    var newsService = NewsService()
    let scrollView = UIScrollView()
    var imgView: UIImageView!
    var titleLabel = UILabel()
    var sectionLabel = UILabel()
    var dateLabel = UILabel()
    var bodyLabel = UILabel()
    var viewDetailBtn = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        ToastManager.shared.isQueueEnabled = true
        SwiftSpinner.show(Constants.loadingDetailMessage)
        newsService.getDetailPageNewsHelper(id: news.id)
        setNavigationBar()
        
        createObservers()
    }
    
    func setNavigationBar() {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.title = news.title
        twitterBtn = UIBarButtonItem(image: UIImage(named: "twitter"), style: .plain, target:self, action: #selector(self.shareBtnClicked))
        bookmarkBtn = UIBarButtonItem(image: UIImage(systemName: "bookmark"), style: .plain, target:self, action: #selector(self.bookmarkBtnClicked))
        if StoreService.get(key: self.news.id) != nil {
            bookmarkBtn.image = UIImage(systemName: "bookmark.fill")
        }
        navigationItem.setRightBarButtonItems([twitterBtn, bookmarkBtn], animated: true)
    }
    
    func addScrollView() {
     //   scrollView.contentSize = CGSize(width: view.frame.width, height: 3000)
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
//        scrollView.widthAnchor.constraint(equalToConstant: scrollView.contentSize.width).isActive = true
    }
    
    
    func createObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(DetailViewController.renderPage(notification:)), name: Constants.detailNewsReady, object: nil)
    }
    
    @objc func renderPage(notification: NSNotification) {
        detailNews = newsService.getDetailPageNews()
        addScrollView()
        addImageView()
        addTitleLabel()
        addSectionDateLabel()
        addNewsBody()
        addViewDetailBtn()
        SwiftSpinner.hide()
    }
    
    func addNewsBody() {
        bodyLabel.numberOfLines = 30
        bodyLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        bodyLabel.attributedText = detailNews.description.htmlToAttributedString
        bodyLabel.font = UIFont.systemFont(ofSize: 18)
        scrollView.addSubview(bodyLabel)
        bodyLabel.translatesAutoresizingMaskIntoConstraints = false
        bodyLabel.topAnchor.constraint(equalTo: sectionLabel.bottomAnchor, constant: 35).isActive = true
        bodyLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15).isActive = true
        bodyLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15).isActive = true
//        bodyLabel.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 0).isActive = true
    }
    
    func addSectionDateLabel() {
        sectionLabel.text = detailNews.section
        sectionLabel.font = UIFont.systemFont(ofSize: 18)
        sectionLabel.textColor = .lightGray
        scrollView.addSubview(sectionLabel)
        sectionLabel.translatesAutoresizingMaskIntoConstraints = false
        sectionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 35).isActive = true
        sectionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40).isActive = true
        
        dateLabel.text = detailNews.date
        dateLabel.font = UIFont.systemFont(ofSize: 18)
        dateLabel.textColor = .lightGray
        scrollView.addSubview(dateLabel)
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 35).isActive = true
        dateLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50).isActive = true
    }
    
    func addTitleLabel() {
        titleLabel.text = detailNews.title
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        titleLabel.numberOfLines = 0
        titleLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        titleLabel.textAlignment = .center
        titleLabel.sizeToFit()
        scrollView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.topAnchor.constraint(equalTo: imgView.bottomAnchor, constant: 30).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 60).isActive = true
    }
    
    func addImageView() {
        imgView = UIImageView(frame: CGRect(x:0, y:20, width: self.view.frame.width, height: 260))
        imgView.contentMode = .scaleAspectFill
        imgView.clipsToBounds = true
        if self.detailNews.image == "unavailable" {
            imgView.image = #imageLiteral(resourceName: "default-guardian")
        } else {
            let url = URL(string: self.detailNews.image)
            let data = try? Data(contentsOf: url!)
            imgView.image = UIImage(data: data!)
        }
        self.scrollView.addSubview(imgView)
    }
    
    func addViewDetailBtn() {
        viewDetailBtn.setTitle("View Full Article", for: .normal)
        viewDetailBtn.setTitleColor(.systemBlue, for: .normal)
        viewDetailBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 22)
        viewDetailBtn.addTarget(self, action: #selector(goToLink), for: .touchUpInside)
        scrollView.addSubview(viewDetailBtn)
        viewDetailBtn.translatesAutoresizingMaskIntoConstraints = false
        viewDetailBtn.topAnchor.constraint(equalTo: bodyLabel.bottomAnchor, constant: 20).isActive = true
        viewDetailBtn.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -20).isActive = true
        viewDetailBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
    }
    
    @objc func goToLink() {
        let url = URL(string: detailNews.shareUrl)!
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    
    @objc func shareBtnClicked() {
        ShareService.shareWithTwitter(url:self.detailNews.shareUrl)
    }
    
    @objc func bookmarkBtnClicked() {
        if StoreService.get(key: self.detailNews.id) != nil {
            StoreService.remove(key: self.detailNews.id)
            self.bookmarkBtn.image = UIImage(systemName: "bookmark")
            self.view.makeToast(Constants.bookmarkRemoveMessage)
        } else {
            StoreService.store(key: self.detailNews.id, news: self.detailNews)
            self.bookmarkBtn.image = UIImage(systemName: "bookmark.fill")
            self.view.makeToast(Constants.bookmarkSaveMessage)
        }
    }

}

extension String {
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return NSAttributedString() }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return NSAttributedString()
        }
    }
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
}


