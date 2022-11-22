//
//  TabBarViewController.swift
//  SortingSynth
//
//  Created by McKerlton Hyppolite on 11/20/22.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        

        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        let height = navigationController?.navigationBar.frame.maxY
        tabBar.frame = CGRect(x: 0, y: height ?? 0, width: tabBar.frame.size.width, height: tabBar.frame.size.height)
        super.viewDidLayoutSubviews()
      }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
