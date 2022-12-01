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
public var SelectedRecordingNumber = Int()

class RecordingsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, AVAudioPlayerDelegate{

    @IBOutlet weak var tableView: UITableView!

    var refreshControl: UIRefreshControl!
    var recordings = [PFObject]()
    var numberOfRecordings: Int!
    var iDArray = [String]()
    var NameArray = [String]()



    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.rowHeight = 55.0

        tableView.dataSource = self
        tableView.delegate = self

        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(onRefresh), for: .valueChanged)
        tableView.insertSubview(refreshControl, at: 0)

    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        numberOfRecordings = 10
        let userQuery = PFQuery(className: "Recording")
        userQuery.includeKey("author")

        let query = PFQuery(className: "Recording")
        query.includeKeys(["objectId", "createdAt", "name"])
        query.limit = numberOfRecordings

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
                    self.NameArray.append(object.value(forKey: "name") as! String)
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

        return cell
    }


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return recordings.count
        // return iDArray.count
    }


    func grabRecording(){
        let soundQuery = PFQuery(className: "Recording")
        soundQuery.getObjectInBackground(withId:iDArray[SelectedRecordingNumber], block: { (object : PFObject?, error : Error?) ->  Void in
            if let AudioFile : PFFileObject = object?.object(forKey: "sound") as? PFFileObject {

                let AudioFileURLTemp = AudioFile.url!
                print("URL" + AudioFileURLTemp)


                AudioPlayer = AVPlayer(url: NSURL(string: AudioFileURLTemp)! as URL)
            }
        })
    }


    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        SelectedRecordingNumber = indexPath.row
        grabRecording()
    }

    // Implement the delay method
    func run(after wait: TimeInterval, closure: @escaping () -> Void) {
        let queue = DispatchQueue.main
        queue.asyncAfter(deadline: DispatchTime.now() + wait, execute: closure)
    }

    @objc func onRefresh() {
        // Call the delay method in your onRefresh() method
        func refresh(){}
        let time = 2.0
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + time) {
               self.refreshControl.endRefreshing()
            }
    }

    func loadMoreRecordings(){
        let query = PFQuery(className: "Recording")
        query.includeKeys(["createdAt","name"])
        numberOfRecordings = numberOfRecordings + 5
        query.limit = numberOfRecordings

        query.findObjectsInBackground{(recordings, error) in
            if recordings != nil {
                self.recordings = recordings!
                self.tableView.reloadData()
            }
        }
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath){
        if indexPath.row + 1 == recordings.count {
            loadMoreRecordings()
        }
    }


}
