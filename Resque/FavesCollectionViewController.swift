//
//  FavesCollectionViewController.swift
//  rescue
//
//  Created by Roback, Jerry on 10/17/17.
//  Copyright © 2017 Roback, Jerry. All rights reserved.
//

import UIKit

class FavesCollectionViewController: UICollectionViewController {
    
    @IBOutlet weak var hamburgerMenuButtonOutlet: UIBarButtonItem!
    
    struct Storyboard {
        static let favesCell = "FavesCell"
        static let sectionHeader = "FavesSectionHeader"
        static let showDetailSegue = "ShowPuppyDetailSegue"
        
        static let leftAndRightPadding: CGFloat = 36.0 // from 32.0 -- 3 items per row, meaning 4 paddings of 8 each
        static let numberOfItemsPerRow: CGFloat = 2.0 // from 3.0
        static let aspectRatio: CGFloat = 1.15748
    }
    
    override func viewDidAppear(_ animated: Bool) {
        collectionView?.reloadData()
        
        // Create Subview for the Empty State
        if favoritePuppies.count < 1 {
            self.setEmptyState()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // REMOVES THE LINE underneath the nav bar
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        hamburgerMenuButtonOutlet.target = self.revealViewController()
        hamburgerMenuButtonOutlet.action = #selector(SWRevealViewController().revealToggle(_:))

        let collectionViewWidth = collectionView?.frame.width
        let cellWidth = ((collectionViewWidth! - Storyboard.leftAndRightPadding) / Storyboard.numberOfItemsPerRow)
        
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        layout.headerReferenceSize = CGSize(width: collectionViewWidth!, height: 120)
        layout.itemSize = CGSize(width: cellWidth, height: cellWidth * Storyboard.aspectRatio)
    }
    
    // MARK: Helpers
    @objc func startNewSearch() {
        dismissCelebrationDown()
        self.performSegue(withIdentifier: "NewSearch", sender: nil)
    }
    
    
    @IBAction func unlikeDidTap(_ sender: FavoritesCollectionViewCell) {
        if favoritePuppies.count > 0 {
            collectionView?.reloadData()
        } else if favoritePuppies.count == 0 {
            collectionView?.reloadData()
            self.setEmptyState()
        }
    }
    
    func setEmptyState() {
        
        // Position Subview
        let xPercentage = view.frame.width / 100.0
        let yPercentage = view.frame.height / 100.0
        
        let subview:EmptyStateFrame = EmptyStateFrame(frame: CGRect(x: xPercentage * 0.0, y: yPercentage * 0.0, width: xPercentage * 100.0, height: yPercentage * 100.0))
        
        // Contruct Subview
        subview.heroImage.image = UIImage(named: "no-faves-3")
        subview.titleLabel.text = "No Favorites"
        subview.descriptionLabel.text = "Click the ♥︎ to add pups here."
        subview.actionButton.setTitle("Start New Search", for: .normal)
        subview.actionButton.addTarget(self, action: #selector(startNewSearch), for: .touchUpInside)
        
        view.addSubview(subview)
    }
    
    @objc func dismissCelebrationDown() {
        print("==== Dismiss === ")
        
        let window = UIApplication.shared.keyWindow!
        if let celebrationView = window.viewWithTag(6) {
            // Fade Animate Out
            UIWindow.animate(withDuration: 1.3, delay: 0.1, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.8, options: [.curveLinear], animations: {
                // celebrationView.alpha = 0
                celebrationView.transform = CGAffineTransform(translationX: 0, y: (window.frame.height) * 1.1)
            }) { _ in
                celebrationView.removeFromSuperview()
            }
        }
    }
    

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favoritePuppies.count
    }
    
    override func collectionView(_ collectionView: UICollectionView,
                                 viewForSupplementaryElementOfKind kind: String,
                                 at indexPath: IndexPath) -> UICollectionReusableView {
        //1
        switch kind {
        //2
        case UICollectionElementKindSectionHeader:
            //3
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                             withReuseIdentifier: Storyboard.sectionHeader,
                                                                             for: indexPath) as! SectionHeaderCollectionReusableView
            if favoritePuppies.count > 0 {
                headerView.heroImage.loadGif(name:"dog04")
            } else {
                headerView.heroHeadline.text = ""
                headerView.heroSubheadline.text = ""
                headerView.backgroundColor = UIColor.groupTableViewBackground
            }
            
            
            return headerView
        default:
            //4
            assert(false, "Unexpected element kind")
        }
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Storyboard.favesCell, for: indexPath) as! FavoritesCollectionViewCell
    
        let fave = favoritePuppies[indexPath.item]
        cell.fave = fave
        
        return cell
    }

    // MARK: Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Storyboard.showDetailSegue {
            let puppyDetailVC = segue.destination as! PuppyDetailViewController
            if let selectedIndex = collectionView?.indexPathsForSelectedItems?.first?.item {
                puppyDetailVC.puppy = favoritePuppies[selectedIndex]
            }
        }
    }
}

extension FavesCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {

        if collectionView.numberOfItems(inSection: section) == 0 {
            return CGSize.zero
        }
        return CGSize(width: collectionView.frame.width, height: 120)
    }
}

