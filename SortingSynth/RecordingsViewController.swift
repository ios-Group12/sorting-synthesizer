//
//  RecordingsViewController.swift
//  SortingSynth
//
//  Created by Emrys Jenkins Taylor on 11/28/22.
//

import UIKit
import Parse
import AVFoundation
import AVKit

public var AudioPlayer = AVPlayer()
public var SelectedRecording = Int()

class RecordingsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, AVAudioPlayerDelegate{
    
    @IBOutlet weak var tableView: UITableView!
    
    
    var recordings = [PFObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let userQuery = PFQuery(className: "Recording")
        userQuery.includeKey("author")
        
        let query = PFQuery(className: "Recording")
        query.includeKeys(["createdAt","name"])
        query.limit = 10
        
        query.findObjectsInBackground{(recordings, error) in
            if recordings != nil {
                self.recordings = recordings!
                self.tableView.reloadData()
            }
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecordingCell", for: indexPath) as! RecordingCell
        
        let recording = recordings[indexPath.row]
        
        cell.nameLabel.text = recording["name"] as? String
        cell.dateLabel.text = recording["createdAt"] as? String
        
        return cell
        // MARK: - Table view data source
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return recordings.count
    }


}
    func grabRecording(){
        let soundQuery = PFQuery(className: "Recording")
        soundQuery.getObjectInBackground(withId:recordings[SelectedRecording!] ,block: { (object : PFObject?, error : Error?) ->  Void in
            if let AudioFileURLTemp : PFFile = object?.value(forKey: "sound") as? PFFile {
                print(AudioFileURLTemp)
                
                
                
                AudioPlayer = AVPlayer(url: NSURL(string: AudioFileURLTemp.url!) as! URL)
                AudioPlayer.play()
            }
            
            func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
                
                SelectedRecording = indexPath.row
                grabRecording()
            }
            
            
            //        let soundFile = recording["sound"] as! PFFileObject
            //        let urlString = soundFile.url!
            //        let url = URL(string: urlString)!
    
