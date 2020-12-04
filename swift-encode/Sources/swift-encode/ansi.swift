struct ColorStack {
    private static var colors: [ANSIColor] = [.unset]
    
    static var currentColor: ANSIColor? { colors.last }
    
    static func push(_ color: ANSIColor) {
        colors.append(color)
        color.setCurrent()
    }
    
    static func pop() {
        colors.removeLast()
        currentColor?.setCurrent()
    }
}

enum ANSIColor: String {
    case black = "\u{001B}[0;30m"
    case red = "\u{001B}[0;31m"
    case green = "\u{001B}[0;32m"
    case yellow = "\u{001B}[0;33m"
    case blue = "\u{001B}[0;34m"
    case magenta = "\u{001B}[0;35m"
    case cyan = "\u{001B}[0;36m"
    case white = "\u{001B}[0;37m"
    case unset = "\u{001B}[0m"
    
    func setCurrent() {
        print(rawValue)
    }
    
    static func with(_ color: ANSIColor, _ block: () throws -> Void) rethrows {
        ColorStack.push(color)
        defer { ColorStack.pop() }
        try block()
    }
}

func + (left: ANSIColor, right: String) -> String {
    left.rawValue + right
}

extension String.StringInterpolation {
    mutating func appendInterpolation(_ value: CustomStringConvertible, color: ANSIColor) {
        let restoreColor = ColorStack.currentColor ?? .unset
        appendInterpolation(color.rawValue + value.description + restoreColor.rawValue)
    }
}
