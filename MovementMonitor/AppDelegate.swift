import UIKit
import CoreMotion
import CoreLocation
import AVFoundation
import Foundation
import SVProgressHUD

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate {
    var window: UIWindow?
    let sound = Sound()
    let motionManager = CMMotionManager()
    let locationManager = CLLocationManager()
    let queue = NSOperationQueue.mainQueue
    var vc = TableViewController()
    let gyroUpdateInter: NSTimeInterval = 0.1
    let accUpdateInter: NSTimeInterval = 0.1
    var accAverageOverSamples: (Double, Double, Double) = (0.0, 0.0, 0.0)
    var gyroAverageOverSamples: (Double, Double, Double) = (0.0, 0.0, 0.0)
    var accCount = 0.0
    var gyroCount = 0.0
    let divConstant = 100.0
    let CHECK_TIME: NSTimeInterval = 1.0
    var calibratedResults: ( (Double, Double, Double), (Double, Double, Double) ) = ( (0,0,0), (0,0,0) ) // ACC, GYRO
    var calFlag: (Bool, Bool, Bool) = (false, false, false) // ACC, GYRO, FINISHED CAL
    var movementFlag: Bool = false
    let progress = SVProgressHUD()
    
    enum Movement {
        case Accelerometer(CMAccelerometerData)
        case Gyroscope(CMGyroData)
    }

    // TODO: Use instead of tuple?
    struct AccelerometerData {
        let x, y, z: Double
    }

    func application(
        application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?
    ) -> Bool {
        self.window = UIWindow()
        self.window?.frame = UIScreen.mainScreen().bounds
        self.window?.rootViewController = vc
        self.window?.makeKeyAndVisible()

        self.becomeFirstResponder()
//        UIApplication.sharedApplication().beginReceivingRemoteControlEvents()

        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()

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
        
        self.vc.presentViewController(alertController, animated: true, completion: nil)
        
        return true
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        switch status {
        case .AuthorizedAlways:
            print("location started")
            locationManager.startUpdatingLocation()
        default:
            // TODO: alert
            print("Error: need location as always")
        }
    }
    
    func calibrated(){
        print("-- Calibrated.  Results:  ----------")
        print("CAL RESULTS: \(self.calibratedResults)")
        
        self.calFlag.2 = true
        
        SVProgressHUD.showSuccessWithStatus("Ready!", maskType: .Black)
        
        print("\nStarting movement timer...")
        
        let timer = NSTimer(
            timeInterval: CHECK_TIME,
            target: self,
            selector: "checkForMovement",
            userInfo: nil,
            repeats: true
        )
        NSRunLoop.currentRunLoop().addTimer(timer, forMode: NSRunLoopCommonModes)
        
    }
    
    func toPercent (dataIn: Movement) -> (Double, Double, Double) {
        switch dataIn {
        case .Accelerometer(let acc):
            (acc.acceleration.x - self.calibratedResults.0.0) / self.calibratedResults.0.0
            return (
                (acc.acceleration.x - self.calibratedResults.0.0) / self.calibratedResults.0.0,
                (acc.acceleration.y - self.calibratedResults.0.1) / self.calibratedResults.0.1,
                (acc.acceleration.z - self.calibratedResults.0.2) / self.calibratedResults.0.2
            )
        case .Gyroscope(let gyro):
            return(
                (gyro.rotationRate.x - self.calibratedResults.1.0) / self.calibratedResults.1.0 * 100,
                (gyro.rotationRate.x - self.calibratedResults.1.1) / self.calibratedResults.1.1 * 100,
                (gyro.rotationRate.x - self.calibratedResults.1.2) / self.calibratedResults.1.2 * 100
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
            self.accAverageOverSamples.0 += acc.acceleration.x
            self.accAverageOverSamples.1 += acc.acceleration.y
            self.accAverageOverSamples.2 += acc.acceleration.z
            
            ++accCount
            
        case .Gyroscope(let gyro):
            self.gyroAverageOverSamples.0 += gyro.rotationRate.x
            self.gyroAverageOverSamples.1 += gyro.rotationRate.y
            self.gyroAverageOverSamples.2 += gyro.rotationRate.z
            
            ++gyroCount
        }
        
        if (accCount == divConstant) {
            self.accAverageOverSamples.0 = self.accAverageOverSamples.0 / divConstant
            self.accAverageOverSamples.1 = self.accAverageOverSamples.1 / divConstant
            self.accAverageOverSamples.2 = self.accAverageOverSamples.2 / divConstant
            print("ACC AVG DATA: \(self.accAverageOverSamples)")
            
            accCount = 0
            self.calFlag.0 = false
        }
        
        if (gyroCount == divConstant) {
            self.gyroAverageOverSamples.0 = self.gyroAverageOverSamples.0 / divConstant
            self.gyroAverageOverSamples.1 = self.gyroAverageOverSamples.1 / divConstant
            self.gyroAverageOverSamples.2 = self.gyroAverageOverSamples.2 / divConstant
            print("GYRO AVG DATA: \(self.gyroAverageOverSamples)")
            
            gyroCount = 0
            self.calFlag.1 = false
        }
        
        if (!self.calFlag.0 && !self.calFlag.1) {
            self.calibratedResults.0 = self.accAverageOverSamples
            self.calibratedResults.1 = self.gyroAverageOverSamples
            
            self.accAverageOverSamples.0 = 0.0
            self.accAverageOverSamples.1 = 0.0
            self.accAverageOverSamples.2 = 0.0
            
            self.gyroAverageOverSamples.0 = 0.0
            self.gyroAverageOverSamples.1 = 0.0
            self.gyroAverageOverSamples.2 = 0.0
            
            self.calibrated()
        }
    }
    
    
    func locationManager(motionManager: CLLocationManager, didFailWithError error: NSError) {
        print("Error:" + error.localizedDescription)
    }
}

