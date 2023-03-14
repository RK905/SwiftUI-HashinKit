import SwiftUI
import AVFoundation
import HaishinKit

struct RecordView: View {
    @State private var isRecording = false
    private let rtmpConnection = RTMPConnection()
    private let rtmpStream: RTMPStream
    
    init() {
        let session = AVAudioSession.sharedInstance()
        try? session.setCategory(.playAndRecord)
        try? session.setMode(.videoRecording)
        try? session.setActive(true)
        
        rtmpStream = RTMPStream(connection: rtmpConnection)
    }
    
    var body: some View {
        VStack {
            Button(action: toggleRecording) {
                Text(isRecording ? "Stop Recording" : "Start Recording")
                    .font(.title)
                    .foregroundColor(.white)
                    .padding()
                    .background(isRecording ? Color.red : Color.blue)
                    .cornerRadius(10)
            }
        }
    }
    
    private func toggleRecording() {
        isRecording.toggle()
        
        if isRecording {
            startRTMPStreaming()
        } else {
            stopRTMPStreaming()
        }
    }
    
    private func startRTMPStreaming() {
        rtmpStream.attachAudio(AVCaptureDevice.default(for: .audio))
        rtmpStream.attachCamera(AVCaptureDevice.default(for: .video))
        
        rtmpConnection.connect("rtmp://your-rtmp-server-address/appName")
        rtmpStream.publish("streamName")
    }
    
    private func stopRTMPStreaming() {
        rtmpStream.close()
        rtmpConnection.close()
    }
}

struct RecordView_Previews: PreviewProvider {
    static var previews: some View {
        RecordView()
    }
}
