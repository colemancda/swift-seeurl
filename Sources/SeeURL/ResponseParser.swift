//
//  ResponseParser.swift
//  SeeURL
//
//  Created by ito on 2/20/16.
//  Copyright © 2016 PureSwift. All rights reserved.
//

struct ResponseHeaderParser {
    let headerString: String
    init(data: [CChar]) {
        headerString = String.fromCString(data) ?? ""
    }
    func parse() -> [HTTPClient.Header] {
        let lines = headerString.splitCRorLF()
        return lines.map({ $0.splitByFirstColon() }).filter({ $0.count == 2})
            .map({ ($0[0], $0[1]) })
    }
}

extension String {
    func splitCRorLF() -> [String] {
        return self.characters.split { $0 == "\r" || $0 == "\n" || $0 == "\r\n" }.filter({ $0.count > 0}).map(String.init)
    }
    func splitByFirstColon() -> [String] {
        var modeIsName: Bool = true
        var name: [Character] = []
        var value: [Character] = []
        for c in self.characters {
            if modeIsName && c == ":" {
                modeIsName = false
                continue
            }
            if modeIsName {
                name.append(c)
            } else {
                // trim left " " of value
                if value.count == 0 && c == " " {
                    // skip
                } else {
                    value.append(c)
                }
            }
        }
        if name.count > 0 && value.count > 0 {
            return [String(name), String(value)]
        } else {
            return [self]
        }
    }
}