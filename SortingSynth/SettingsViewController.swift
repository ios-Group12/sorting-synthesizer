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

    @IBOutlet var keyButtonImages: [UIImageView]! //this contains all the push buttons, whose indices are saved into their respective tags
    
    
    @IBOutlet weak var octaveLowButton: UIImageView!
    @IBOutlet weak var octaveMedButton: UIImageView!
    @IBOutlet weak var octaveHighButton: UIImageView!
    @IBOutlet weak var minorPushButton: UIImageView!
    @IBOutlet weak var speedSelectorSwitch: UIImageView!
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
    @Published var speedDegrees: CGFloat = 0.0 //position of speed rotary dial
    
    //this is a hidden button layered over top of our rotary dial imageview
    //this should be refactored to a different name
    @IBAction func onOscillatorPress(_ sender: Any) {
        print("test press")
        settingSound?.cycleOscillator()
        oscDegrees += 90.0 //the value in degrees
        let radians: CGFloat = oscDegrees * (.pi / 180)
        synthSelectorSwitch.transform = CGAffineTransform(rotationAngle: radians)
        
    }
    
    //this is a hidden button layered over top of our rotary dial imageview
    //changes sorting algorithm
    @IBAction func onSortPress(_ sender: Any) {
        print("sort press")
        settingSound?.cycleSort()
        sortDegrees += 90.0 //the value in degrees
        let radians: CGFloat = sortDegrees * (.pi / 180)
        sortSelectorSwitch.transform = CGAffineTransform(rotationAngle: radians)
    }
    
    //speed dial has 3 settings
    //setting 1: ~0.075 seconds between notes
    //setting 2: ~0.050 seconds between notes
    //setting 3: ~0.025 seconds between notes
    @IBAction func onSpeedPress(_ sender: Any) {
        let speedRad: Double
        switch settingSound?.speed{
            case 0.050: //position 2
                    speedDegrees = 45.0 //set to position 3
                    speedRad = speedDegrees * (.pi / 180)
            settingSound?.speed = 0.025
            break
            case 0.075: //position 1
                    speedDegrees = 0.0 //set to position 2
                    speedRad = speedDegrees * (.pi / 180)
            settingSound?.speed = 0.050
            break
            case 0.025: //position 3
                    speedDegrees = 315.0 //set to position 1
                    speedRad = speedDegrees * (.pi / 180)
            settingSound?.speed = 0.075
            break
            default:
                    speedDegrees = 0.0
                    speedRad = speedDegrees * (.pi / 180)
            settingSound?.speed = 0.050
            break
        }
        //change picture position
        speedSelectorSwitch.transform = CGAffineTransform(rotationAngle: speedRad)
        
    }
    
    //delay was toggled
    //if delay is on, turn it off
    //if delay is off, turn it on
    @IBAction func onDelayPress(_ sender: Any) {
        switch settingSound?.isDelay{
        case true:
            delaySelectorSwitch.image = UIImage(named: "toggleOff")
            settingSound?.delay.bypass()
            break
        case false:
            delaySelectorSwitch.image = UIImage(named: "toggleOn")
            settingSound?.delay.play()
            break
        default: settingSound?.delay.bypass()
            break
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
            break
        case false:
            reverbSelectorSwitch.image = UIImage(named: "toggleOn")
            settingSound?.reverb.play()
            break
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
        setVolumeSlider()
        setDialPositions() //set dial positions
        }
    
    func setVolumeSlider(){
        volumeSliderView.backgroundColor = .black
        volumeSliderView.transform = CGAffineTransform(rotationAngle: (CGFloat.pi*3/2))
        volumeSliderView.setMaximumVolumeSliderImage(UIImage(named: "blackline1"), for: .normal)
        volumeSliderView.setVolumeThumbImage(UIImage(named: "thumb-image"), for: .normal)
        volumeSliderView.showsRouteButton = false
    }
    
    //this sets the positions of the UI switches and dials
    //to be used in the viewdidload()
    func setDialPositions(){
        
        //set delay toggle switche
        switch settingSound?.isDelay{
        case true:
            delaySelectorSwitch.image = UIImage(named: "toggleOn")
            break
        case false:
            delaySelectorSwitch.image = UIImage(named: "toggleOff")
            break
        default: delaySelectorSwitch.image = UIImage(named: "toggleOff")
            break
        }
        
        //set reverb toggle switch
        switch settingSound?.isReverb{
        case true:
            reverbSelectorSwitch.image = UIImage(named: "toggleOn")
            break
        case false:
            reverbSelectorSwitch.image = UIImage(named: "toggleOff")
            break
        default: reverbSelectorSwitch.image = UIImage(named: "toggleOff")
            break
        }
        
        //set oscillator dial
        let radians: CGFloat
        switch settingSound?.waveTableIndex{
            case 0:
                oscDegrees = 0.0
                radians = oscDegrees * (.pi / 180)
            break
            case 1:
                oscDegrees = 90.0
                radians = oscDegrees * (.pi / 180)
            break
            case 2:
                oscDegrees = 180.0
                radians = oscDegrees * (.pi / 180)
            break
            case 3:
                oscDegrees = 270.0
                radians = oscDegrees * (.pi / 180)
            break
            default:
                oscDegrees = 0.0
                radians = oscDegrees * (.pi / 180)
            break
            }
        //change picture position
        synthSelectorSwitch.transform = CGAffineTransform(rotationAngle: radians)
        
        //set sort dial
        let rad: CGFloat
        switch settingSound?.sortIndex{
            case 0:
                sortDegrees = 0.0
                rad = sortDegrees * (.pi / 180)
            break
            case 1:
                sortDegrees = 90.0
                rad = sortDegrees * (.pi / 180)
            break
            case 2:
                sortDegrees = 180.0
                rad = sortDegrees * (.pi / 180)
            break
            case 3:
                sortDegrees = 270.0
                rad = sortDegrees * (.pi / 180)
            break
            default:
                sortDegrees = 0.0
                rad = sortDegrees * (.pi / 180)
            break
            }
        //change picture position
        sortSelectorSwitch.transform = CGAffineTransform(rotationAngle: rad)
        
        //set speed dial
        let speedRad: CGFloat
        switch settingSound?.speed{
            case 0.050:
                    speedDegrees = 0.0
                    speedRad = speedDegrees * (.pi / 180)
            break
            case 0.075:
                    speedDegrees = 315.0
                    speedRad = speedDegrees * (.pi / 180)
            break
            case 0.025:
                    speedDegrees = 45.0
                    speedRad = speedDegrees * (.pi / 180)
            break
            default:
                    speedDegrees = 0.0
                    speedRad = speedDegrees * (.pi / 180)
            break
        }
        //change picture position
        speedSelectorSwitch.transform = CGAffineTransform(rotationAngle: speedRad)
        setPushButtons()
    }
    
    //sets push buttons
    func setPushButtons(){
        for button in keyButtonImages{
            if (button.tag == settingSound?.selectedKeyIndex1 || button.tag == settingSound?.selectedKeyIndex2){
                button.image = UIImage(named: "pushButtonOn")
            } else {
                button.image = UIImage(named: "pushButtonOff")
            }
        }
        //set minor push button.
        //swift is complaining about possible null values
        //using a switch statement due to possible null
        switch settingSound?.isMinor{
        case true:
            minorPushButton.image = UIImage(named: "bigPushButtonOn")
            break
        default:
            minorPushButton.image = UIImage(named: "bigPushButtonOff")
            break
        }
        
        //set octave push buttons
        switch settingSound?.isLow {
        case true:
            octaveLowButton.image = UIImage(named: "pushButtonOn")
            break
        default:
            octaveLowButton.image = UIImage(named: "pushButtonOff")
        }
        
        switch settingSound?.isMed{
        case true:
            octaveMedButton.image = UIImage(named: "pushButtonOn")
            break
        default:
            octaveMedButton.image = UIImage(named: "pushButtonOff")
        }
    
        switch settingSound?.isHigh{
        case true:
            octaveHighButton.image = UIImage(named: "pushButtonOn")
            break
        default:
            octaveHighButton.image = UIImage(named: "pushButtonOff")
        }
        
    }
    
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
            super.touchesEnded(touches, with: event)
            
            if let touch = touches.first {
                //minor button was pushed, activates minor (aeolian) mode
                if touch.view == minorPushButton{
                    settingSound?.isMinor = !settingSound!.isMinor
                }
                //octave buttons
                if touch.view == octaveLowButton{
                    settingSound?.isLow = !settingSound!.isLow
                }
                
                if touch.view == octaveMedButton{
                    settingSound?.isMed = !settingSound!.isMed
                }
                
                if touch.view == octaveHighButton{
                    settingSound?.isHigh = !settingSound!.isHigh
                }
                setPushButtons()
                //key signature button pressed. button tags hold their index value
                //if the button tag matches the selected index,
                for button in self.keyButtonImages{
                    if touch.view == button{
                        //if the button's tag matches the index, turn it off
                        if (button.tag == settingSound?.selectedKeyIndex1 || button.tag == settingSound?.selectedKeyIndex2){
                            //deselect key and set to chromatic
                            if (button.tag == settingSound?.selectedKeyIndex1){
                                settingSound?.selectedKeyIndex1 = -1
                            } else {
                                settingSound?.selectedKeyIndex2 = -1
                            }
                        } else {
                            //the button needs to be on, set index to button tag
                            button.image = UIImage(named: "pushButtonOn")
                            settingSound?.selectedKeyIndex1 = button.tag
                        }
                        setPushButtons() //call set keys to turn off unselected buttons
                    }
                }
            }
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
