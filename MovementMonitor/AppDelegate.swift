import UIKit
import CoreMotion
import AVFoundation
import Foundation
import SVProgressHUD

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var navigationController: UINavigationController!
    var vc: TableViewController!

    let sound = Sound()
    let motionManager = CMMotionManager()
    let queue = NSOperationQueue.mainQueue
    let gyroUpdateInter: NSTimeInterval = 0.1
    let accUpdateInter: NSTimeInterval = 0.1
    var avgOverSamples = MovementComps(
        acc: XyzComps(x: 0.0, y: 0.0, z: 0.0),
        gyro: XyzComps(x: 0.0, y: 0.0, z: 0.0)
    )
    var accCount = 0.0
    var gyroCount = 0.0
    let divConstant = 100.0
    let CHECK_TIME: NSTimeInterval = 1.0
    var calibratedResults = MovementComps(
        acc: XyzComps(x: 0.0, y: 0.0, z: 0.0),
        gyro: XyzComps(x: 0.0, y: 0.0, z: 0.0)
    )
    var calFlag: (Bool, Bool, Bool) = (false, false, false) // ACC, GYRO, FINISHED CAL
    var movementFlag: Bool = false
    let progress = SVProgressHUD()
    
    enum Movement {
        case Accelerometer(CMAccelerometerData)
        case Gyroscope(CMGyroData)
    }
    
    struct XyzComps {
        var x, y, z: Double
    }
    
    struct MovementComps {
        var acc, gyro: XyzComps
    }

    func application(
        application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?
    ) -> Bool {
        window = UIWindow()
        window?.frame = UIScreen.mainScreen().bounds
        vc = TableViewController()
        navigationController = UINavigationController(rootViewController: vc)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()

        becomeFirstResponder()

        if motionManager.accelerometerAvailable && motionManager.gyroAvailable {
            motionManager.accelerometerUpdateInterval = self.accUpdateInter
            motionManager.gyroUpdateInterval = self.gyroUpdateInter
        }
        
        // MARK: MOVEMENT
        
        motionManager.startAccelerometerUpdates()
        motionManager.startGyroUpdates()
        
        if motionManager.accelerometerAvailable {
            motionManager.accelerometerUpdateInterval = accUpdateInter
            motionManager.startAccelerometerUpdatesToQueue(NSOperationQueue.mainQueue()) {
                [unowned self] (data, error) in
                    guard let data = data else {
                        return
                    }

                    if self.calFlag.0 {
                        self.updateAverage(Movement.Accelerometer(data))
                    }

                    if self.calFlag.2 {
                        let dataNew = self.toPercent(Movement.Accelerometer(data))
                        if (
                            dataNew.0 > 50 ||
                            dataNew.0 < -50 ||
                            dataNew.0 > 50 ||
                            dataNew.1 > 50 ||
                            dataNew.1 < -50 ||
                            dataNew.1 < -50
                        ) {
                            self.movementFlag = true
                        }
                    }
            }
        }
        
        if motionManager.gyroAvailable {
            motionManager.gyroUpdateInterval = gyroUpdateInter
            motionManager.startGyroUpdatesToQueue(NSOperationQueue.mainQueue()) {
                [unowned self] (data, error) in
                    guard let data = data else {
                        return
                    }

                    if self.calFlag.1 {
                        self.updateAverage(Movement.Gyroscope(data))
                    }

                    if self.calFlag.2 {
                        if (
                            data.rotationRate.x > 0.1 ||
                            data.rotationRate.x < -0.1 ||
                            data.rotationRate.y > 0.1 ||
                            data.rotationRate.y > 0.1 ||
                            data.rotationRate.z < -0.1 ||
                            data.rotationRate.z < -0.1
                        ) {
                            self.movementFlag = true
                            print(self.movementFlag)
                        }
                    }
            }
        }
        
        // MARK: ALERT
        
        let alertController = UIAlertController(
            title: "Stationary Calibration",
            message: "Please put the device in the position it will be at rest. If the device is on a stand, leave it in the vertical position.",
            preferredStyle: .Alert
        )
        
        let defAction = UIAlertAction(
            title: "Calibrate",
            style: .Default
        ) { (action) in
            SVProgressHUD.showWithStatus("Calibrating...", maskType: .Black)
            self.calFlag.0 = true
            self.calFlag.1 = true
            print("-- Calibrating...")
        }
        
        alertController.addAction(defAction)
        
        navigationController.presentViewController(alertController, animated: true, completion: nil)
        vc.navigationItem.title = "Select a Sound"
        
        return true
    }
    
    
    func calibrated() {
        print("-- Calibrated.  Results:  ----------")
        print("CAL RESULTS: \(self.calibratedResults)")
        
        self.calFlag.2 = true
        
        SVProgressHUD.showSuccessWithStatus("Ready!", maskType: .Black)
        
        print("\nStarting movement timer...")
        
        let timer = NSTimer(
            timeInterval: CHECK_TIME,
            target: self,
            selector: #selector(AppDelegate.checkForMovement),
            userInfo: nil,
            repeats: true
        )
        NSRunLoop.currentRunLoop().addTimer(timer, forMode: NSRunLoopCommonModes)
        
    }
    
    func toPercent (dataIn: Movement) -> (Double, Double, Double) {
        switch dataIn {
        case .Accelerometer(let acc):
            return (
                (acc.acceleration.x - self.calibratedResults.acc.x) / self.calibratedResults.acc.x,
                (acc.acceleration.y - self.calibratedResults.acc.y) / self.calibratedResults.acc.y,
                (acc.acceleration.z - self.calibratedResults.acc.z) / self.calibratedResults.acc.z
            )
        case .Gyroscope(let gyro):
            return (
                (gyro.rotationRate.x - self.calibratedResults.gyro.x) / self.calibratedResults.gyro.x * 100,
                (gyro.rotationRate.x - self.calibratedResults.gyro.y) / self.calibratedResults.gyro.y * 100,
                (gyro.rotationRate.x - self.calibratedResults.gyro.z) / self.calibratedResults.gyro.z * 100
            )
        }
    }
    
    func checkForMovement() {
        if let rowToPlay = self.vc.currentSoundSelected?.row where self.movementFlag {
            self.vc.playSound(rowToPlay)
        }
        
        self.movementFlag = false
    }
    
    func updateAverage(data: Movement) {
        switch data {
        case .Accelerometer(let acc):
            self.avgOverSamples.acc.x += acc.acceleration.x
            self.avgOverSamples.acc.y  += acc.acceleration.y
            self.avgOverSamples.acc.z += acc.acceleration.z
            
            accCount += 1
            
        case .Gyroscope(let gyro):
            self.avgOverSamples.gyro.x += gyro.rotationRate.x
            self.avgOverSamples.gyro.y += gyro.rotationRate.y
            self.avgOverSamples.gyro.z += gyro.rotationRate.z
            
            gyroCount += 1
        }
        
        if (accCount == divConstant) {
            self.avgOverSamples.acc.x = self.avgOverSamples.acc.x / divConstant
            self.avgOverSamples.acc.y = self.avgOverSamples.acc.y / divConstant
            self.avgOverSamples.acc.z = self.avgOverSamples.acc.z / divConstant
            print("ACC AVG DATA: \(self.avgOverSamples.acc)")
            
            accCount = 0
            self.calFlag.0 = false
        }
        
        if (gyroCount == divConstant) {
            self.avgOverSamples.gyro.x = self.avgOverSamples.gyro.x / divConstant
            self.avgOverSamples.gyro.y = self.avgOverSamples.gyro.y / divConstant
            self.avgOverSamples.gyro.z = self.avgOverSamples.gyro.z / divConstant
            print("GYRO AVG DATA: \(self.avgOverSamples.gyro)")
            
            gyroCount = 0
            self.calFlag.1 = false
        }
        
        if (!self.calFlag.0 && !self.calFlag.1) {
            self.calibratedResults.acc = self.avgOverSamples.acc
            self.calibratedResults.gyro = self.avgOverSamples.gyro
            
            self.avgOverSamples.acc.x = 0.0
            self.avgOverSamples.acc.y = 0.0
            self.avgOverSamples.acc.z = 0.0
            
            self.avgOverSamples.gyro.x = 0.0
            self.avgOverSamples.gyro.y = 0.0
            self.avgOverSamples.gyro.z = 0.0
            
            self.calibrated()
        }
    }
    
    func cannotMakeSoundErrorAlert() {
        let alertController = UIAlertController(
            title: "Cannot Create Audio Session",
            message: "This app encountered an error and needs to be restarted.",
            preferredStyle: .Alert
        )
        
        navigationController.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func cannotFindSystemSoundErrorAlert() {
        let alertController = UIAlertController(
            title: "Cannot Find System Sounds",
            message: "This app encountered an error and needs to be restarted.",
            preferredStyle: .Alert
        )
        
        navigationController.presentViewController(alertController, animated: true, completion: nil)
    }
    
}

