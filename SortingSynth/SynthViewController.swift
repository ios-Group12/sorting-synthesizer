//
//  SynthViewController.swift
//  SortingSynth
//
//  Created by Emrys Jenkins Taylor on 11/11/22.
//

import UIKit
import AudioKit
import SoundpipeAudioKit
import Parse
import ReplayKit

class SynthViewController: UIViewController, MyDataSendingDelegateProtocol {
    var uview:UIView = UIView()
    var sound:OscillatorConductor = OscillatorConductor()
    var recorder: NodeRecorder?
    var fileName = "wilhelmscream.wav" //test audio file
    
    private var isActive = false
    
    @IBOutlet weak var recordButton: UIImageView!
    @IBOutlet weak var stopButton: UIImageView!
    @IBOutlet weak var playButton: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //enable transport controls as buttons
        self.stopButton.isUserInteractionEnabled = true
        self.playButton.isUserInteractionEnabled = true
        self.recordButton.isUserInteractionEnabled = true
        recorder = try! NodeRecorder(node: DynamicOscillator())
    }
    // Delegate Method
      func sendDataToFirstViewController(myData: Int) {
          self.sound.waveTableIndex = myData
      }
    
    //segue to settings via custom segue
    @IBAction func onSettingsClick(_ sender: Any) {
        self.performSegue(withIdentifier: "synthToSettingsSegue", sender: self)
    }
    
    //prepare for segue, assign objects to pass through modal segue
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
                    self.playButton.image = UIImage(named: "PLAYING")
                    //background thread will run oscillator
                    let dispatchQueue = DispatchQueue(label: "QueueIdentification", qos: .background)
                    dispatchQueue.async{
                        self.sound.noteOn()
                    }
                    //sound.osc.frequency = 440.0
                   // print(sound.osc.frequency)
                }
                
                //stop button pressed
                if touch.view == self.stopButton{
                    sound.noteOff()
                    self.playButton.image = UIImage(named: "PLAY")
                }
                
                //record button pressed
                if touch.view == self.recordButton{
                    print("record pressed")
                    //insert recording logic here
                    if recorder?.isRecording == false {
                        // If a recording isn't active, the button starts the capture session.
                        recorder? = try! NodeRecorder(node: sound.engine.output!)
                        try! recorder?.record()
                        print("Recording started")
                        self.recordButton.image = UIImage(named: "RECORDING")
                    } else {
                        // If a recording is active, the button stops the capture session.
                        recorder?.stop()
                        print("Recording stopped")
                        self.recordButton.image = UIImage(named: "RECORD")
                        saveRecording()
                    }
                    
                }
            }
        }

    func saveRecording(){
        let refreshAlert = UIAlertController(title: "Save Recording", message: "Save this recording?", preferredStyle: UIAlertController.Style.alert)

                refreshAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
                    self.uploadToParse()
                    try! self.recorder?.reset()
                }))

                refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
                    //reset recorder
                    try! self.recorder?.reset()
                }))

                present(refreshAlert, animated: true, completion: nil)
    }
    
    func uploadToParse(){
                    let recording = PFObject(className: "Recording")

                    recording["name"] = SynthViewController.createDateFileName()
                    recording["author"] = PFUser.current()
                    
                    guard let path = recorder?.audioFile?.url else { return;}
                    let data = NSData(contentsOf: path as URL)
                      
        let soundFile = PFFileObject(name: SynthViewController.createDateFileName() + ".caf", data: data! as Data)
                    recording["sound"] = soundFile
                    recording.saveInBackground()
        }
        
        func getCacheDirectory() -> String {
               let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true) as! [String]
               
               return paths[0]
           }
    
    private static func createDateFileName() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH-mm-ss"
        return dateFormatter.string(from: Date())
    }
        
        func getFileURL() -> NSURL {
               let documentDirectory = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)

               //let nestedFolderURL = documentDirectory.appendingPathComponent("Recordings")
               let fileURL = documentDirectory.appendingPathComponent(fileName)
               
               return fileURL as NSURL
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
