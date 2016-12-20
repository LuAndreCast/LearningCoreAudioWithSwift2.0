//
//  main.swift
//  CAMetadata
//
//  Created by Ales Tsurko on 23.08.15.
//

import Foundation
import AudioToolbox

func main() {
    let argc = CommandLine.argc
    let argv = CommandLine.arguments
    
    guard argc > 1 else
    {
        print("Usage: CAMetaData /full/path/to/audiofile\n")
        return
    }
    
    if let audiofilePath = NSString(utf8String: argv[1])?.expandingTildeInPath
    {
        let audioURL = URL(fileURLWithPath: audiofilePath)
        var audiofile: AudioFileID? = nil
        var theErr = noErr
        
        //open file
        theErr = AudioFileOpenURL(audioURL as CFURL,
                                  AudioFilePermissions.readPermission,
                                  0,
                                  &audiofile)
        assert(theErr == noErr)
        
        //file info
        var dictionarySize: UInt32 = 0
        var isWritable: UInt32 = 0
        theErr = AudioFileGetPropertyInfo(audiofile!,
                                          kAudioFilePropertyInfoDictionary,
                                          &dictionarySize,
                                          &isWritable)
        assert(theErr == noErr)
        
        //file dictionary
        var dictionary: UnsafePointer<CFDictionary>? = nil
        theErr = AudioFileGetProperty(audiofile!,
                                      kAudioFilePropertyInfoDictionary,
                                      &dictionarySize,
                                      &dictionary)
        assert(theErr == noErr)
        
        NSLog("dictionary: %@", dictionary ?? "EMPTY")
        
        //close file
        theErr = AudioFileClose(audiofile!)
        assert(theErr == noErr)
        
    } else {
        print("File not found\n")
    }
    
}

main()
