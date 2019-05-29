//
//  AlbumDataManager.swift
//  FlickerDigitalAlbum
//
//  Created by jiran on 26/05/2019.
//  Copyright © 2019 jiran. All rights reserved.
//

import UIKit

class DataManager: NSObject {
    
    var flickerList: FlickerList?
    var completFunc: (() -> Void)?
    var errorFunc: (() -> Void)?
    
    //엘범 이미지 시간 함수
    static func setAlbumImageTime(nTime: Int) {
        var dicMyData: [String: Any]  = UserDefaults.standard.dictionary(forKey: "my_user_data_key") ?? [:]
        dicMyData.updateValue(nTime, forKey: "album_image_time")
        UserDefaults.standard.set(dicMyData, forKey: "my_user_data_key")
    }
    
    static func getAlbumImageTime() -> Int {
        var dicMyData: [String: Any]  = UserDefaults.standard.dictionary(forKey: "my_user_data_key") ?? [:]
        guard let nAlbumImageTime: Int = dicMyData["album_image_time"] as? Int else { return 1 }
        return nAlbumImageTime
    }
    
    //이미지 리스트 초기화 요청 함수
    func requestInitFlickerList(completFunc: @escaping () -> Void, errorFunc: @escaping () -> Void) {
        self.completFunc = completFunc
        self.errorFunc = errorFunc
        HttpUtil.requestFlickerList(completFunc: requestInitCompletFunc,
                                    errorFunc: requestErrorFunc)
    }
    
    //초기화 요청 함수 완료 함수
    func requestInitCompletFunc(flickerList: FlickerList) {
        
        //리스트를 저장 한다.
        self.flickerList = flickerList

        //첫번째 이미지를 요청 한다.
        self.downloadImage(strImageUrl: self.flickerList!.arrFlickerUnit[0].strM,
                           completFunc: { (image: UIImage) in
                            self.flickerList!.arrFlickerUnit[0].image = image
                            self.completFunc!()
        },
                           errorFunc: {
                            self.errorFunc!()
        })
    }
    
    //요청 에러 함수
    func requestErrorFunc(strErrorMessage: String) {
        print(strErrorMessage)
        self.errorFunc!()
    }
    
    //이미지 다운로드 함수
    func downloadImage(strImageUrl: String,
                       completFunc: @escaping (UIImage) -> Void,
                       errorFunc: @escaping () -> Void) {
        
        HttpUtil.requestImageDownload(strImageUrl: strImageUrl,
                                      completFunc: { (data: Data) in
                                        
                                        let image: UIImage = UIImage(data: data)!
                                        completFunc(image)
                                        
        }, errorFunc: { (strErrorMessage: String) in
            errorFunc()
        })
    }
}
