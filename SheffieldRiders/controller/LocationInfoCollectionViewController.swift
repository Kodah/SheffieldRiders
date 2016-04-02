//
//  LocationInfoCollectionViewController.swift
//  SheffieldRiders
//
//  Created by Tom Sugarex on 28/03/2016.
//  Copyright © 2016 Tom Sugarev. All rights reserved.
//

import UIKit

private let descriptionCellIdentifier = "descriptionCell"
private let statsCellIdentifier = "statsCell"

protocol LocationInfoCollectionViewDelegate: class {
    func didChangeCollectionViewPage(page: Int)
}

class LocationInfoCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    var location = Dictionary<String, NSObject>()
    weak var delegate: LocationInfoCollectionViewDelegate?

    override func scrollViewDidEndDecelerating(scrollView: UIScrollView)
    {
        let pageWidth = collectionView!.frame.size.width
        
        let page = Int(collectionView!.contentOffset.x / pageWidth)
        delegate?.didChangeCollectionViewPage(page)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }


    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {

        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return 2
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize
    {
        return collectionView.frame.size
    }
    
    
    

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        

        switch indexPath.row {
        case 0:
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(descriptionCellIdentifier, forIndexPath: indexPath) as! LocationDescriptionCollectionViewCell
            
            cell.summaryTextView.text = location["summary"] as? String
            
            
            return cell
        case 1:
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(statsCellIdentifier, forIndexPath: indexPath) as! LocationStatsCollectionViewCell
            
            cell.disciplineLabel.text = location["discipline"] as? String
            cell.numTracksLabel.text = String(location["numberOfRoutes"]!)
            
            if let difficulties = location["difficulty"] as? Dictionary<String, Bool>
            {
                difficulties["black"]! ? turnLabelOn(cell.blackLabel) : turnLabelOff(cell.blackLabel)
                
                difficulties["doubleBlack"]! ? turnLabelOn(cell.doubleBlackLabel) : turnLabelOff(cell.doubleBlackLabel)
                
                difficulties["red"]! ? turnLabelOn(cell.redLabel) : turnLabelOff(cell.redLabel)
                
                difficulties["blue"]! ? turnLabelOn(cell.blueLabel) : turnLabelOff(cell.blueLabel)
                
                difficulties["green"]! ? turnLabelOn(cell.greenLabel) : turnLabelOff(cell.greenLabel)
            }
            
            
            
            return cell
        default:
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(statsCellIdentifier, forIndexPath: indexPath)
            
            return cell
        }
    }
    
    func turnLabelOn(label: UILabel)
    {
        label.text = "Available"
        label.backgroundColor = UIColor(colorLiteralRed: 0.33, green: 0.7, blue: 0.17, alpha: 0.5)
    }

    func turnLabelOff(label: UILabel)
    {
        label.text = "Unavailable"
        label.backgroundColor = UIColor(colorLiteralRed: 0.78, green: 0.15, blue: 0.17, alpha: 0.5)
    }

}
