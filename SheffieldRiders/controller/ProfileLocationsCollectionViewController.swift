//
//  ProfileLocationsCollectionViewController.swift
//  SheffieldRiders
//
//  Created by Tom Sugarex on 03/04/2016.
//  Copyright © 2016 Tom Sugarev. All rights reserved.
//

import UIKit


private let reuseIdentifier = "Cell"

class ProfileLocationsCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, ProfileTableViewControllerDelegate {

    var spotsVisited: [Spot]?
    {
        didSet {
            spotsVisited!.sortInPlace({$0.visits!.intValue > $1.visits!.intValue})
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print(spotsVisited?.count)
    }
    
    func reloadData(spots: [Spot]) {
        self.spotsVisited = spots
        collectionView?.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }



    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 7
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! SpotVisitedCollectionViewCell
    
        if let spots = spotsVisited {
            let spot = spots[indexPath.row]
            cell.nameLabel.text = spot.name
            cell.image.image = UIImage(named: spot.name!)
            if let visits = spot.visits
            {
                cell.countLabel.text = "\(visits)"
            }
            
            
        }
        
        
    
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize
    {
        let height = CGRectGetHeight(collectionView.frame)
        return CGSizeMake(height, height)
    }
    
    
}

