//
//  SynthViewController.swift
//  SortingSynth
//
//  Created by Emrys Jenkins Taylor on 11/11/22.
//

import UIKit
import Parse

class SynthViewController: UIViewController {

    var fileName = "StarWars60.wav"

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func getCacheDirectory() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true) as! [String]
        
        return paths[0]
    }
    
    func getFileURL() -> NSURL {
        let documentDirectory = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)

        //let nestedFolderURL = documentDirectory.appendingPathComponent("Recordings")

        let fileURL = documentDirectory.appendingPathComponent(fileName)
        
        return fileURL as NSURL
    }
    
    @IBAction func recordButton(_ sender: Any) {
        

        let recording = PFObject(className: "Recording")

        recording["name"] = "recording"
        recording["author"] = PFUser.current()
        
        let path = getFileURL()
        let data = NSData(contentsOf: path as URL)
          
        let soundFile = PFFileObject(name: "recording.wav", data: data as! Data)

        recording["sound"] = soundFile
        recording.saveInBackground()
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
