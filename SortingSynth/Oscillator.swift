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
    @Published var delay = Delay(DynamicOscillator())
    @Published var reverb = Reverb(DynamicOscillator())
    @Published var isDelay: Bool = false
    @Published var isReverb: Bool = false
    @Published var currentNote: MIDINoteNumber = 0
    @Published var mixer = Mixer()
    @Published var speed: Double = 0.050 //default speed value
    @Published var selectedKeyIndex1: Int = 0
    @Published var selectedKeyIndex2: Int = -1
    @Published var isMinor: Bool = false
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
    
    //class initializer
    init() {
        mixer.addInput(osc) //add oscillator to mixer
        delay = Delay(osc) //process oscillator through delay node
        reverb = Reverb(osc) //process oscillator through reverb node
        mixer.addInput(delay) //add delay node to mixer
        mixer.addInput(reverb) //add reverb node to mixer
        delay.bypass()
        reverb.bypass()
        engine.output = mixer
        do {
            try engine.start()
        } catch {
            assert(false, "The audio engine cannot start!")
        }
    }
    
    //starts playing the synth
    //currently set to hardcoded values, this will become dynamic
    func noteOn() {
        if isDelay {
            delay.play()
        } else {
            delay.bypass()
        }
        if isReverb{
            reverb.play()
        } else {
            reverb.bypass()
        }
        isPlaying = true
        osc.amplitude = 0.2 //size of the waveform in relation to the audio room
        osc.frequency = 220.0 //number of cycles per sec (Hz)
        SetWaveTable()
        SetSort()
    }
    
    func SetSort(){
        let untrimmedArray = SetKeyArray()
       // let arraySlice = untrimmedArray[14...35]
       // var sortArray = Array(arraySlice)
        var sortArray = untrimmedArray
        sortArray = sortArray.shuffled()
        switch sortIndex{
        case 0:
            insertionSort(sortArray)
        case 1:
            //mergeSort has recursive paths, requires return values
            //return to anonymous
            _ = mergeSort(sortArray)
        case 2:
            bubbleSort(sortArray)
        case 3:
            selectionSort(sortArray)
        default:
            insertionSort(sortArray)
        }
    }
    
    func SetKeyArray()->[Int]{
        let selectedArray: [Int]
        switch selectedKeyIndex1{
        case 0:
        //cmaj
           selectedArray=[36,38,40,41,43,45,47,48,50,52,53,55,57,59,60,62,64,65,67,69,71,72,74,76,77,79,81,83,84]
            break
        case 1:
        //gmaj
            selectedArray = [31,33,35,36,38,40,42,43,45,47,48,50,52,54,55,57,59,60,62,64,66,67,69,71,72,74,76,78,79]
            break
        case 2:
        //dmaj
            selectedArray = [38,40,42,44,45,47,49,50,52,54,56,57,59,61,62,64,66,68,69,71,73,74,76,78,80,81,83,85,86]
            break
        case 3:
        //amaj
            selectedArray = [33,35,37,38,40,42,44,45,47,49,50,52,54,56,57,59,61,62,64,66,68,69,71,73,74,76,78,80,81]
            break
        case 4:
        //emaj
            selectedArray = [40,42,44,45,47,49,51,52,54,56,57,59,61,63,64,66,68,69,71,73,75,76,78,80,81,83,85,87,88]
            break
        case 5:
        //bmaj
            selectedArray = [35,37,39,40,42,44,46,47,49,51,52,54,56,58,59,61,63,64,66,68,70,71,73,75,76,78,80,82,83]
            break
        case 6:
        //f# major
            selectedArray = [30,32,34,35,37,39,40,42,44,46,47,49,51,52,54,56,58,59,61,63,64,66,68,70,71,73,75,76,78]
            break
        case 7:
        //Db
            selectedArray = [37,39,40,42,44,46,47,49,51,52,54,56,58,59,61,63,64,66,68,70,71,73,75,76,78,80,82,83,85]
            break
        case 8:
        //Ab
            selectedArray = [34,35,37,39,40,42,44,46,47,49,51,52,54,56,58,59,61,63,64,66,68,70,71,73,75,76,78,80,82]
            break
        case 9:
        //Eb
            selectedArray = [39,40,42,44,46,47,49,51,52,54,56,58,59,61,63,64,66,68,70,71,73,75,76,78,80,82,83,85,87]
            break
        case 10:
        //Bb
            selectedArray = [34,35,37,39,40,42,44,46,47,49,51,52,54,56,58,59,61,63,64,66,68,70,71,73,75,76,78,80,82]
            break
        case 11:
        //F
            selectedArray = [34,35,37,39,40,42,44,46,47,49,51,52,54,56,58,59,61,63,64,66,68,70,71,73,75,76,78,80,82]
            break
        default:
            //chromatic scale
            selectedArray = Array(36...84)
            break
        }
        return selectedArray
    }
    
    //stop the synth
    func noteOff() {
        isPlaying = false
    }
    
    //take input integer and converts it to UInt8 midi note
    //uses audiokit's midinotetofrequency function to convert to frequency double
    func setFrequency(note: Int){
        currentNote = numericCast(note)
        self.osc.frequency = currentNote.midiNoteToFrequency()
        Thread.sleep(forTimeInterval: self.speed)
    }

    
    //----------------------------------------------------------
    //Bubble Sort: O((n^2)/2)
    func bubbleSort(_ array: [Int]) {
               var bubbleArray = array
                for _ in 0...bubbleArray.count {
                    for value in 1...bubbleArray.count - 1 {
                        if bubbleArray[value-1] < bubbleArray[value] {
                            let largerValue = bubbleArray[value-1]
                           // self.osc.frequency = Float(bubbleArray[value]*110)
                            setFrequency(note: bubbleArray[value])
                           // Thread.sleep(forTimeInterval: 0.050)
                            bubbleArray[value-1] = bubbleArray[value]
                            bubbleArray[value] = largerValue
                            setFrequency(note: bubbleArray[value])
                            //self.osc.frequency = Float(bubbleArray[value]*110)
                           // Thread.sleep(forTimeInterval: 0.050)

                        }
                    }
                }
        for i in bubbleArray{
            setFrequency(note: i)
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
                setFrequency(note:insArray[y])
                insArray.swapAt(y - 1, y)
                setFrequency(note:insArray[y])
                y -= 1
            }
        }
        for i in insArray{
            setFrequency(note: i)
        }
        print("Sorted\(insArray)")
       // return arr
    }
    
    //----------------------------------------------------------
    //Selection Sort: O(n^2)
    //a modified insertion sort
    func selectionSort(_ array: [Int]){
        var selectionArray = array
        
        for x in 0 ..< selectionArray.count - 1 {
            var lowest = x
            for y in x + 1 ..< selectionArray.count {
                if selectionArray[y] < selectionArray[lowest] {
                    setFrequency(note:selectionArray[y])
                    lowest = y
                }
            }
            if x != lowest {
                setFrequency(note: selectionArray[x])
                selectionArray.swapAt(x, lowest)
                setFrequency(note: selectionArray[x])
            }
        }
        //grand finale
        for i in selectionArray {
            setFrequency(note: i)
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
            setFrequency(note: i)
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
