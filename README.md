# LearningCoreAudioWithSwift2.0
All the examples of the Learning Core Audio book rewritten with Swift 2.0

## Known issues

### CH08_AUGraphInput
If you use different devices for input and output the output can be silence. In such case try to increase or decrease size of the ring buffer.

### CH11_MIDIWifiSource
The MIDIWifiSource is crashing with iOS 9 + OS X 10.10 (I've no possibility to test it with another configurations). The problem is in creating of connection (line #50):
```swift
let connection = MIDINetworkConnection(host: host)
```
I didn't found how to fix it yet.

##Projects
### CH01_CAMetadata

To run: Update Edit Scheme -> Arguments | with the file path of your audio file

### CH02_CAToneFileGenerator

To run: Update Edit Scheme -> Arguments | with a double value


### CH03_CAStreamFormatTester

### CH04_Recorder

### CH05_Player

### CH06_AudioConverter

### CH06_ExtAudioFileConverter

### CH06_AudioConverter

### CH07_AUGraphPlayer

### CH07_AUGraphSineWave

### CH07_AUGraphSpeechSynthesis

### CH08_AUGraphInput

### CH09_OpenALOrbitLoop

### CH09_OpenALOrbitStream

### CH10_iOSBackgroundingTone

### CH10_iOSPlayThrough

### CH11_MIDIToAUGraph

### CH11_MIDIWifiSource


