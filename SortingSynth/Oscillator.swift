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
    @Published var sortIndex: Int = 0

    
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
    
    func cycleSort(){
        if (sortIndex > 2){
            sortIndex = 0
        } else {
            sortIndex += 1
        }
        print(sortIndex)
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
    
    func recordAudio(){
        //
    }
    
    //----------------------------------------------------------
    //Bubble Sort: O((n^2)/2)
    func bubbleSort(_ array: [Int]) {
               var bubbleArray = array
                for _ in 0...bubbleArray.count {
                    for value in 1...bubbleArray.count - 1 {
                        if bubbleArray[value-1] < bubbleArray[value] {
                            let largerValue = bubbleArray[value-1]
                            self.osc.frequency = Float(bubbleArray[value]*110)
                            Thread.sleep(forTimeInterval: 0.050)
                            bubbleArray[value-1] = bubbleArray[value]
                            bubbleArray[value] = largerValue
                            self.osc.frequency = Float(bubbleArray[value]*110)
                            Thread.sleep(forTimeInterval: 0.050)

                        }
                    }
                }
                print("Sorted\(bubbleArray)")
                //return arr
    }
    
    //----------------------------------------------------------
    //Insertion Sort: O(n^2)
    //sorting in desc order because musically is sounds asc
    func insertionSort(_ array: [Int]){
       var insArray = array
        for x in 1..<insArray.count {
            var y = x
            while y > 0 && insArray[y] > insArray[y - 1] {
                self.osc.frequency = Float(insArray[y]*110)
                Thread.sleep(forTimeInterval: 0.050)
                insArray.swapAt(y - 1, y)
                self.osc.frequency = Float(insArray[y]*110)
                Thread.sleep(forTimeInterval: 0.050)
                y -= 1
            }
        }
        print("Sorted\(insArray)")
       // return arr
    }
    
    //----------------------------------------------------------
    //Selection Sort: O(n^2()
    //a modified insertion sort
    func selectionSort(_ array: [Int]){
        var selectionArray = array

        for x in 0 ..< selectionArray.count - 1 {
            var lowest = x
            for y in x + 1 ..< selectionArray.count {
                if selectionArray[y] < selectionArray[lowest] {
                    self.osc.frequency = Float(selectionArray[y]*110)
                    Thread.sleep(forTimeInterval: 0.050)
                    lowest = y
                }
            }
            if x != lowest {
                self.osc.frequency = Float(selectionArray[x]*110)
                Thread.sleep(forTimeInterval: 0.050)
                selectionArray.swapAt(x, lowest)
                self.osc.frequency = Float(selectionArray[x]*110)
                Thread.sleep(forTimeInterval: 0.050)
            }
        }
        //return selectionArray
        print("Sorted\(selectionArray)")
    }
    
    //----------------------------------------------------------
    //merge sort function collection
    //Merge Sort: O(nlog(n))
    func merge(arr1: [Int], arr2: [Int]) -> [Int] {
        var arr1Index = 0
        var arr2Index = 0
            
        var sortedArray = [Int]()
        
        while arr1Index < arr1.count && arr2Index < arr2.count {
            if arr1[arr1Index] < arr2[arr2Index] {
                sortedArray.append(arr1[arr1Index])
                arr1Index += 1
            } else if arr1[arr1Index] > arr2[arr2Index] {
                sortedArray.append(arr2[arr2Index])
                arr2Index += 1
            } else {
                sortedArray.append(arr1[arr1Index])
                arr1Index += 1
                sortedArray.append(arr2[arr2Index])
                arr2Index += 1
                
            }
        }

        while arr1Index < arr1.count {
            sortedArray.append(arr1[arr1Index])
            arr1Index += 1
        }
        while arr2Index < arr2.count {
            sortedArray.append(arr2[arr2Index])
            arr2Index += 1
        }
        for i in sortedArray{
            self.osc.frequency = Float(i*110)
            Thread.sleep(forTimeInterval: 0.050)
        }
        return sortedArray
        
    }
    //merge sort parent function for array splits
    func mergeSort(_ array: [Int]) -> [Int] {
        guard array.count > 1 else { return array }
        
        let cutIndex = array.count / 2
        
        let arr1 = mergeSort(Array(array[0..<cutIndex]))
        let arr2 = mergeSort(Array(array[cutIndex..<array.count]))
        
        return merge(arr1: arr1, arr2: arr2)
    }
    
    //----------------------------------------------------------
    //Quick Sort: O(nlog(n)->O(n^2)
    //Quick sort using random pivot index, dending on the dataset, can be logarithmic or quadratic
    /* Returns a random integer in the range min...max, inclusive. */
    public func random(min: Int, max: Int) -> Int {
      assert(min < max)
      return min + Int(arc4random_uniform(UInt32(max - min + 1)))
    }
    
    /*
      Lomuto's partitioning algorithm.
      This is conceptually simpler than Hoare's original scheme but less efficient.
      The return value is the index of the pivot element in the new array. The left
      partition is [low...p-1]; the right partition is [p+1...high], where p is the
      return value.
      The left partition includes all values smaller than or equal to the pivot, so
      if the pivot value occurs more than once, its duplicates will be found in the
      left partition.
    */
    func partitionLomuto<T: Comparable>(_ a: inout [T], low: Int, high: Int) -> Int {
      // We always use the highest item as the pivot.
      let pivot = a[high]

      // This loop partitions the array into four (possibly empty) regions:
      //   [low  ...      i] contains all values <= pivot,
      //   [i+1  ...    j-1] contains all values > pivot,
      //   [j    ... high-1] are values we haven't looked at yet,
      //   [high           ] is the pivot value.
      var i = low
      for j in low..<high {
        if a[j] <= pivot {
          (a[i], a[j]) = (a[j], a[i])
          i += 1
        }
      }

      // Swap the pivot element with the first element that is greater than
      // the pivot. Now the pivot sits between the <= and > regions and the
      // array is properly partitioned.
      (a[i], a[high]) = (a[high], a[i])
      return i
    }

    /*
      Uses a random pivot index. On average, this results in a well-balanced split
      of the input array.
    */
    func quicksortRandom<T: Comparable>(_ a: inout [T], low: Int, high: Int) {
      if low < high {
        // Create a random pivot index in the range [low...high].
        let pivotIndex = random(min: low, max: high)
        // Because the Lomuto scheme expects a[high] to be the pivot entry, swap
        // a[pivotIndex] with a[high] to put the pivot element at the end.
        (a[pivotIndex], a[high]) = (a[high], a[pivotIndex])
        let p = partitionLomuto(&a, low: low, high: high)
        quicksortRandom(&a, low: low, high: p - 1)
        quicksortRandom(&a, low: p + 1, high: high)
      }
    }
    /*
      Swift's swap() doesn't like it if the items you're trying to swap refer to
      the same memory location. This little wrapper simply ignores such swaps.
    */
    public func swap<T>(_ a: inout [T], _ i: Int, _ j: Int) {
      if i != j {
        
        a.swapAt(i, j)
      }
    }
    
}







