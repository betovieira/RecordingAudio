//
//  ViewController.swift
//  RecordingAudio
//
//  Created by Humberto Vieira de Castro on 7/14/15.
//  Copyright (c) 2015 Humberto Vieira de Castro. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, AVAudioPlayerDelegate, AVAudioRecorderDelegate {
    @IBOutlet var recordButton: UIButton!
    @IBOutlet var playButton: UIButton!
    @IBOutlet var stopButton: UIButton!
    
    @IBOutlet var lblVolume: UILabel!
    @IBOutlet var sliderVolume: UISlider!
    var audioPlayer: AVAudioPlayer?
    var audioRecorder: AVAudioRecorder?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playButton.enabled = false
        stopButton.enabled = false
        
        let dirPaths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        
        let docsDir = dirPaths[0] as! String
        let soundFilePath = docsDir.stringByAppendingPathComponent("sound.caf")
        let soundFileUrl = NSURL(fileURLWithPath: soundFilePath)
        
        
        let recordingSettings =
        [
            AVFormatIDKey: kAudioFormatAppleLossless,
            AVEncoderAudioQualityKey : AVAudioQuality.High.rawValue,
            AVEncoderBitRateKey : 320000,
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
        }
        
    }
    @IBAction func stopAudio(sender: AnyObject) {
        stopButton.enabled = false
        playButton.enabled = true
        recordButton.enabled = true
        
        if audioRecorder?.recording == true {
            audioRecorder?.stop()
        } else {
            audioPlayer?.stop()
        }
        
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
        
    }
    
    func audioRecorderEncodeErrorDidOccur(recorder: AVAudioRecorder!, error: NSError!) {
        println("Erro ao encodar o audio")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

