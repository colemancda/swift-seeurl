//
//  HTTPClientTests.swift
//  SwiftFoundation
//
//  Created by Alsey Coleman Miller on 8/9/15.
//  Copyright © 2015 PureSwift. All rights reserved.
//

#if os(OSX) || os(iOS)
    import cURL
#elseif os(Linux)
    import CcURL
#endif

import XCTest
import SeeURL


final class HTTPClientTests: XCTestCase {
    
    lazy var allTests : [(String, () -> Void)] = [
            ("testStatusCode", self.testStatusCode)
        ]

    func testStatusCode() {
        
        let url = "https://httpbin.org/status/200"
        
        var response: HTTPClient.Response!
        
        do {
            response = try HTTPClient.sendRequest("GET", url: url)
        }
        catch { XCTFail("\(error)"); return }
        
        let statusCode = response.0
        
        XCTAssert(statusCode == 200, "\(statusCode) == \(200)")
    }
    
    func testResponseBody() {
        
        let url = "http://httpbin.org/robots.txt"
        
        var response: HTTPClient.Response!
        
        do {
            response = try HTTPClient.sendRequest("GET", url: url)
        }
        catch { XCTFail("\(error)"); return }
        
        let statusCode = response.0
        
        XCTAssert(statusCode == 200, "\(statusCode) == \(200)")
        
        let responseString = String.fromCString(unsafeBitCast(response.2, [CChar].self))

        print(response.1)
        
        XCTAssertEqual(response.1[0].0, "Server")
        XCTAssertEqual(response.1[0].1, "nginx")
        
        XCTAssertTrue(responseString!.hasPrefix("User-agent"))
        
    }
}
