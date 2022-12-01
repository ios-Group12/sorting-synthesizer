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
    
    var recordings = [PFObject]()
    var iDArray = [String]()
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func share(_ sender: UIButton) {
        let soundQuery = PFQuery(className: "Recording")
        soundQuery.getObjectInBackground(withId:iDArray[sender.tag], block: { (object : PFObject?, error : Error?) ->  Void in
            if let AudioFile : PFFileObject = object?.object(forKey: "sound") as? PFFileObject {
                
                let audioFileURL = AudioFile.url!
                let url = URL(string: audioFileURL)
                let documentsUrl: URL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                let tempFileUrl = documentsUrl.appendingPathComponent("recording.caf")
                
                let sessionConfig = URLSessionConfiguration.default
                let session = URLSession(configuration: sessionConfig)
                let request = URLRequest(url: url!)
                
                // Delete temporary file if for some reason it wasn't removed before
                do {
                    try FileManager.default.removeItem(at: tempFileUrl)
                    print("Temporary file has been deleted")
                } catch {
                    print(error)
                }
                
                let task = session.downloadTask(with: request) { (tempLocalUrl, response, error) in
                    if let tempLocalUrl = tempLocalUrl, error == nil {
                        // Success
                        if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                            print("Successfully downloaded. Status code: \(statusCode)")
                        }
                        // Download file
                        do {
                            try FileManager.default.copyItem(at: tempLocalUrl, to: tempFileUrl)
                        } catch (let writeError) {
                            print("Error creating a file \(tempFileUrl) : \(writeError)")
                        }
                    } else {
                        print("Error took place while downloading a file. Error description: %@", error?.localizedDescription as Any);
                    }
                }
                
                task.resume()
                // Display share sheet
                let objectsToShare = [tempFileUrl]
                let activityController = UIActivityViewController(activityItems: objectsToShare as [Any], applicationActivities: nil)
                let excludedActivities = [UIActivity.ActivityType.postToFlickr, UIActivity.ActivityType.postToWeibo, UIActivity.ActivityType.print, UIActivity.ActivityType.copyToPasteboard, UIActivity.ActivityType.assignToContact, UIActivity.ActivityType.saveToCameraRoll, UIActivity.ActivityType.addToReadingList, UIActivity.ActivityType.postToFlickr, UIActivity.ActivityType.postToVimeo, UIActivity.ActivityType.postToTencentWeibo]
                
                activityController.excludedActivityTypes = excludedActivities
                
                self.present(activityController, animated: true, completion: nil)
                // Action performed on Share Sheet dismissal
                activityController.completionWithItemsHandler = { (activityType: UIActivity.ActivityType?, completed:
                Bool, arrayReturnedItems: [Any]?, error: Error?) in
                    if completed {
                        do {
                            try FileManager.default.removeItem(at: tempFileUrl)
                            print("Temporary file has been deleted")
                        } catch {
                            print(error)
                        }
                        return
                    } else {
                        do {
                            try FileManager.default.removeItem(at: tempFileUrl)
                            print("Temporary File has been deleted")
                        } catch {
                            print(error)
                        }
                    }
                    if let shareError = error {
                        print("error while sharing: \(shareError.localizedDescription)")
                    }
                }
            }
            
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.rowHeight = 55.0

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
        
        let objectIdQuery = PFQuery(className: "Recording")
        objectIdQuery.findObjectsInBackground { (objects: [PFObject]?, error: Error?) in
            if let error = error {
                // Log details of the failure
                print(error.localizedDescription)
            } else if let objects = objects {
                // The find succeeded.
                print("Successfully retrieved \(objects.count) scores.")
                // Do something with the found objects
                for object in objects {
                    self.iDArray.append(object.value(forKey: "objectId") as! String)
                    self.tableView.reloadData()
                }
                print(self.iDArray)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecordingCell", for: indexPath) as! RecordingCell
        
        let recording = recordings[indexPath.row]
        
        
        cell.nameLabel.text = recording["name"] as? String
//        cell.dateLabel.text = recording["createdAt"] as? String
        cell.shareButton.tag = indexPath.row
        
        return cell
        // MARK: - Table view data source
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return recordings.count
    }

    func grabRecording(){
        let soundQuery = PFQuery(className: "Recording")
        soundQuery.getObjectInBackground(withId:iDArray[SelectedRecording], block: { (object : PFObject?, error : Error?) ->  Void in
            if let AudioFile : PFFileObject = object?.object(forKey: "sound") as? PFFileObject {
                
                let AudioFileURLTemp = AudioFile.url!
                print("URL" + AudioFileURLTemp)
                
                
                AudioPlayer = AVPlayer(url: NSURL(string: AudioFileURLTemp)! as URL)
                AudioPlayer.play()
            }
        })
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        SelectedRecording = indexPath.row
        print(SelectedRecording)
        grabRecording()
    }
    
}
