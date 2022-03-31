//
//  StartScreenViewController.swift
//  movieSearch
//
//  Created by Switch on 27.09.2021.
//

import UIKit

class StartScreenViewController: UIViewController {


    @IBOutlet weak var StartBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func TapBtn(_ sender: Any) {
        performSegue(withIdentifier: "transfer", sender: self)
    }

    
}
