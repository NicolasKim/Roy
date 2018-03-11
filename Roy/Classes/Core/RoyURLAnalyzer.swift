//
//  RoyURLAnalyzer.swift
//  Pods-Roy_Example
//
//  Created by dreamtracer on 2018/3/10.
//

import Foundation

enum RoyURLParamType:String {
    case NUMBER = "number"
    case TEXT = "text"
}

struct RoyURLParam {
    //是否为必填项
    var isNecessary = false
    //类型
    var type : RoyURLParamType = .NUMBER
    //键
    var key  : String?
}

struct RoyURL{
    var scheme : String
    var host   : String
    var path   : String
    var params : [RoyURLParam]?
    var key : String{
        get{
            return scheme.appending(host).appending(path)
        }
    }
}

public class RoyURLAnalyzer {
    
    static func getKey(url:String) -> String?{
        guard let scheme = getScheme(url: url) else {
            return nil;
        }
        
        guard let host = getHost(url: url)  else {
            return nil
        }
        
        guard let path = getPath(url:url) else {
            return nil
        }
        return scheme.appending(host).appending(path)
    }
    
    static func getPathWithoutParams(url:String) -> String?{
        guard let scheme = getScheme(url: url) else {
            return nil;
        }
        
        guard let host = getHost(url: url)  else {
            return nil
        }
        
        guard let path = getPath(url:url) else {
            return nil
        }
        return "\(scheme)://\(host)/\(path)"
    }
    
    
    
    static func convert(url:String) -> RoyURL? {
        guard let scheme = getScheme(url: url) else {
            return nil;
        }

        guard let host = getHost(url: url)  else {
           return nil
        }
        
        guard let path = getPath(url:url) else {
            return nil
        }
        
        let params = getParams(url: url)
        
        let u = RoyURL(scheme: scheme,
                       host: host,
                       path: path,
                       params: params)
        
        
        return u
    }
    
    
    
    static func getScheme(url:String) -> String? {
        let scanner = Scanner(string: url)
        var scheme : NSString?
        while !scanner.isAtEnd {
            if scanner.scanString("://", into: &scheme){
                return url.substring(to: url.index(url.startIndex, offsetBy: scanner.scanLocation - 3))
            }
            scanner.scanLocation = scanner.scanLocation+1
        }
        return nil;
    }
    
    static func getHost(url:String) -> String? {
        let scanner = Scanner(string: url)
        var startIndex = -1
        while !scanner.isAtEnd {
            if startIndex == -1 && scanner.scanString("://", into: nil){
                startIndex = scanner.scanLocation
            }
            else if startIndex != -1{
                if scanner.scanString("/", into: nil){
                    let start = url.index(url.startIndex, offsetBy: startIndex)
                    let end = url.index(url.startIndex,offsetBy:scanner.scanLocation-1)
                    return url.substring(with: start..<end)
                }
            }
            scanner.scanLocation = scanner.scanLocation+1
            
        }
        return nil
    }
    
    static func getPath(url:String) -> String? {
        let scanner = Scanner(string: url)
        var schemeFound = false
        var startIndex = -1
        var endIndex = -1
        while !scanner.isAtEnd {
            if !schemeFound && scanner.scanString("://", into: nil){
                schemeFound = true;
            }
            else if schemeFound {
                if(startIndex == -1){
                    if scanner.scanString("/", into: nil){
                        startIndex = scanner.scanLocation
                    }
                }
                else if scanner.scanString("?", into: nil) {
                    endIndex = scanner.scanLocation
                    break;
                }
            }
            scanner.scanLocation = scanner.scanLocation+1
        }
        if startIndex != -1 {
            let start = url.index(url.startIndex, offsetBy: startIndex)
            var end = url.index(url.endIndex, offsetBy: 0)
            if endIndex > -1{
                end = url.index(url.startIndex, offsetBy: endIndex-1)
            }
            return url.substring(with: start..<end)
        }
        return nil
    }
    
    static func getParams(url:String) -> [RoyURLParam]? {
        let scanner = Scanner(string: url)
        var schemeFound = false
        var hostFound = false
        var pathFound = false
        var startIndex = -1
        while !scanner.isAtEnd {
            if !schemeFound && scanner.scanString("://", into: nil){
                schemeFound = true;
            }
            else if schemeFound && !hostFound && scanner.scanString("/", into: nil) {
                hostFound = true
            }
            else if schemeFound && hostFound && !pathFound && scanner.scanString("?", into: nil) {
                pathFound = true
                startIndex = scanner.scanLocation
                break;
            }
            scanner.scanLocation = scanner.scanLocation+1
        }
        if startIndex != -1 {
        	let paramStr = url.substring(from: url.index(url.startIndex, offsetBy: startIndex))
            let keyValuePairs = paramStr.split(separator: "&").map(String.init)
            var params:[RoyURLParam] = []
            for keyValuePairStr in keyValuePairs {
                let keyValuePairArr = keyValuePairStr.split(separator: "=").map(String.init)
                if keyValuePairArr.count != 2 {
                    continue;
                }
				let valValidate = keyValuePairArr[1]
                let subScanner = Scanner.init(string:valValidate)
                var hasPrefix = false
                var hasSuffix = false
                var hasQuestionMark = false
                var startIndex = -1
                var type : RoyURLParamType? = .NUMBER
                
                
                
                while !subScanner.isAtEnd {
                    if !hasPrefix && subScanner.scanString("<", into: nil){
                        startIndex = subScanner.scanLocation
                        hasPrefix = true
                    }
                    else if hasPrefix{
                        if subScanner.scanString("?", into: nil) {
                            let start = valValidate.index(valValidate.startIndex, offsetBy: startIndex)
                            let end = valValidate.index(valValidate.startIndex,offsetBy:subScanner.scanLocation-1)
                            type = RoyURLParamType(rawValue: valValidate.substring(with: start..<end))
                            hasQuestionMark = true
                        }
						if subScanner.scanString(">", into: nil) {
                            hasSuffix = true
                            break;
                        }
                    }
                    subScanner.scanLocation = subScanner.scanLocation+1
                }
                
                
                
                if hasSuffix && hasPrefix{
                    var paramItem = RoyURLParam()
                    paramItem.key = keyValuePairArr[0]
                    paramItem.type = type!
                    paramItem.isNecessary = !hasQuestionMark
                    params.append(paramItem)
                }
            }
            return params
        }
        return nil
    }
    
}

