import Files
import Foundation

enum CodecType: String, Codable {
    case audio
    case video
}

struct FFProbeStream: Codable {
    let codecType: CodecType
    let width: Int?
    let height: Int?
    let duration: String
    let nbFrames: String
    let avgFrameRate: String
}

struct FFProbeOutput: Codable {
    let streams: [FFProbeStream]
}

class Video {
    private let file: File

    init(file: File) {
        self.file = file
    }
    
    private var _ffprobe: FFProbeOutput?
    
    private func ffprobe() throws -> FFProbeOutput  {
        if _ffprobe == nil {
            let stdout = Pipe()
            let stderr = Pipe()
            let task = makeTask(command: "ffprobe", arguments: [
                    file.path,
                    "-print_format", "json",
                    "-v", "quiet",
                    "-show_streams"
                ], stdout: stdout, stderr: stderr)
            task.launch()
            task.waitUntilExit()
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let json = stdout.fileHandleForReading.readDataToEndOfFile()
            _ffprobe = try decoder.decode(FFProbeOutput.self, from: json)
        }
        return _ffprobe!
    }
    
    func totalFrames() throws -> Int {
        return Int(try ffprobe().streams.first!.nbFrames) ?? 0
    }
    
    func avgFrameRate() throws -> Float {
        let avgFrameRateString = try ffprobe().streams.first!.avgFrameRate
        let parts = avgFrameRateString.split(separator: "/")
        assert(parts.count == 2)
        let n = Float(parts[0])!
        let d = Float(parts[1])!
        return n/d
    }
}
