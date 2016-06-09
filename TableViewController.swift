import UIKit
import Cartography
import AVFoundation
import CoreMotion
import CoreLocation

class TableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var tableView: UITableView?
    let locationManager = CLLocationManager()
    var audioFileList = NSMutableArray()
    let directoryURL = NSURL(string: "/System/Library/Audio/UISounds")!
    var currentSoundSelected: NSIndexPath?
    let sound = Sound()
    weak var app = UIApplication.sharedApplication().delegate as? AppDelegate
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView = UITableView(frame: CGRectZero, style: .Grouped)
        self.tableView?.translatesAutoresizingMaskIntoConstraints = false
        self.tableView?.delegate = self
        self.tableView?.dataSource = self
        
        self.view.backgroundColor = UIColor.whiteColor()
        
        let fileManager = NSFileManager.defaultManager()
        guard let enumerator = fileManager.enumeratorAtPath("/System/Library/Audio/UISounds") else {
            app?.cannotFindSystemSoundErrorAlert()
            return
        }
        sound.maketrackList()   //Will combine the list of files and human readable names
        

        while let element = enumerator.nextObject() as? String {
            if ((sound.trackList[element]?.hasSuffix("caf")) != nil) {
//                debugPrint("Found a match!")
//                debugPrint("Filename: \(element)")
//                debugPrint("Human name: \(sound.trackList[element])")
                audioFileList.addObject(element)
           }
////            if element.hasSuffix("caf") {
////                audioFileList.addObject(element)
////            }
        }
   }
    
    override func viewWillLayoutSubviews() {
        if let tv = self.tableView {
            view.addSubview(tv)

            constrain(view, tv) { view, tableView in
                tableView.edges == view.edges
            }
        }
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sound.trackList.count
        //return audioFileList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        
        //Give the cells Labels according to the newly combined trackList
        cell.textLabel?.text = sound.trackList[self.audioFileList[indexPath.row] as! String]
        
        
        if self.currentSoundSelected == indexPath.row {
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
        }
        else {
            cell.accessoryType = UITableViewCellAccessoryType.None;
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
       // print("INDEX PATH - \(indexPath) - \(currentSoundSelected)")

        if let
            currentSoundSelected = self.currentSoundSelected,
            uncheckCell = tableView.cellForRowAtIndexPath(currentSoundSelected)
        {
           // print("UNCHECKED SET")
            uncheckCell.accessoryType = .None
        }

        let cell = tableView.cellForRowAtIndexPath(indexPath)
        cell?.accessoryType = .Checkmark
        self.currentSoundSelected = indexPath
        
        if let rowSelected = sound.trackList[self.audioFileList[indexPath.row] as! String] {
            self.navigationItem.title = "Selected Sound: \(rowSelected)"
        }
        
        self.playSound(indexPath.row)
        //print("NEW SELECTED - \(currentSoundSelected)")
    }
    
    func playSound(whatToPlay: Int) {
        let fileName: NSURL = directoryURL.URLByAppendingPathComponent(
            audioFileList.objectAtIndex(whatToPlay) as! String
        )
        
        if NSFileManager.defaultManager().fileExistsAtPath("\(fileName)") {
           // print("file exists")
        }

        else {
            //print("file doesn't exist, closing")
            return
        }
        
        sound.playSpecifiedURL(fileName)
        
        var soundID: SystemSoundID = 0
        AudioServicesCreateSystemSoundID(fileName, &soundID)
        AudioServicesPlaySystemSound(soundID)
    }
    
    
}