//
//  tableView.swift
//  mattscrazyapp
//
//  Created by Matt Smith on 2/19/15.
//  Copyright (c) 2015 Matt Smith. All rights reserved.
//

import UIKit
import Cartography
import AVFoundation
import CoreMotion
import CoreLocation

class TableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var tableView: UITableView?
    let locationManager = CLLocationManager()
    var label: UILabel?
    var audioFileList = NSMutableArray()
    let directoryURL = NSURL(string: "/System/Library/Audio/UISounds")
    var currentSoundSelected: NSIndexPath?
    let sound = Sound()
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.tableView = UITableView(frame: CGRectZero, style: .Grouped)
        self.tableView?.translatesAutoresizingMaskIntoConstraints = false
        self.tableView?.delegate = self
        self.tableView?.dataSource = self
        
        self.view.backgroundColor = UIColor.whiteColor()
        
        let fileManager = NSFileManager.defaultManager()
        let enumerator:NSDirectoryEnumerator = fileManager.enumeratorAtPath("/System/Library/Audio/UISounds")!
        
        while let element = enumerator.nextObject() as? String{
            if element.hasSuffix("caf"){
                audioFileList.addObject(element)
            }
        }
        
        
        
    }
    
    override func viewWillLayoutSubviews() {
        if let tv = self.tableView {
            label = UILabel(frame: CGRectMake(20, 75, 700, 21))
            self.view.addSubview(label!)
            self.view.addSubview(tv)
            constrain(self.view, tv) { view, tableView in
                tableView.width == view.width;
                tableView.top == view.top+100;
                tableView.bottom == view.bottom - 75;
                
                return
            }
            
        }
        
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return audioFileList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = sound.trackList[indexPath.row]
        
        if (self.currentSoundSelected == indexPath.row){
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
        }
        else
        {
            cell.accessoryType = UITableViewCellAccessoryType.None;
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("INDEX PATH - \(indexPath) - \(currentSoundSelected)")
        if (self.currentSoundSelected != nil){
            if let uncheckCell: UITableViewCell = tableView.cellForRowAtIndexPath(self.currentSoundSelected!) {
                print("UNCHECKED SET")
                uncheckCell.accessoryType = UITableViewCellAccessoryType.None
            }
        }
        let cell: UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!
        cell.accessoryType = UITableViewCellAccessoryType.Checkmark
        self.currentSoundSelected = indexPath
        
        if let rowSelected = sound.trackList[indexPath.row] {
            self.label?.text = "Selected Sound:  \(rowSelected)"
        }
        
        self.playSound(indexPath.row)
        print("NEW SELECTED - \(currentSoundSelected)")
    }
    
    func playSound(whatToPlay: Int){
        let fileName: NSURL = directoryURL!.URLByAppendingPathComponent( audioFileList.objectAtIndex(whatToPlay) as! String)
        
        if NSFileManager.defaultManager().fileExistsAtPath("\(fileName)") {
            print("file exists")
        }
        else{
            print("file doesn't exist, closing")
            return
        }
        
        sound.playSpecifiedURL(fileName)
        
        var soundID:SystemSoundID = 0
        AudioServicesCreateSystemSoundID(fileName, &soundID)
        AudioServicesPlaySystemSound(soundID)
    }
    
    
}