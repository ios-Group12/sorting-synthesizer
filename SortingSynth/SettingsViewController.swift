//
//  SettingsViewController.swift
//  SortingSynth
//
//  Created by Emrys Jenkins Taylor on 11/16/22.
//
//This class is used to handle logic within the SettingsView
//The settings view gives the user ability to modify a DynamicOscillator()
import UIKit
import AudioKit
import MediaPlayer
import SoundpipeAudioKit

protocol MyDataSendingDelegateProtocol {
    func sendDataToFirstViewController(myData: Int)
}

class SettingsViewController: UIViewController {
    
    

    
    @IBOutlet weak var reverbSelectorSwitch: UIImageView!
    @IBOutlet weak var delaySelectorSwitch: UIImageView!
    @IBOutlet weak var synthSelectorSwitch: UIImageView!
    @IBOutlet weak var sortSelectorSwitch: UIImageView!
    @IBOutlet weak var volumeSliderView: MPVolumeView!
    var delegate: MyDataSendingDelegateProtocol? = nil //communicating across views
    var settingSound:OscillatorConductor? //receives OscillatorConductor from SynthView
    var waveTableIndex:Int? //holds index of which oscillator to use
    @Published var oscDegrees: CGFloat = 0.0 //position of oscillator rotary dial
    @Published var sortDegrees: CGFloat  = 0.0 //position of sort rotary dial
    
    //this is a hidden button layered over top of our rotary knob imageview
    //this should be refactored to a different name
    @IBAction func onTestPress(_ sender: Any) {
        print("test press")
        settingSound?.cycleOscillator()
        oscDegrees += 90.0 //the value in degrees
        let radians: CGFloat = oscDegrees * (.pi / 180)
        synthSelectorSwitch.transform = CGAffineTransform(rotationAngle: radians)
        
    }
    
    //this is a hidden button layered over top of our rotary knob imageview
    //changes sorting algorithm
    @IBAction func onSortPress(_ sender: Any) {
        print("sort press")
        settingSound?.cycleSort()
        sortDegrees += 90.0 //the value in degrees
        let radians: CGFloat = sortDegrees * (.pi / 180)
        sortSelectorSwitch.transform = CGAffineTransform(rotationAngle: radians)
    }
    
    //delay was toggled
    //if delay is on, turn it off
    //if delay is off, turn it on
    
    
    @IBAction func onDelayPress(_ sender: Any) {
        switch settingSound?.isDelay{
        case true:
            delaySelectorSwitch.image = UIImage(named: "toggleOff")
            settingSound?.delay.bypass()
        case false:
            delaySelectorSwitch.image = UIImage(named: "toggleOn")
            settingSound?.delay.play()
        default: settingSound?.delay.bypass()
        }
        settingSound?.isDelay = !(settingSound?.isDelay ?? false)
    }
    
    //reverb was toggled
    //if reverb is on, turn it off
    //if reverb is off, turn it on
    @IBAction func onReverbPress(_ sender: Any) {
        switch settingSound?.isReverb{
        case true:
            reverbSelectorSwitch.image = UIImage(named: "toggleOff")
            settingSound?.reverb.bypass()
        case false:
            reverbSelectorSwitch.image = UIImage(named: "toggleOn")
            settingSound?.reverb.play()
        default: settingSound?.reverb.bypass()
        }
        settingSound?.isReverb = !(settingSound?.isReverb ?? false)
    }
    
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
        setDialPositions() //set knob positions
        }
    
    //this is used to set the initial rotary knob position
    func setDialPositions(){
        
        //toggle switches
        switch settingSound?.isDelay{
        case true:
            delaySelectorSwitch.image = UIImage(named: "toggleOn")
        case false:
            delaySelectorSwitch.image = UIImage(named: "toggleOff")
        default: delaySelectorSwitch.image = UIImage(named: "toggleOff")
        }
        
        switch settingSound?.isReverb{
        case true:
            reverbSelectorSwitch.image = UIImage(named: "toggleOn")
        case false:
            reverbSelectorSwitch.image = UIImage(named: "toggleOff")
        default: reverbSelectorSwitch.image = UIImage(named: "toggleOff")
        }
        
        //rotary knobs
        let radians: CGFloat
        switch settingSound?.waveTableIndex{
            case 0:
                oscDegrees = 0.0
                radians = oscDegrees * (.pi / 180)
            case 1:
                oscDegrees = 90.0
                radians = oscDegrees * (.pi / 180)
            case 2:
                oscDegrees = 180.0
                radians = oscDegrees * (.pi / 180)
            case 3:
                oscDegrees = 270.0
                radians = oscDegrees * (.pi / 180)
            default:
                oscDegrees = 0.0
                radians = oscDegrees * (.pi / 180)
            }
        //change picture position
        synthSelectorSwitch.transform = CGAffineTransform(rotationAngle: radians)
        
        let rad: CGFloat
        switch settingSound?.sortIndex{
            case 0:
                sortDegrees = 0.0
                rad = sortDegrees * (.pi / 180)
            case 1:
                sortDegrees = 90.0
                rad = sortDegrees * (.pi / 180)
            case 2:
                sortDegrees = 180.0
                rad = sortDegrees * (.pi / 180)
            case 3:
                sortDegrees = 270.0
                rad = sortDegrees * (.pi / 180)
            default:
                sortDegrees = 0.0
                rad = sortDegrees * (.pi / 180)
            }
        //change picture position
        sortSelectorSwitch.transform = CGAffineTransform(rotationAngle: rad)
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
