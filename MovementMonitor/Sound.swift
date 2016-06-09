import AVFoundation
import UIKit

class Sound : NSObject {
    weak var app = UIApplication.sharedApplication().delegate as? AppDelegate

    // The player.
    var avPlayer: AVAudioPlayer?
    
    
    /* Note***
        If you need to add an alert, add the file name and the human readable name to the same row in the respective tables
    */
    
    
    
    var trackFiles = [
        "Modern/airdrop_invite.caf",
        "Modern/calendar_alert_chord.caf",
        "Modern/camera_shutter_burst.caf",
        "Modern/camera_shutter_burst_begin.caf",
        "Modern/camera_shutter_burst_end.caf",
        "Modern/sms_alert_aurora.caf",
        "Modern/sms_alert_bamboo.caf",
        "Modern/sms_alert_circles.caf",
        "Modern/sms_alert_complete.caf",
        "Modern/sms_alert_hello.caf",
        "Modern/sms_alert_input.caf",
        "Modern/sms_alert_keys.caf",
        "Modern/sms_alert_note.caf",
        "Modern/sms_alert_popcorn.caf",
        "Modern/sms_alert_synth.caf",
        "New/Anticipate.caf",
        "New/Bloom.caf",
        "New/Calypso.caf",
        "New/Choo_Choo.caf",
        "New/Descent.caf",
        "New/Fanfare.caf",
        "New/Ladder.caf",
        "New/Minuet.caf",
        "New/News_Flash.caf",
        "New/Noir.caf",
        "New/Sherwood_Forest.caf",
        "New/Spell.caf",
        "New/Suspense.caf",
        "New/Telegraph.caf",
        "New/Tiptoes.caf",
        "New/Typewriters.caf",
        "New/Update.caf",
        "ReceivedMessage.caf",
        "RingerChanged.caf",
        "SIMToolkitCallDropped.caf",
        "SIMToolkitGeneralBeep.caf",
        "SIMToolkitNegativeACK.caf",
        "SIMToolkitPositiveACK.caf",
        "SIMToolkitSMS.caf",
        "SentMessage.caf",
        "Swish.caf",
        "Tink.caf",
        "Tock.caf",
        "alarm.caf",
        "begin_record.caf",
        "ct-busy.caf",
        "connect_power.caf",
        "ct-congestion.caf",
        "ct-error.caf",
        "ct-keytone2.caf",
        "ct-path-ack.caf",
        "dtmf-0.caf",
        "dtmf-1.caf",
        "dtmf-2.caf",
        "dtmf-3.caf",
        "dtmf-4.caf",
        "dtmf-5.caf",
        "dtmf-6.caf",
        "dtmf-7.caf",
        "dtmf-8.caf",
        "dtmf-9.caf",
        "dtmf-pound.caf",
        "dtmf-star.caf",
        "end_record.caf",
        "jbl_ambiguous.caf",
        "jbl_begin.caf",
        "jbl_cancel.caf",
        "jbl_confirm.caf",
        "jbl_no_match.caf",
        "lock.caf",
        "long_low_short_high.caf",
        "low_power.caf",
        "mail-sent.caf",
        "middle_9_short_double_low.caf",
        "new-mail.caf",
        "payment_failure.caf",
        "payment_success.caf",
        "photoShutter.caf",
        "nano/ringback_tone_cept.caf",
        "nano/ringback_tone_hk.caf",
        "shake.caf",
        "short_double_high.caf",
        "short_double_low.caf",
        "short_low_high.caf",
        "sms-received1.caf",
        "sms-received2.caf",
        "sms-received3.caf",
        "sms-received4.caf",
        "sms-received5.caf",
        "sms-received6.caf",
        "tweet_sent.caf",
        "ussd.caf"
        
    ]
    var trackDisplay = [
        "Airdrop Invite",
        "Calendar Alert",
        "Camera Shutter Burst",
        "Camera Shutter Burst Begin",
        "Camera Shutter Burst End",
        "SMS Alert - Aurora",
        "SMS Alert - Bamboo",
        "SMS Alert - Circles",
        "SMS Alert - Complete",
        "SMS Alert - Hello",
        "SMS Alert - Input",
        "SMS Alert - Keys",
        "SMS Alert - Note",
        "SMS Alert - Popcorn",
        "SMS Alert - Synth",
        "Anticipate",
        "Bloom",
        "Calypso",
        "Choo-Choo",
        "Descent",
        "Fanfare",
        "Ladder",
        "Minuet",
        "News Flash",
        "Noir",
        "Sherwood Forest",
        "Spell",
        "Suspense",
        "Telegraph",
        "Tiptoes",
        "Typewriters",
        "Update",
        "Received Message",
        "Ringer Changed",
        "Call Dropped",
        "General Beep",
        "Negative Beep",
        "Positive Beep",
        "SMS Received",
        "SMS Sent",
        "Swish",
        "Tink",
        "Tock",
        "Alarm",
        "Begin Record",
        "Busy Tone",
        "Connect Power",
        "Congestion",
        "Error",
        "Keytone 2",
        "Path Beep",
        "Key Tone 0",
        "Key Tone 1",
        "Key Tone 2",
        "Key Tone 3",
        "Key Tone 4",
        "Key Tone 5",
        "Key Tone 6",
        "Key Tone 7",
        "Key Tone 8",
        "Key Tone 9",
        "Key Tone #",
        "Key Tone *",
        "End Record",
        "Ambiguous Beeps",
        "Begin",
        "Cancel",
        "Confirm",
        "No Match",
        "Lock",
        "Long Low Short High",
        "Low Power",
        "Mail Sent",
        "Short Double Low",
        "New Mail",
        "Payment Failure",
        "Payment Success",
        "Photo Shutter",
        "Ringback Tone 1",
        "Ringback Tone 2",
        "Shake",
        "Short Double High",
        "Short Double Low",
        "Short Low High",
        "SMS Received 1",
        "SMS Received 2",
        "SMS Received 3",
        "SMS Received 4",
        "SMS Received 5",
        "SMS Received 6",
        "Tweet Sent",
        "USSD",
        
    
    ]
    
    //Will combine the two lists. To add a new sound, simply add the filename and human readable name in the 
    //same row of their respective arrays.
    var trackList: [String: String] = [:]
    func maketrackList() {
        for (index, element) in trackFiles.enumerate(){
            trackList[element] = trackDisplay[index]

        }
    }
    func playSpecifiedURL(inURL: NSURL) {
        self.avPlayer = try? AVAudioPlayer(contentsOfURL: inURL)
        
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setActive(true)
            try audioSession.setCategory(AVAudioSessionCategoryPlayback)
        } catch _ {
            // should handle this
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