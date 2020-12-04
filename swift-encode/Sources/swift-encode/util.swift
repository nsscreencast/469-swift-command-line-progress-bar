import Foundation

@discardableResult
func makeTask(command: String, arguments: [String], stdout: Pipe, stderr: Pipe) -> Process {
    let task = Process()
    task.standardOutput = stdout
    task.standardError = stderr
    task.executableURL = URL(fileURLWithPath: "/usr/bin/env")
    task.arguments = [command] + arguments
    
    return task
}

@discardableResult
func cmd(_ command: String, _ arguments: String...) -> Int32 {
    let stdout = Pipe()
    let stderr = Pipe()
    
    let task = makeTask(command: command, arguments: arguments, stdout: stdout, stderr: stderr)
    
    print(stdout.readStringToEndOfFile())
    print(stderr.readStringToEndOfFile())
    
    task.launch()
    task.waitUntilExit()
    
    return task.terminationStatus
}

func regexCapture(_ input: String, pattern: String, capture: String) throws -> String? {
    let regex = try NSRegularExpression(pattern: pattern, options: [])
    let nsrange = NSRange(input.startIndex..<input.endIndex, in: input)
    var capture: String?
    regex.enumerateMatches(in: input, options: [], range: nsrange) { match, flags, stop in 
        guard let match = match else { return }
        let captureRange = match.range(withName: "fps")
        guard captureRange.location != NSNotFound,
            let range = Range(nsrange, in: input) else { return }
        capture = String(input[range])
    }
    return capture
}

extension Pipe {
    func readStringToEndOfFile() -> String {
        let data = fileHandleForReading.readDataToEndOfFile()
        return String(data: data, encoding: .utf8)!
    }
}
