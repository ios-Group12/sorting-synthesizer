//
//  SynthViewController.swift
//  SortingSynth
//
//  Created by Emrys Jenkins Taylor on 11/11/22.
//

import UIKit
import AudioKit
import SoundpipeAudioKit


class SynthViewController: UIViewController, MyDataSendingDelegateProtocol {
    var uview:UIView = UIView()
    var sound:OscillatorConductor = OscillatorConductor()
    
    @IBOutlet weak var testLabel: UILabel!
    @IBOutlet weak var stopButton: UIImageView!
    @IBOutlet weak var playButton: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.stopButton.isUserInteractionEnabled = true
        self.playButton.isUserInteractionEnabled = true
        // Do any additional setup after loading the view.
    }
    // Delegate Method
      func sendDataToFirstViewController(myData: Int) {
          self.sound.waveTableIndex = myData
      }
    
    //segue to settings via custom segue
    @IBAction func onSettingsClick(_ sender: Any) {
        self.performSegue(withIdentifier: "synthToSettingsSegue", sender: self)
    }
    
    //prepare for segue, assign objects to pass through model
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "synthToSettingsSegue" {
                let secondVC: SettingsViewController = segue.destination as! SettingsViewController
                secondVC.delegate = self
                secondVC.settingSound = self.sound
            }
    }
        
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
            super.touchesEnded(touches, with: event)
            
            if let touch = touches.first {
                //play button pressed
                if touch.view == self.playButton {//image View property
                    print(sound.waveTableIndex)
                    sound.noteOn()
                    //sound.osc.frequency = 440.0
                   // print(sound.osc.frequency)
                }
                
                //stop button pressed
                if touch.view == self.stopButton{
                    sound.noteOff()
                }
            }
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
