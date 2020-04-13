//
//  SaperateViewController.swift
//  mapkitDemo5_cab
//
//  Created by Third Rock Techkno on 13/04/20.
//  Copyright © 2020 Third Rock Techkno. All rights reserved.
//

import UIKit

class SaperateViewController: UIViewController {


    @IBAction func submitform(_ sender: UIButton) {
        
        print("submmitted")
        
    }

    @IBOutlet weak var swich: UISwitch!

    @IBOutlet weak var lbl: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        swich.setOn(true, animated: true)
        lbl.text = "Saperate ViewController"
    }
    

    @IBAction func onClick(_ sender: UIButton) {
        swich.setOn(false, animated: true)
    }
    

}
