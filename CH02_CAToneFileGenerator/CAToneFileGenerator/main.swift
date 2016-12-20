//
//  main.swift
//  CAToneFileGenerator
//
//  Created by Ales Tsurko on 25.08.15.
//

import Foundation
import AudioToolbox

let SAMPLE_RATE: Float64 = 44100
let DURATION = 5.0

enum waveType:String {
    case square = "square"
    case saw = "saw"
    case sine = "sine"
}

func main() {
    let argc = CommandLine.argc
    let argv = CommandLine.arguments
    var typeOfFormat:waveType = waveType.sine
    
    guard argc > 1 else {
        print("Usage: CAToneFileGenerator n\n(where n is tone in Hz)")
        return
    }
    
    guard let hz:Double = Double(argv[1]) else
    {
        print("Usage: CAToneFileGenerator n\n(where n is tone in Hz), \n argument provided is not a double")
        return
    }
   
    assert(hz > 0)
    
    print("generating \(hz) hz tone")
    
    var fileName = String(format: "%0.3f-",hz)
    fileName = fileName.appending( String(format: "%@.aif", typeOfFormat.rawValue) )
    
    let filePath = (FileManager.default.currentDirectoryPath as NSString).appendingPathComponent(fileName)
    let fileURL: CFURL = URL(fileURLWithPath: filePath) as CFURL
    
    // Prepare for format
    var asbd:AudioStreamBasicDescription = AudioStreamBasicDescription()
    
    //clearing
    //the below line is NOT require on swift (automatically done)
//    memset(&asbd,0, MemoryLayout.size(ofValue: asbd))
    
    asbd.mSampleRate = SAMPLE_RATE;
    asbd.mFormatID = kAudioFormatLinearPCM
    asbd.mFormatFlags = kLinearPCMFormatFlagIsBigEndian | kLinearPCMFormatFlagIsSignedInteger | kLinearPCMFormatFlagIsPacked
    asbd.mBitsPerChannel = 16
    asbd.mChannelsPerFrame = 1
    asbd.mBytesPerFrame = asbd.mChannelsPerFrame * 2
    asbd.mFramesPerPacket = 1
    asbd.mBytesPerPacket = asbd.mFramesPerPacket * asbd.mBytesPerFrame
    
    // Set up the file
    var audioFile: AudioFileID? = nil
    var audioErr = noErr
    
    audioErr = AudioFileCreateWithURL(fileURL,
                                      kAudioFileAIFFType,
                                      &asbd,
                                      AudioFileFlags.eraseFile,
                                      &audioFile)
    
    assert(audioErr == noErr)
    
    // Start writing samples
    let maxSampleCount = Int(SAMPLE_RATE * DURATION * Double(asbd.mChannelsPerFrame))
    var sampleCount = 0
    var bytesToWrite: UInt32 = 2
    let wavelengthInSamples = SAMPLE_RATE/hz
    
    while sampleCount < maxSampleCount {
        for n in 0..<Int(wavelengthInSamples) {
            
            var sample:Int16 = 0
            switch typeOfFormat {
                case .square:
                    sample = n < Int(wavelengthInSamples) / 2 ? (Int16.max).bigEndian : (Int16.min).bigEndian
                    break
                case .saw:
                    sample = Int16(((Double(n) / wavelengthInSamples) * Double(Int16.max) * 2) - Double(Int16.max)).bigEndian
                    break
                case .sine:
                    sample = Int16(Double(Int16.max) * sin(2 * M_PI * (Double(n) / wavelengthInSamples))).bigEndian
                    break
            }
            
            //write to file
            audioErr = AudioFileWriteBytes(audioFile!,
                                           false,
                                           Int64(sampleCount*2),
                                           &bytesToWrite,
                                           &sample)
            
            assert(audioErr == noErr)
            sampleCount += 1
        }
    }
    
    //close file
    audioErr = AudioFileClose(audioFile!)
    
    print("wrote \(sampleCount) samples")
}

main()
