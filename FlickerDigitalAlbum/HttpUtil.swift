//
//  Util.swift
//  FlickerDigitalAlbum
//
//  Created by jiran on 25/05/2019.
//  Copyright © 2019 jiran. All rights reserved.
//

import UIKit

struct FlickerUnit {
    let strTitle: String
    let strLink: String
    let strM: String
    let strDateTaken: String
    let strDescription: String
    let strPublished: String
    let strAuthor: String
    let strAuthorId: String
    let strTags: String
    var image: UIImage?
    
    init(json: [String: Any]) {
        let dicJsonMediaItem: [String: Any] = json["media"] as? [String: Any] ?? [:]
        
        strTitle = json["title"] as? String ?? ""
        strLink = json["link"] as? String ?? ""
        strM = dicJsonMediaItem["m"] as? String ?? ""
        strDateTaken = json["date_taken"] as? String ?? ""
        strDescription = json["description"] as? String ?? ""
        strPublished = json["published"] as? String ?? ""
        strAuthor = json["author"] as? String ?? ""
        strAuthorId = json["author_id"] as? String ?? ""
        strTags = json["tags"] as? String ?? ""
        image = nil
    }
}

struct FlickerList {
    let strTitle: String
    let strLink: String
    let strDescription: String
    let strModified: String
    let strGenerator: String
    var arrFlickerUnit: [FlickerUnit] = []
    
    init(json: [String: Any]) {
        strTitle = json["title"] as? String ?? ""
        strLink = json["link"] as? String ?? ""
        strDescription = json["description"] as? String ?? ""
        strModified = json["modified"] as? String ?? ""
        strGenerator = json["generator"] as? String ?? ""
        
        let arrJsonItems: [Any] = json["items"] as? [Any] ?? []
        
        for nJsonCount in 0..<arrJsonItems.count {
            let dicJsonItem: [String: Any] = arrJsonItems[nJsonCount] as? [String: Any] ?? [:]
            let flickerUnit: FlickerUnit = FlickerUnit.init(json: dicJsonItem)
            
            arrFlickerUnit.append(flickerUnit)
        }
    }
}

class HttpUtil: NSObject {
    
    static func getURLSessionConfiguration() -> URLSessionConfiguration {
        let sessionConfig: URLSessionConfiguration = URLSessionConfiguration.default
        
        //타임아웃을 5초로 설정한다.
        sessionConfig.timeoutIntervalForRequest = 5.0
        sessionConfig.timeoutIntervalForResource = 5.0
        
        //캐시 기능을 사용하지 않도록 설정 한다.
        sessionConfig.requestCachePolicy = .reloadIgnoringLocalCacheData
        sessionConfig.urlCache = nil
        
        return sessionConfig
    }
    
    static func requestFlickerList(completFunc: @escaping (FlickerList) -> Void,
                                   errorFunc: @escaping (String) -> Void) {
        
        let url = URL(string: "https://api.flickr.com/services/feeds/photos_public.gne?tags=landscape,portrait&tagmode=any&format=json&nojsoncallback=1")
        let request = URLRequest(url: url!)
        
        //타임아웃 시간을 짧게 변경한다.
        let sessionConfig = getURLSessionConfiguration()
        let session: URLSession = URLSession(configuration: sessionConfig)
        
        //요청을 진행한다.
        let task = session.dataTask(with: request) {(data, response, error) in
            
            DispatchQueue.main.sync {
                guard let data = data, error == nil else {
                    errorFunc("networking error")
                    return
                }
                
                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                    errorFunc("statusCode should be 200, but is \(httpStatus.statusCode)")
                }
                
                do {
                    guard let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] else {
                        errorFunc("json make error")
                        return
                    }
                    
                    let flickerList: FlickerList = FlickerList.init(json: json)
                    completFunc(flickerList)
                    
                } catch {
                    errorFunc("json make error")
                }
            }
        }
        
        task.resume()
    }
    
    static func requestImageDownload(strImageUrl: String,
                                     completFunc: @escaping (Data) -> Void,
                                     errorFunc: @escaping (String) -> Void) {
        
        let url = URL(string: strImageUrl)
        let request = URLRequest(url: url!)
        
        //타임아웃 시간을 짧게 변경한다.
        let sessionConfig = getURLSessionConfiguration()
        let session: URLSession = URLSession(configuration: sessionConfig)
        
        //요청을 진행한다.
        let task = session.dataTask(with: request) {(data, response, error) in
            
            DispatchQueue.main.sync {
                guard let data = data, error == nil else {
                    errorFunc("networking error")
                    return
                }
                
                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                    errorFunc("statusCode should be 200, but is \(httpStatus.statusCode)")
                }
                
                completFunc(data)
            }
        }
        
        task.resume()
    }
}
