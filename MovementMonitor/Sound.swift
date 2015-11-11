import AVFoundation
import UIKit

class Sound : NSObject {
    weak var app = UIApplication.sharedApplication().delegate as? AppDelegate

    // The player.
    var avPlayer: AVAudioPlayer?
    
    var trackList = [
        0: "Airdrop Invite",
        1: "Calendar Alert Chord",
        2: "Camera Shutter Burst",
        3: "Camera Shutter Burst Begin",
        4: "Camera Shutter Burst End",
        5: "SMS Alert - Aurora",
        6: "SMS Alert - Bamboo",
        7: "SMS Alert - Circles",
        8: "SMS Alert - Circles",
        9: "SMS Alert - Complete",
        10: "SMS Alert - Hello",
        11: "SMS Alert - Input",
        12: "SMS Alert - Keys",
        13: "SMS Alert - Note",
        14: "SMS Alert - Popcorn",
        15: "SMS Alert - Synth",
        16: "Anticipate",
        17: "Bloom",
        18: "Calypso",
        19: "Choo-Choo",
        20: "Descent",
        21: "Fanfare",
        22: "Ladder",
        23: "Minuet",
        24: "News Flash",
        25: "Noir",
        26: "Sherwood Forest",
        27: "Spell",
        28: "Suspense",
        29: "Telegraph",
        30: "Tiptoes",
        31: "Typewriters",
        32: "Update",
        33: "Received Message",
        34: "Ringer Changed",
        35: "Call Dropped",
        36: "General Beep",
        37: "Negative Beep",
        38: "Positive Beep",
        39: "SMS Received",
        40: "SMS Sent",
        41: "Swish",
        42: "Tink",
        43: "Tock",
        44: "Alarm",
        45: "Begin Record",
        46: "Busy Tone 1",
        47: "Busy Tone 2",
        48: "Call Waiting 1",
        49: "Call Waiting 2",
        50: "Conect Power",
        51: "Busy",
        52: "Call Waiting",
        53: "Congestion",
        54: "Error",
        55: "Keytone 2",
        56: "Path Beep",
        57: "Path Beep",
        58: "Key Tone 1",
        59: "Key Tone 2",
        60: "Key Tone 3",
        61: "Key Tone 4",
        62: "Key Tone 5",
        63: "Key Tone 6",
        64: "Key Tone 7",
        65: "Key Tone 8",
        66: "Key Tone 9",
        67: "Key Tone #",
        68: "Key Tone *",
        69: "End Call",
        70: "End Record",
        71: "Ambiguous Beeps",
        72: "Being",
        73: "Cancel",
        74: "Confirm",
        75: "No Match",
        76: "Lock",
        77: "Long Low Short High",
        78: "Low Power",
        79: "Mail Sent",
        80: "Short Double Low",
        81: "New Mail",
        82: "Payment Failure",
        83: "Payment Success",
        84: "Photo Shutter",
        85: "Ringback Tone 1",
        86: "Ringback Tone 2",
        87: "Shake",
        88: "Short Double High",
        89: "Short Double Low",
        90: "Short Low High",
        91: "SMS Received 1",
        92: "SMS Received 2",
        93: "SMS Received 3",
        94: "SMS Received 4",
        95: "SMS Received 5",
        96: "SMS Received 6",
        97: "Tweet Sent",
        98: "USSD",
        99: "VC - End",
        100: "VC - Invitation Accepted",
        101: "VC - Ringing"
    ]

    func playSpecifiedURL(inURL: NSURL) {
        self.avPlayer = try? AVAudioPlayer(contentsOfURL: inURL)

        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setActive(true)
            try audioSession.setCategory(AVAudioSessionCategoryPlayback)
        } catch let _ as NSError {
//            print("OH SNAP")
//            print(error)

        }

        self.avPlayer?.volume = 1.0
        self.avPlayer?.prepareToPlay()
        self.avPlayer?.play()
    }
    
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer, successfully flag: Bool) {
        print("finished playing \(flag)")
    }
}

extension Sound : AVAudioPlayerDelegate {
    func audioPlayerDecodeErrorDidOccur(player: AVAudioPlayer, error: NSError?) {
        print("\(error?.localizedDescription)")
    }
}