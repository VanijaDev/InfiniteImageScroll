//
//  ViewController.swift
//  InfiniteImageScroll
//
//  Created by Ivan Solomichev on 10/15/16.
//  Copyright © 2016 Ivan Solomichev. All rights reserved.
//

import UIKit

final class ViewController: UIViewController {
    @IBOutlet private weak var infiniteImages: InfiniteScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        infiniteImages.populate(imagePathes: [
            "https://icons.iconarchive.com/icons/mattahan/umicons/128/Number-0-icon.png",
            "https://icons.iconarchive.com/icons/mattahan/umicons/128/Number-1-icon.png",
            "https://icons.iconarchive.com/icons/mattahan/umicons/128/Number-2-icon.png",
            "https://icons.iconarchive.com/icons/mattahan/umicons/128/Number-3-icon.png",
            "https://icons.iconarchive.com/icons/mattahan/umicons/128/Number-4-icon.png",
            "https://icons.iconarchive.com/icons/mattahan/umicons/128/Number-5-icon.png",
            "https://icons.iconarchive.com/icons/mattahan/umicons/128/Number-6-icon.png",
            "https://icons.iconarchive.com/icons/mattahan/umicons/128/Number-7-icon.png",
            "https://icons.iconarchive.com/icons/mattahan/umicons/128/Number-8-icon.png",
            "https://icons.iconarchive.com/icons/mattahan/umicons/128/Number-9-icon.png"])
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

