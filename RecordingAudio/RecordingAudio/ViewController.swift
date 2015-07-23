//
//  ViewController.swift
//  RecordingAudio
//
//  Created by Humberto Vieira de Castro on 7/14/15.
//  Copyright (c) 2015 Humberto Vieira de Castro. All rights reserved.
//

import UIKit
import AVFoundation
import Parse

class ViewController: UIViewController, AVAudioPlayerDelegate, AVAudioRecorderDelegate {
    @IBOutlet var recordButton: UIButton!
    @IBOutlet var playButton: UIButton!
    @IBOutlet var stopButton: UIButton!
    
    @IBOutlet var percentSended: UILabel!
    @IBOutlet var lblTime: UILabel!
    @IBOutlet var lblSize: UILabel!
    @IBOutlet var lblVolume: UILabel!
    @IBOutlet var sliderVolume: UISlider!
    var audioPlayer: AVAudioPlayer?
    var audioRecorder: AVAudioRecorder?
    var soundFilePath:String = ""
    var timer: NSTimer?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playButton.enabled = false
        stopButton.enabled = false
        
        
        
        let dirPaths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        
        let docsDir = dirPaths[0] as! String
        soundFilePath = docsDir.stringByAppendingPathComponent("/bles.caf")
        
        println(soundFilePath)
        
        let soundFileUrl = NSURL(fileURLWithPath: soundFilePath)
        
        /* EM 10 MB
            - kAudioFormatAppleIMA4 = 214 seg
            -
        */
        
        let recordingSettings =
        [
            AVFormatIDKey: kAudioFormatAppleIMA4,
            AVEncoderAudioQualityKey : AVAudioQuality.Max.rawValue,
            AVEncoderBitRateKey : 128,
            AVNumberOfChannelsKey: 2,
            AVSampleRateKey : 44100.0
        ]
        
        var error: NSError?
        
        let audioSession = AVAudioSession.sharedInstance()
        audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord, error: &error)
        
        if let err = error {
          println("Erro ao gravar carai")
        }
        
        audioRecorder = AVAudioRecorder(URL: soundFileUrl, settings: recordingSettings as [NSObject : AnyObject], error: &error)
        
        
        if let err = error {
            println("Erro ao gravar carai 2")
        }else {
            audioRecorder?.prepareToRecord()
        }
        
        //audioPlayer?.volume = 10.0
    }
    
    @IBAction func recordAudio(sender: AnyObject) {
        if audioRecorder?.recording == false {
            playButton.enabled = false
            stopButton.enabled = true
            audioRecorder!.record()
            timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("atualizaTempo"), userInfo: nil, repeats: true)
        }
        
    }
    @IBAction func stopAudio(sender: AnyObject) {
        stopButton.enabled = false
        playButton.enabled = true
        recordButton.enabled = true
        
        if audioRecorder?.recording == true {
            audioRecorder?.stop()
            timer = NSTimer()
        } else {
            audioPlayer?.stop()
        }
        
    }
    
    func atualizaTempo() {
        let data = NSData(contentsOfFile: soundFilePath)
        
        let size = String(stringInterpolationSegment: Float(data!.length) / 1000000.0  )
        
        let tempo = NSString(format: "%.2f", Float(audioRecorder!.currentTime))
        
        
        lblSize.text = "\((size)) Mb"
        lblTime.text = "\(tempo) seg."
    }

    @IBAction func changeVolume(sender: AnyObject) {
        let valor = sliderVolume.value * 100
        lblVolume.text = "\(sliderVolume.value * 100) "
        // Em média é melhor 40
        audioPlayer?.volume = valor
        
    }
    @IBAction func playAudio(sender: AnyObject) {
        if audioRecorder?.recording == false {
            stopButton.enabled = true
            recordButton.enabled = true
        }
        
        var error: NSError?
        
        audioPlayer = AVAudioPlayer(contentsOfURL: audioRecorder?.url, error: &error)
        audioPlayer?.delegate = self
        
        if let err = error {
            println("Audio Player error")
        }else{
            //audioPlayer?.updateMeters()
            audioPlayer?.play()
        }
        
    }
    
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer!, successfully flag: Bool) {
        recordButton.enabled = true
        stopButton.enabled = false
    }
    
    func audioPlayerDecodeErrorDidOccur(player: AVAudioPlayer!, error: NSError!) {
        println("Ococrreu um erro na decodificação")
    }
    
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        
        println("Acabou carai")
        
        
    }
    
    func audioRecorderEncodeErrorDidOccur(recorder: AVAudioRecorder!, error: NSError!) {
        println("Erro ao encodar o audio")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func saveInDatabase(sender: AnyObject) {
        
        let data = NSData(contentsOfFile: soundFilePath)
        
        let audio = PFFile(name: "sss.caf", contentsAtPath: soundFilePath)
     
        var fileToUpload = PFObject(className: "testeSalvaAudio")
        fileToUpload["texto"] = "Top"
        fileToUpload["audio"] = audio
        
        audio.saveInBackgroundWithProgressBlock({ progress -> Void in
            self.percentSended.text = "\(progress) %"
        
        })
        
        fileToUpload.saveInBackgroundWithBlock({ (success, error) -> Void in
            if success {
                println("Foi !")
            }
            if let err = error {
                println("Erro")
            }
            
        })
        
        
    }


}

