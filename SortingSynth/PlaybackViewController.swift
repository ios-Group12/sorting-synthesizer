//
//  PlaybackViewController.swift
//  SortingSynth
//
//  Created by Emrys Jenkins Taylor on 11/28/22.
//

import UIKit
import AudioKit


class PlaybackViewController: UIViewController {
        
    
    
    @IBOutlet weak var playImage: UIImageView!
    @IBOutlet weak var pauseImage: UIImageView!
    
    @IBAction func barButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)

    }
    
    @IBAction func playSound(_ sender: Any) {
        AudioPlayer.play()
        self.playImage.image = UIImage(named: "PLAYING")

    }
    @IBAction func pauseSound(_ sender: Any) {
        AudioPlayer.pause()
        self.playImage.image = UIImage(named: "PLAY")

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

}
