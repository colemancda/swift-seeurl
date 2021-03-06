//
//  cURLWriteFunction.swift
//  SwiftFoundation
//
//  Created by Alsey Coleman Miller on 8/4/15.
//  Copyright © 2015 PureSwift. All rights reserved.
//  Copyright © 2016 Shiroyagi Corporation. All rights reserved.
//

import CcURL
import Foundation

public extension cURL {
    
    public typealias WriteCallBack = curl_write_callback
    
    public static var WriteFunction: WriteCallBack { return curlWriteFunction }
    
    public final class WriteFunctionStorage {
        
        public var data = [] as [UInt8]
        
        public init() { }
    }
}

public func curlWriteFunction(contents: UnsafeMutablePointer<Int8>?, size: Int, nmemb: Int, readData: UnsafeMutableRawPointer?) -> Int {
    
    guard let contents = contents, let readData = readData else {
        return 0
    }
    
    let storage = unsafeBitCast(readData, to: cURL.WriteFunctionStorage.self)
    
    let realsize = size * nmemb
    
    var pointer = contents
    
    for _ in 1...realsize {
        
        let byte = unsafeBitCast(pointer.pointee, to: UInt8.self)
        
        storage.data.append(byte)
        
        pointer = pointer.successor()
    }
    
    return realsize
}
