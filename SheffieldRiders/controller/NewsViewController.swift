//
//  NewsViewController.swift
//  SheffieldRiders
//
//  Created by Tom Sugarex on 25/03/2016.
//  Copyright © 2016 Tom Sugarev. All rights reserved.
//

import UIKit

class NewsViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textLabel: UILabel!
    
    var newsArticle = Dictionary<String, String>()
    

    override func viewDidLoad() {
        super.viewDidLoad()

        textLabel.text = newsArticle["body"]
        if let image = UIImage(named: newsArticle["image"]!) {
            imageView.image = image
        }
        
        self.navigationItem.title = newsArticle["title"]
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        scrollView.contentSize.height = CGRectGetMaxY(textLabel.frame) + 8
        
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
