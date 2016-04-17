//
//  ProfileTableViewController.swift
//  SheffieldRiders
//
//  Created by Tom Sugarex on 24/03/2016.
//  Copyright © 2016 Tom Sugarev. All rights reserved.
//

import UIKit
import Gloss
import SwiftKeychainWrapper
import CoreData
import DATAStack

protocol ProfileTableViewControllerDelegate {
    func reloadData(spots:[Spot])
}

enum ImageChosen : Int {
    case ProfileImageButton = 0
    case MyRideImageButton = 1
}

class ProfileTableViewController: UITableViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet weak var headerCell: UITableViewCell!
    @IBOutlet weak var locationVisitedCell: UITableViewCell!
    @IBOutlet weak var statisticsCell: UITableViewCell!
    @IBOutlet weak var rideCell: UITableViewCell!
    @IBOutlet weak var locationVisitedView: UIView!
    @IBOutlet weak var stackview: UIStackView!
    
    @IBOutlet weak var profilePictureButton: UIButton!
    @IBOutlet weak var MyRidePictureButton: UIButton!
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var quoteLabel: UILabel!
    @IBOutlet weak var disciplineLabel: UILabel!
    @IBOutlet weak var riderRepLabel: UILabel!
    
    @IBOutlet weak var racedCountLabel: UILabel!
    @IBOutlet weak var raceWonLabel: UILabel!
    @IBOutlet weak var race2ndLabel: UILabel!
    @IBOutlet weak var race3rdLabel: UILabel!
    
    
    var delegate: ProfileTableViewControllerDelegate?
    var userProfile : UserProfile?
    var spotsVisited: [Spot]?
    var usernameForProfile: String?
    
    
    
    var imageChosenTag :ImageChosen = ImageChosen.ProfileImageButton
    
    var imagePicker: UIImagePickerController!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Profile"
        let navigationBarHeight: CGFloat = self.navigationController!.navigationBar.frame.height
        let statusBarHeight = UIApplication.sharedApplication().statusBarFrame.size.height
        
        let total = navigationBarHeight + statusBarHeight

        tableView.contentInset = UIEdgeInsetsMake(total,0,0,0);
        
        MyRidePictureButton.imageView?.contentMode = .ScaleAspectFill

        
        imagePicker =  UIImagePickerController()
        imagePicker.delegate = self
        
        if (usernameForProfile == nil) {
            navigationItem.leftBarButtonItem = DropDownMenu.sharedInstance.menuButton
            NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.showMenu), name: "showMenu", object: nil)
            
            let rightBarButton = UIBarButtonItem(title: "Edit", style: .Done, target: self, action: #selector(self.editProfile))
            navigationItem.rightBarButtonItem = rightBarButton

        }
        NSNotificationCenter.defaultCenter().addObserverForName("usersUpdated", object: nil, queue: nil) { _ in
            self.fetchProfile()
            self.updateUI()
            self.refreshControl?.endRefreshing()
        }
        refreshControl?.attributedTitle
        refreshControl?.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl?.addTarget(self, action: #selector(refresh), forControlEvents: UIControlEvents.ValueChanged)

        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let dataStack:DATAStack = appDelegate.dataStack
        let request = NSFetchRequest(entityName: "UserProfile")
        
        do {
            let profileResults:[UserProfile] = try dataStack.mainContext.executeFetchRequest(request) as! [UserProfile]
            
            for profile in profileResults {
                print("Users - ", profile.username)
            }
            fetchProfile()
            updateUI()
        } catch {
            print("fetch errored")
        }
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
//        refresh()
    }

    func editProfile(){
        self.performSegueWithIdentifier("editProfileSegue", sender: self)
    }
    
    func fetchProfile(){
        if (usernameForProfile != nil) {
            fetchProfileWith(usernameForProfile!)
        }
        else
        {
            let loggedInUserName = NSUserDefaults.standardUserDefaults().objectForKey(Constants.LoggedInUser) as? String
            if let loggedInUserName = loggedInUserName {
                fetchProfileWith(loggedInUserName)
            }
        }
        
    }
    
    func fetchProfileWith(username: String){
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let dataStack:DATAStack = appDelegate.dataStack
        let request = NSFetchRequest(entityName: "UserProfile")
        request.predicate = NSPredicate(format: "username == %@", username)
        request.fetchLimit = 1
        
        do {
            let profileResults:[UserProfile] = try dataStack.mainContext.executeFetchRequest(request) as! [UserProfile]
            
            userProfile = profileResults.first
            print(userProfile)
            
            if let userProfile = userProfile {
                let requestSpots = NSFetchRequest(entityName: "Spot")
                requestSpots.predicate = NSPredicate(format: "userProfile = %@", userProfile)
                spotsVisited = (try? dataStack.mainContext.executeFetchRequest(requestSpots)) as? [Spot]
                
            }
        } catch {
            print("Fetch failed")
        }
        
    }
    
    func updateUI() {
        
        if let profile = userProfile {
            usernameLabel.text = profile.username
            quoteLabel.text = profile.quote
            disciplineLabel.text = profile.discipline
            riderRepLabel.text = "\(profile.rep!)"
            if let spotsVisited = spotsVisited {
                delegate?.reloadData(spotsVisited)
            }
            racedCountLabel.text = "\(profile.race_count!)"
            raceWonLabel.text = "\(profile.won!)"
            race2ndLabel.text = "\(profile.second!)"
            race3rdLabel.text = "\(profile.third!)"
        }

    }
    
    func refresh()
    {
        DataSynchroniser.sharedInstance.syncUsers(nil)
    }
    

    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        switch indexPath.row {
        case 0: return headerCell.frame.height
        case 1: return stackview.frame.height
        case 2: return statisticsCell.frame.height
        case 3: return rideCell.frame.height
        default: return 200
        }
    }
    
    func showMenu() {
        DropDownMenu.sharedInstance.showMenu(self.view)
    }
    
    
    @IBAction func profilePicTapped(sender: UIButton) {
        imageChosenTag = ImageChosen(rawValue: sender.tag)!
        let alert = UIAlertController(title: "Edit Picture", message: "Choose/take profile picture", preferredStyle: .ActionSheet) // 1
        let photosAction = UIAlertAction(title: "Photos", style: .Default) { (alert: UIAlertAction!) -> Void in
            self.openPhotos()
        }
        
        let cameraAction = UIAlertAction(title: "Camera", style: .Default) { (alert: UIAlertAction!) -> Void in
            self.openCamera()
        }
        
        alert.addAction(cameraAction)
        alert.addAction(photosAction)
        presentViewController(alert, animated: true, completion:nil)
        
    }
    
    func openPhotos(){
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .PhotoLibrary
        
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func openCamera(){
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .Camera
        
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    

    func imagePickerController(
        picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let chosenImage = info[UIImagePickerControllerEditedImage] as! UIImage

        switch imageChosenTag {
        case ImageChosen.ProfileImageButton:
            profilePictureButton.setImage(chosenImage, forState: .Normal)
            break
        case ImageChosen.MyRideImageButton:
            MyRidePictureButton.setImage(chosenImage, forState: .Normal)
        default:
            break
        }
        

        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            if (identifier == "spotsVisitedSegue"){
                
                let viewController = segue.destinationViewController as! ProfileLocationsCollectionViewController
                delegate = viewController
                
            }
        }
        if let identifier = segue.identifier {
            if (identifier == "editProfileSegue"){
                
                let viewController = segue.destinationViewController as! UpdateProfileViewController
                
                if let profile = userProfile {
                    viewController.quote = profile.quote
                    viewController.discipline = profile.discipline
                }
                
            }
        }
    }
}
