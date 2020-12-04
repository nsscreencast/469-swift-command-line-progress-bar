//
//  video-encoder.swift
//  swift-encode
//
//  Created by Ben Scheirman on 12/4/20.
//

import Foundation
import Files
import Subprocess
import SwiftProgressBar

class VideoEncoder {
    let file: File
    
    private var observers: [NSObjectProtocol] = []
    private let frameRegex: NSRegularExpression
    private let video: Video
    
    init(file: File) {
        self.file = file
        self.video = Video(file: file)
        try! frameRegex = NSRegularExpression(pattern: #"frame=\s*(?<frame>\d+)\s"#, options: .caseInsensitive)
    }
    
    lazy var numberOfFrames: Int = {
        try! video.totalFrames()
    }()
    
    func encode() throws {
        let command = [
            "/usr/bin/env",
            "ffmpeg",
            "-i",
            file.path,
            "-c:v", "libx264",
            "-crf", "22",
            "-c:a", "aac",
            "-b:a", "256k",
            "-y",
            "out.mp4"
        ]
        let process = Subprocess(command)
        
        print("📼 Encoding...")
        var progressBar = ProgressBar(output: FileHandle.standardOutput)
        progressBar.render(count: 0, total: numberOfFrames)
        
        let group = DispatchGroup()
        group.enter()
        try process.launch(outputHandler: { _ in
            // ffmpeg logs to STDERR
        }, errorHandler: { data in
            if let output = String(data: data, encoding: .utf8) {
                if let frames = self.extractFrame(from: output) {
                    progressBar.render(count: frames, total: self.numberOfFrames)
                }
            }
        }, terminationHandler: { _ in
            print("\n\nDone! 🎉")
            group.leave()
        })
        
        group.wait()
    }
    
    private func extractFrame(from output: String) -> Int? {
        let range = NSRange(output.startIndex..., in: output)
        if let match = frameRegex.firstMatch(in: output, options: [], range: range) {
            let frameNSRange = match.range(withName: "frame")
            let frameRange = Range(frameNSRange, in: output)!
            let frames = output[frameRange]
            return Int(frames)
        }
        return nil
    }
}
