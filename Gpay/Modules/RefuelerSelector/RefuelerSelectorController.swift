//
//  RefuelerSelectorController.swift
//  Gpay
//
//  Created by Vladimir Kokhanevich on 06/03/2018.
//  Copyright © 2018 gpn. All rights reserved.
//

import UIKit

class RefuelerSelectorController: UIViewController {

    @IBOutlet weak var mainTitle: UILabel!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var separator: UIView!
    
    @IBOutlet weak var action: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
