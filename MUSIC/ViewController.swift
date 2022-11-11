//
//  ViewController.swift
//  MUSIC
//
//  Created by Ivan Nieto  on 05/11/22.
//

import UIKit
import AVKit
import AVFoundation

class ViewController: UIViewController, AVAudioPlayerDelegate {
    
    @IBOutlet var btnPlay: UIButton!
    @IBOutlet var btnStop: UIButton!
    
    @IBOutlet var sliderDuration: UISlider!
    @IBOutlet var sliderVolume: UISlider!
    
    
    
    private var audioPlayer = AVAudioPlayer()
    private var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadAudio()
    }
    
    
    @IBAction func PlayPress(_ sender: UIButton) {
        audioPlayer.play()
        btnStop.isEnabled = true
        btnPlay.isEnabled = false
    }
    
    @IBAction func StopPress(_ sender: UIButton) {
        audioPlayer.stop()
        btnStop.isEnabled = false
        btnPlay.isEnabled = true
    }
    
    
    private func loadAudio() {
        guard let mp3URL = Bundle.main.url(forResource: "sound", withExtension: "mp3")
        else { return }
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: mp3URL)
            onInit()
        }
        catch {
            print("ocurrio un error,5")
        }
    }
    
    private func onInit() {
        timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(updateDurationSlider), userInfo: nil, repeats: true)
        sliderDuration.value = 0
        sliderDuration.maximumValue = Float(audioPlayer.duration)
        btnStop.isEnabled = false
        btnPlay.isEnabled = true
        audioPlayer.delegate = self
        audioPlayer.volume = 0.5
        sliderVolume.addTarget(self, action: #selector(updateVolumeSlider), for: .valueChanged)
        sliderDuration.addTarget(self, action: #selector(updateSelectedDurationSlider), for: .valueChanged)
    }
    
    @objc private func updateVolumeSlider() {
            audioPlayer.volume = sliderVolume.value
        
    }
    
    @objc private func updateSelectedDurationSlider() {
        audioPlayer.currentTime = TimeInterval(sliderDuration.value)
        audioPlayer.play()
        if !btnStop.isEnabled {
            btnStop.isEnabled = true
            btnPlay.isEnabled = false
        }
    }
    
    @objc private func updateDurationSlider() {
        sliderDuration.value = Float(audioPlayer.currentTime)
        if sliderDuration.value.isZero && btnStop.isEnabled {
            btnPlay.isEnabled = true
            btnStop.isEnabled = false
        }
    }

    
}

