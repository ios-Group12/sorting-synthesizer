//
//  Oscillator.swift
//  SortingSynth
//
//  Created by Lisa Mylett on 11/18/22.
//

import Foundation
import AudioKit //contains audio components
import SoundpipeAudioKit //contains a useful dynamic oscillator

//this class defines and modifies oscillators for sound generation
//to create a sound, the signal chain goes:
//WaveTable (sound form) into Oscillator (selected by user)
//Oscillator into Envelope (to be developed to alter timbre)
//Enveloped Oscillator into Audio Engine output
class OscillatorConductor: ObservableObject, HasAudioEngine {
    let engine = AudioEngine()
   @Published var osc = DynamicOscillator()
    @Published var waveTableIndex: Int = 0
    
    //is the synth playing?
    @Published var isPlaying: Bool = true {
        didSet { isPlaying ? osc.start() : osc.stop() }
    }
    
    func cycleOscillator(){
        print("oscillator changed")
        if (waveTableIndex > 2){
            waveTableIndex = 0
        } else {
            waveTableIndex += 1
        }
        print(waveTableIndex)
        SetWaveTable()
    }
    
    func SetWaveTable(){
        switch waveTableIndex{
        case 0:
            osc.setWaveform(Table(.sine))
        case 1:
            osc.setWaveform(Table(.triangle))
        case 2:
            osc.setWaveform(Table(.sawtooth))
        case 3:
            osc.setWaveform(Table(.square))
        default:
            osc.setWaveform(Table(.sine))
        }
    }
    
    //class initializer inserting oscillator into engine and starting engine
    init() {
        engine.output = osc
        do {
            try engine.start()
        } catch {
            assert(false, "The audio engine cannot start!")
        }
    }
    
    //starts playing the synth
    //currently set to hardcoded values, this will become dynamic
    func noteOn() {
        isPlaying = true
        osc.amplitude = 0.2 //size of the waveform in relation to the audio room
        osc.frequency = 220.0 //number of cycles per sec (Hz)
        SetWaveTable()
        
    }
    
    //stop the synth
    func noteOff() {
        isPlaying = false
    }
    
}



