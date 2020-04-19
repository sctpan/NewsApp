//
//  HeadlineViewController.swift
//  NewsApp
//
//  Created by 潘一帆 on 2020/4/18.
//  Copyright © 2020 Yifan. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class HeadlineViewController: ButtonBarPagerTabStripViewController {
    let searchController = UISearchController()
    let containerScrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let topBarView: ButtonBarView = {
        let view = ButtonBarView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override func viewDidLoad() {
        addSearchBar()
        setupSlidingTab()
        super.viewDidLoad()
    }
    
    func addSearchBar() {
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = true
    }

    private func setupSlidingTab(){
        self.containerView = self.containerScrollView
        self.buttonBarView = self.topBarView
        
        self.view.addSubview(self.topBarView)
        self.view.addSubview(self.containerScrollView)
        NSLayoutConstraint.activate([
            self.topBarView.heightAnchor.constraint(equalToConstant: 50),
            self.topBarView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0),
            self.topBarView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0),
            self.containerScrollView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 0),
            self.containerScrollView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: 0),
            self.topBarView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 0),
            self.containerScrollView.topAnchor.constraint(equalTo: self.topBarView.bottomAnchor, constant: 0),
            self.containerScrollView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: 0)
        ])
        
        settings.style.buttonBarBackgroundColor = .white
        settings.style.buttonBarItemBackgroundColor = .white
        changeCurrentIndexProgressive = { (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            guard changeCurrentIndex == true else { return }
            oldCell?.label.textColor = .lightGray
            newCell?.label.textColor = .systemBlue
           
        }
        settings.style.selectedBarHeight = 3.0
        settings.style.buttonBarItemFont = UIFont.boldSystemFont(ofSize: 15)
        settings.style.buttonBarHeight = 35
        settings.style.buttonBarMinimumLineSpacing = 0
        settings.style.buttonBarItemTitleColor = .lightGray
        settings.style.selectedBarBackgroundColor = .systemBlue
        settings.style.buttonBarItemsShouldFillAvailableWidth = true
        
    }

    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
            var controllers = [UIViewController]()
            controllers.append(NewsTableViewController(title: "WORLD"))
            controllers.append(NewsTableViewController(title: "BUSINESS"))
            controllers.append(NewsTableViewController(title: "POLITICS"))
            controllers.append(NewsTableViewController(title: "SPORTS"))
            controllers.append(NewsTableViewController(title: "TECHNOLOGY"))
            controllers.append(NewsTableViewController(title: "SCIENCE"))
            return controllers
        }
    
    
}
