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
        
        while let element = enumerator.nextObject() as? String {
            if sound.trackList[element] != nil {
                debugPrint("Found a match!")
                debugPrint("Filename: \(element)")
                debugPrint("Human name: \(sound.trackList[element])")
                audioFileList.addObject(element)
            }
//            if element.hasSuffix("caf") {
//                audioFileList.addObject(element)
//            }
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
        
        return audioFileList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        /*
            Ryan Auger 6/2/2016
            Added so that the duplication of "circles" would be ignored.
         
            The cells, starting after the first "circles", will be populated by the 
            trackList one above it, basically skipping the second circles.
         
            If another item is added, the value of repeated alert will need to be changed, and a new 
            if statement will need to be added
 
        */
//        var repeated_alert = 8;
//        repeated_alert -= 1;
//        if(indexPath.row > repeated_alert){
//        
//            cell.textLabel?.text = sound.trackList[indexPath.row + 1]
//        } else {
//            cell.textLabel?.text = sound.trackList[indexPath.row]
//        }
//        
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
        print("INDEX PATH - \(indexPath) - \(currentSoundSelected)")

        if let
            currentSoundSelected = self.currentSoundSelected,
            uncheckCell = tableView.cellForRowAtIndexPath(currentSoundSelected)
        {
            print("UNCHECKED SET")
            uncheckCell.accessoryType = .None
        }

        let cell = tableView.cellForRowAtIndexPath(indexPath)
        cell?.accessoryType = .Checkmark
        self.currentSoundSelected = indexPath
        
        if let rowSelected = sound.trackList[self.audioFileList[indexPath.row] as! String] {
            self.navigationItem.title = "Selected Sound: \(rowSelected)"
        }
        
        self.playSound(indexPath.row)
        print("NEW SELECTED - \(currentSoundSelected)")
    }
    
    func playSound(whatToPlay: Int) {
        let fileName: NSURL = directoryURL.URLByAppendingPathComponent(
            audioFileList.objectAtIndex(whatToPlay) as! String
        )
        
        if NSFileManager.defaultManager().fileExistsAtPath("\(fileName)") {
            print("file exists")
        }

        else {
            print("file doesn't exist, closing")
            return
        }
        
        sound.playSpecifiedURL(fileName)
        
        var soundID: SystemSoundID = 0
        AudioServicesCreateSystemSoundID(fileName, &soundID)
        AudioServicesPlaySystemSound(soundID)
    }
    
    
}