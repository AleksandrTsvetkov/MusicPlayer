//
//  MainTabBarController.swift
//  MusicPlayer
//
//  Created by Александр Цветков on 03.05.2020.
//  Copyright © 2020 Александр Цветков. All rights reserved.
//

import UIKit

protocol TrackDetailViewTransitionDelegate: class {
    func minimizeTrackDetailView()
    func maximizeTrackDetailView(viewModel: SearchViewModel.Cell?)
}

class MainTabBarController: UITabBarController {
    
    private var minTopAnchorConstraint: NSLayoutConstraint!
    private var maxTopAnchorConstraint: NSLayoutConstraint!
    private var bottomAnchorConstraint: NSLayoutConstraint!
    private let searchVC = SearchViewController(nibName: "SearchViewController", bundle: nil)
    private let trackDetailView: TrackDetailView = TrackDetailView.loadFromNib()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        tabBar.tintColor = #colorLiteral(red: 1, green: 0, blue: 0.3764705882, alpha: 1)
        
        setupTrackDetailView()
        searchVC.transitionDelegate = self
        let libraryVC = ViewController()
        let searchNC = generateViewController(rootViewController: searchVC, image: UIImage(named: "Search"), title: "Search")
        let libraryNC = generateViewController(rootViewController: libraryVC, image: UIImage(named: "Library"), title: "Library")
        viewControllers = [searchNC, libraryNC]
    }
    
    private func generateViewController(rootViewController: UIViewController, image: UIImage?, title : String) -> UIViewController {
        let navigationController = UINavigationController(rootViewController: rootViewController)
        navigationController.tabBarItem.image = image
        navigationController.tabBarItem.title = title
        rootViewController.navigationItem.title = title
        navigationController.navigationBar.prefersLargeTitles = true
        return navigationController
    }
    
    private func setupTrackDetailView() {
        trackDetailView.transitionDelegate = self
        trackDetailView.playlistDelegate = searchVC
        view.insertSubview(trackDetailView, belowSubview: tabBar)
        trackDetailView.translatesAutoresizingMaskIntoConstraints = false
        
        minTopAnchorConstraint = trackDetailView.topAnchor.constraint(equalTo: tabBar.topAnchor, constant: -64)
        maxTopAnchorConstraint = trackDetailView.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height)
        bottomAnchorConstraint = trackDetailView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: view.frame.height)
        bottomAnchorConstraint.isActive = true
        maxTopAnchorConstraint.isActive = true
        trackDetailView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        trackDetailView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
}

extension MainTabBarController: TrackDetailViewTransitionDelegate {
    
    func maximizeTrackDetailView(viewModel: SearchViewModel.Cell?) {
        maxTopAnchorConstraint.isActive = true
        minTopAnchorConstraint.isActive = false
        maxTopAnchorConstraint.constant = 0
        bottomAnchorConstraint.constant = 0
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7,
                       initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                        self.view.layoutIfNeeded()
                        self.tabBar.alpha = 0
                        self.trackDetailView.miniPlayerView.alpha = 0
                        _ = self.trackDetailView.fullScreenView.map { element in
                            element.alpha = 1
                        }
        })
        guard let cellViewModel = viewModel else { return }
        self.trackDetailView.set(viewModel: cellViewModel)
    }
    
    func minimizeTrackDetailView() {
        maxTopAnchorConstraint.isActive = false
        bottomAnchorConstraint.constant = view.frame.height
        minTopAnchorConstraint.isActive = true
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7,
                       initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                        self.view.layoutIfNeeded()
                        self.tabBar.alpha = 1
                        self.trackDetailView.miniPlayerView.alpha = 1
                        _ = self.trackDetailView.fullScreenView.map { element in
                            element.alpha = 0
                        }
        })
    }
}
