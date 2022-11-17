//
//  SettingsViewController.swift
//  SortingSynth
//
//  Created by Emrys Jenkins Taylor on 11/16/22.
//
import UIKit
import MediaPlayer

class SettingsViewController: UIViewController {
    
    
    
    
    
    @IBOutlet weak var volumeSliderView: MPVolumeView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        volumeSliderView.backgroundColor = .black
        volumeSliderView.transform = CGAffineTransform(rotationAngle: (CGFloat.pi*3/2))
            
        volumeSliderView.setMaximumVolumeSliderImage(UIImage(named: "blackline1"), for: .normal)
        volumeSliderView.setVolumeThumbImage(UIImage(named: "thumb-image"), for: .normal)
        
        
        }
    
        
        
        //    @IBAction func volumeValue(_ sender: Any) {
        //
        //        volumeSlider.transform = CGAffineTransform(rotationAngle: (CGFloat.pi/2))
        //        if let thumbImage = UIImage(named: "thumb-image") {
        //            volumeSlider.setThumbImage(thumbImage, for: .normal)
        //            volumeSlider.setThumbImage(thumbImage, for: .highlighted)
        //        }
        //    }
        //
        
    }
    

