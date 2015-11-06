import UIKit
import Cartography
import AVFoundation
import CoreMotion
import CoreLocation

class TableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var tableView: UITableView?
    let locationManager = CLLocationManager()
    var label: UILabel!
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
            if element.hasSuffix("caf") {
                audioFileList.addObject(element)
            }
        }
    }
    
    override func viewWillLayoutSubviews() {
        if let tv = self.tableView {
            label = UILabel(frame: CGRectMake(20, 75, 700, 21))
            self.view.addSubview(label)
            self.view.addSubview(tv)

            constrain(self.view, tv) { view, tableView in
                tableView.width == view.width;
                tableView.top == view.top + 100;
                tableView.bottom == view.bottom - 75;
            }
        }
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return audioFileList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = sound.trackList[indexPath.row]
        
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
        
        if let rowSelected = sound.trackList[indexPath.row] {
            self.label?.text = "Selected Sound: \(rowSelected)"
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