//
//  PlaybackViewController.swift
//  SortingSynth
//
//  Created by Emrys Jenkins Taylor on 11/28/22.
//

import UIKit

class PlaybackViewController: UIViewController {
        

    @IBAction func playSound(_ sender: Any) {
        AudioPlayer.play()
    }
    
    
    @IBAction func pauseSound(_ sender: Any) {
        AudioPlayer.pause()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
