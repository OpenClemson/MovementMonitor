import AVFoundation
import UIKit

class Sound : NSObject {
    weak var app = UIApplication.sharedApplication().delegate as? AppDelegate

    // The player.
    var avPlayer: AVAudioPlayer?
    
    
    /* Note***
        If you need to add an alert, Simply add the file name:Human readable name into the dictionary.
        Ordering doesnt matter(in the dictionary, individual entries must be of the form file:name)
     
     */
    

    
    
    var trackList: [String: String] = ["New/Anticipate.caf": "Anticipate",
                                       "SIMToolkitGeneralBeep.caf": "General Beep",
                                       "lock.caf": "Lock",
                                       "SIMToolkitCallDropped.caf": "Call Dropped",
                                       "SentMessage.caf": "SMS Sent",
                                       "begin_record.caf": "Begin Record",
                                       "New/Spell.caf": "Spell",
                                       "Modern/sms_alert_complete.caf": "SMS Alert - Complete",
                                       "new-mail.caf": "New Mail",
                                       "tweet_sent.caf": "Tweet Sent",
                                       "Modern/sms_alert_keys.caf": "SMS Alert - Keys",
                                       "New/Choo_Choo.caf": "Choo-Choo",
                                       "SIMToolkitPositiveACK.caf": "Positive Beep",
                                       "dtmf-1.caf": "Key Tone 1",
                                       "New/Sherwood_Forest.caf": "Sherwood Forest",
                                       "ct-busy.caf": "Busy Tone",
                                       "payment_success.caf": "Payment Success",
                                       "nano/ringback_tone_cept.caf": "Ringback Tone 1",
                                       "Modern/sms_alert_synth.caf": "SMS Alert - Synth",
                                       "short_double_high.caf": "Short Double High",
                                       "New/Descent.caf": "Descent",
                                       "dtmf-5.caf": "Key Tone 5",
                                       "New/Ladder.caf": "Ladder",
                                       "ReceivedMessage.caf": "Received Message",
                                       "Modern/airdrop_invite.caf": "Airdrop Invite",
                                       "jbl_confirm.caf": "Confirm",
                                       "Modern/sms_alert_bamboo.caf": "SMS Alert - Bamboo",
                                       "New/Tiptoes.caf": "Tiptoes",
                                       "Modern/camera_shutter_burst_end.caf": "Camera Shutter Burst End",
                                       "Modern/sms_alert_aurora.caf": "SMS Alert - Aurora",
                                       "Modern/sms_alert_popcorn.caf": "SMS Alert - Popcorn",
                                       "RingerChanged.caf": "Ringer Changed",
                                       "dtmf-8.caf": "Key Tone 8",
                                       "Modern/camera_shutter_burst.caf": "Camera Shutter Burst",
                                       "jbl_ambiguous.caf": "Ambiguous Beeps",
                                       "New/News_Flash.caf": "News Flash",
                                       "dtmf-3.caf": "Key Tone 3",
                                       "mail-sent.caf": "Mail Sent",
                                       "nano/ringback_tone_hk.caf": "Ringback Tone 2",
                                       "short_double_low.caf": "Short Double Low",
                                       "New/Telegraph.caf": "Telegraph",
                                       "sms-received1.caf": "SMS Received 1",
                                       "sms-received6.caf": "SMS Received 6",
                                       "jbl_cancel.caf": "Cancel",
                                       "alarm.caf": "Alarm",
                                       "ct-congestion.caf": "Congestion",
                                       "shake.caf": "Shake",
                                       "dtmf-2.caf": "Key Tone 2",
                                       "New/Fanfare.caf": "Fanfare",
                                       "low_power.caf": "Low Power",
                                       "middle_9_short_double_low.caf": "Short Double Low",
                                       "Modern/sms_alert_input.caf": "SMS Alert - Input",
                                       "sms-received4.caf": "SMS Received 4",
                                       "ct-error.caf": "Error",
                                       "jbl_no_match.caf": "No Match",
                                       "New/Suspense.caf": "Suspense",
                                       "Tock.caf": "Tock",
                                       "Modern/sms_alert_note.caf": "SMS Alert - Note",
                                       "ct-path-ack.caf": "Path Beep",
                                       "sms-received2.caf": "SMS Received 2",
                                       "Swish.caf": "Swish",
                                       "dtmf-4.caf": "Key Tone 4",
                                       "Modern/calendar_alert_chord.caf": "Calendar Alert",
                                       "end_record.caf": "End Record",
                                       "jbl_begin.caf": "Begin",
                                       "short_low_high.caf": "Short Low High",
                                       "SIMToolkitSMS.caf": "SMS Received",
                                       "long_low_short_high.caf": "Long Low Short High",
                                       "New/Noir.caf": "Noir",
                                       "Modern/camera_shutter_burst_begin.caf": "Camera Shutter Burst Begin",
                                       "dtmf-9.caf": "Key Tone 9",
                                       "New/Minuet.caf": "Minuet",
                                       "dtmf-star.caf": "Key Tone *",
                                       "SIMToolkitNegativeACK.caf": "Negative Beep",
                                       "connect_power.caf": "Connect Power",
                                       "New/Calypso.caf": "Calypso",
                                       "dtmf-pound.caf": "Key Tone #",
                                       "dtmf-6.caf": "Key Tone 6",
                                       "ussd.caf": "USSD",
                                       "photoShutter.caf": "Photo Shutter",
                                       "ct-keytone2.caf": "Keytone 2",
                                       "Tink.caf": "Tink",
                                       "dtmf-7.caf": "Key Tone 7",
                                       "New/Typewriters.caf": "Typewriters",
                                       "sms-received3.caf": "SMS Received 3",
                                       "dtmf-0.caf": "Key Tone 0",
                                       "New/Bloom.caf": "Bloom",
                                       "sms-received5.caf": "SMS Received 5",
                                       "payment_failure.caf": "Payment Failure",
                                       "New/Update.caf": "Update",
                                       "Modern/sms_alert_hello.caf": "SMS Alert - Hello",
                                       "Modern/sms_alert_circles.caf": "SMS Alert - Circles"]

    
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