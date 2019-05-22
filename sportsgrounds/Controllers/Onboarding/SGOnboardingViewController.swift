//
//  SGOnboardingViewController.swift
//  courses-aggregator
//
//  Created by Alexander Ponomarev on 09/02/2019.
//  Copyright © 2019 Alexander Ponomarev. All rights reserved.
//

import UIKit

class SGOnboardingViewController: SGFlowViewController {
    
    var onContinue: (() -> Void)?
    
    // MARK: - Private Properties
    
    private lazy var pages: [UIViewController] = {
        return [
            self.getPageViewController(withImage: #imageLiteral(resourceName: "onboarding.image.placeholder"), title: "Sportgrounds", subtitle: "Сервис для занятий спортом в компании в городе"),
            self.getPageViewController(withImage: #imageLiteral(resourceName: "onboarding.image.placeholder"), title: "Sportgrounds", subtitle: "Сервис для занятий спортом в компании в городе"),
            self.getPageViewController(withImage: #imageLiteral(resourceName: "onboarding.image.placeholder"), title: "Sportgrounds", subtitle: "Сервис для занятий спортом в компании в городе")
        ]
    }()
    
    private lazy var pageViewController: UIPageViewController = {
        let pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        pageViewController.view.backgroundColor = .clear
        pageViewController.delegate = self
        pageViewController.dataSource = self
        
        // Set page indicator style
        UIPageControl.appearance().currentPageIndicatorTintColor = UIColor.appBlack
        UIPageControl.appearance().pageIndicatorTintColor = UIColor.appBlack.withAlphaComponent(0.2)
        
        addChild(pageViewController)
        view.addSubview(pageViewController.view)
        pageViewController.didMove(toParent: self)
        
        return pageViewController
    }()
    
    private lazy var button: UIButton = {
        let button = SGButton.button
        button.setTitle("Войти", for: .normal)
        button.addTarget(self, action: #selector(buttonTouchUpInside(_:)), for: .touchUpInside)
        
        view.addSubview(button)
        return button
    }()
    
    // MARK: - UIViewController Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addConstraintsToSubviews()
        
        self.view.backgroundColor = UIColor.appWhite
        self.pageViewController.setViewControllers([pages[0]], direction: .forward, animated: true, completion: nil)
    }
    
    // MARK: - Private Functions
    
    private func addConstraintsToSubviews() {
        pageViewController.view.translatesAutoresizingMaskIntoConstraints = false
        button.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            pageViewController.view.leftAnchor.constraint(equalTo: view.leftAnchor),
            pageViewController.view.rightAnchor.constraint(equalTo: view.rightAnchor),
            pageViewController.view.topAnchor.constraint(equalTo: view.topAnchor),
            button.topAnchor.constraint(equalTo: pageViewController.view.bottomAnchor, constant: 34.0),
            button.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 15.0),
            button.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -15.0),
            button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16.0),
            button.heightAnchor.constraint(equalToConstant: 50.0)
            ])
    }
    
    private func getPageViewController(withImage image: UIImage, title: String, subtitle: String) -> SGOnboardingPageViewController {
        let viewController = SGOnboardingPageViewController()
        viewController.image = image
        viewController.title = title
        viewController.subtitle = subtitle
        
        return viewController
    }
    
    @objc private func buttonTouchUpInside(_ sender: UIButton) {
        self.onContinue?()
    }
}

extension SGOnboardingViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let viewControllerIndex = pages.index(of: viewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else {
            return pages.last
        }
        
        guard pages.count > previousIndex else {
            return nil
        }
        
        return pages[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pages.index(of: viewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        
        guard nextIndex < pages.count else {
            return pages.first
        }
        
        guard pages.count > nextIndex else {
            return nil
        }
        
        return pages[nextIndex]
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return pages.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return 0
    }
}

extension SGOnboardingViewController: UIPageViewControllerDelegate {
    
}
