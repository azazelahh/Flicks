//
//  MovieDetailsViewController.swift
//  Flicks
//
//  Created by Olya Sorokina on 10/15/16.
//  Copyright © 2016 olya. All rights reserved.
//

import UIKit

class MovieDetailsViewController: UIViewController {

    @IBOutlet weak var posterImage: UIImageView!
    public var url: String = ""
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var summaryLabel: UILabel!
    public var summary: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        posterImage.setImageWith(URL(string: url)!)
    
        summaryLabel.text = summary
        summaryLabel.sizeToFit()
        scrollView.contentSize = summaryLabel.frame.size
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
