//
//  ImageCaroselPageViewController.swift
//  Resque
//
//  Created by Roback, Jerry on 12/18/17.
//  Copyright © 2017 Roback, Jerry. All rights reserved.
//

import UIKit
import SDWebImage

protocol ImageCaroselControllerDelegate : class {
    func setUpPageController(numberOfPages: Int)
    func turnPageController(to index: Int)
}

class ImageCaroselPageViewController: UIPageViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {

    var puppy : Puppy!
    
    weak var pageViewControllerDelegate: ImageCaroselControllerDelegate?
    
    lazy var caroselViews : [UIViewController] = {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        var caroselViews = [UIViewController]()
        let headerImageURLs = self.puppy.puppyAdditionalImages
        
        for image in headerImageURLs {
            let puppyImageVC = storyboard.instantiateViewController(withIdentifier: "ImageViewController")
            caroselViews.append(puppyImageVC)
        }
        self.pageViewControllerDelegate?.setUpPageController(numberOfPages: caroselViews.count)
        
        return caroselViews
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        self.turnToPage(index: 0)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        automaticallyAdjustsScrollViewInsets = false
        delegate = self
        
        // Prevents pageview swiping if there is only 1 image
        if puppy.puppyAdditionalImages.count > 1 {
            dataSource = self
        } else {
            dataSource = nil
            puppy.puppyAdditionalImages.append("https://mylostpetalert.com/wp-content/themes/mlpa-child/images/nophoto.gif")
        }
        
        self.turnToPage(index: 0)
    }
    
    func turnToPage(index: Int) {
        let controller = caroselViews[index]
        var direction = UIPageViewControllerNavigationDirection.forward
        
        if let currentVC = viewControllers?.first {
            let currentIndex = caroselViews.index(of: currentVC)!
            if currentIndex > index {
                direction = .reverse
            }
        }
        
        self.configureDisplaying(viewController: controller)
        
        setViewControllers([controller], direction: direction, animated: true, completion: nil)
    }
    
    func configureDisplaying(viewController: UIViewController) {
        for (index, vc) in caroselViews.enumerated() {
            if viewController === vc {
                if let heroImageVC = viewController as? ImageViewController {
                    heroImageVC.heroImage?.sd_setImage(with: URL(string: puppy.puppyAdditionalImages[index]))
                    
                    self.pageViewControllerDelegate?.turnPageController(to: index)
                }
            }
        }
    }
    
    
    // MARK: UIPageViewControllerDataSource
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return puppy.puppyAdditionalImages.count
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let currentIndex : Int = caroselViews.index(of: viewController) ?? 0
        if currentIndex == caroselViews.count - 1 {
            return caroselViews.first
        }
        return caroselViews[currentIndex + 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let currentIndex : Int = caroselViews.index(of: viewController) ?? 0
        if currentIndex <= 0 {
            return caroselViews.last
        }
        return caroselViews[currentIndex - 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        self.configureDisplaying(viewController: pendingViewControllers.first as! ImageViewController)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if !completed {
            self.configureDisplaying(viewController: previousViewControllers.first as! ImageViewController)
        }
    }
}
