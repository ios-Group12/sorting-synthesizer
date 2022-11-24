//
//  SettingsViewController.swift
//  SortingSynth
//
//  Created by Emrys Jenkins Taylor on 11/16/22.
//
import UIKit
import AudioKit
import MediaPlayer
import SoundpipeAudioKit

protocol MyDataSendingDelegateProtocol {
    func sendDataToFirstViewController(myData: Int)
}

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var textbox: UITextField!
    @IBOutlet weak var synthSelectorSwitch: UIImageView!
    
    @IBOutlet weak var volumeSliderView: MPVolumeView!
    var delegate: MyDataSendingDelegateProtocol? = nil
    var settingSound:OscillatorConductor?
    var waveTableIndex:Int?
    @Published var degrees: CGFloat = 0.0
    
    //this is a hidden button layered over top of our rotary knob imageview
    //this should be refactored to a different name
    @IBAction func onTestPress(_ sender: Any) {
        print("test press")
        settingSound?.cycleOscillator()
        degrees += 90.0 //the value in degrees
        let radians: CGFloat = degrees * (.pi / 180)
        synthSelectorSwitch.transform = CGAffineTransform(rotationAngle: radians)
        
    }
    @IBOutlet weak var testButton: UIButton!
    
   //bar button triggers delegate to send back index value of waveTable
    //dismisses the view if successful
    @IBAction func onBarButtonClick(_ sender: Any) {
        print("Leaving settings. WTI = ")
        print(settingSound?.waveTableIndex as Any)
        if self.delegate != nil && self.settingSound?.waveTableIndex != nil {
            let dataToBeSent = self.settingSound?.waveTableIndex
                    self.delegate?.sendDataToFirstViewController(myData: dataToBeSent!)
                    dismiss(animated: true, completion: nil)
                }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        volumeSliderView.backgroundColor = .black
        volumeSliderView.transform = CGAffineTransform(rotationAngle: (CGFloat.pi*3/2))
        volumeSliderView.setMaximumVolumeSliderImage(UIImage(named: "blackline1"), for: .normal)
        volumeSliderView.setVolumeThumbImage(UIImage(named: "thumb-image"), for: .normal)
        setRotaryPosition()
        }
    
    //this is used to set the initial rotary knob position
    func setRotaryPosition(){
        //the value in degrees
        let radians: CGFloat
        switch settingSound?.waveTableIndex{
            case 0:
                degrees = 0.0
                radians = degrees * (.pi / 180)
            case 1:
                degrees = 90.0
                radians = degrees * (.pi / 180)
            case 2:
                degrees = 180.0
                radians = degrees * (.pi / 180)
            case 3:
                degrees = 270.0
                radians = degrees * (.pi / 180)
            default:
                degrees = 0.0
                radians = degrees * (.pi / 180)
            }
        synthSelectorSwitch.transform = CGAffineTransform(rotationAngle: radians)
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
    

