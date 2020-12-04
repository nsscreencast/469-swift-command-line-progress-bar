import ArgumentParser
import Files
import Foundation
import Subprocess

// swift-encode <input_file> -o output
struct Encode: ParsableCommand {
    @Argument(help: "The input movie file to encode")
    var inputFile: String
    
    @Option(name: [.short, .customLong("out")], help: "The output directory in which to place the encoded files.")
    var outputDirectory: String = "output"

    func run() throws {    
        print("Running swift-encode...")
        print("Input file: \(inputFile, color: .cyan)")
        print("Output dir: \(outputDirectory, color: .cyan)")
            
        let file = try File(path: inputFile)
        let video = Video(file: file)
        try ANSIColor.with(.yellow) {
            _ = try Folder.current.createSubfolderIfNeeded(withName: outputDirectory)
            
            let frames = try video.totalFrames()
            print("Number of frames: \(frames)")
            print("AVG Frame Rate: \(try video.avgFrameRate())")
        }
        
        let encoder = VideoEncoder(file: file)
        try encoder.encode()
    }
}

Encode.main()

