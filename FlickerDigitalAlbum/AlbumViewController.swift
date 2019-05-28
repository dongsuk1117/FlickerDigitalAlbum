//
//  AlbumViewController.swift
//  FlickerDigitalAlbum
//
//  Created by jiran on 25/05/2019.
//  Copyright © 2019 jiran. All rights reserved.
//

import UIKit

class AlbumViewController: UIViewController {

    @IBOutlet weak var mImageView1: UIImageView!
    
    var dataManager: DataManager?
    var timer: Timer?
    var nNowCount: Int = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //네비게이션 바를 보여준다.
        self.navigationController?.isNavigationBarHidden = false
        
        //1번째 이미지를 로딩한다.
        nextImage()
        
        //타이머를 진행한다.
        self.startTimer()
    }
    
    //타이머를 진행한다.
    func startTimer() {
        self.timer = Timer.scheduledTimer(withTimeInterval: TimeInterval(DataManager.getAlbumImageTime()),
                                          repeats: true,
                                          block: { timer in
                                            self.nextImage()
        })
    }
    
    func nextImage() {
        //다음 이미지를 위해 1 플러스
        nNowCount += 1
        
        //이미지 뷰에 이미지를 넣는다.
        self.mImageView1.image = dataManager!.flickerList!.arrFlickerUnit[nNowCount].image
        
        if nNowCount == 19 {
            //마지막 이미지인 경우 새로 요청을 진행 한다.
            //타이머를 정지 한다.
            self.timer!.invalidate()
            self.timer = nil
            
            //초기 이미지 요청
            dataManager!.requestInitFlickerList(completFunc: {
                //타이머를 진행한다.
                self.nNowCount = -1
                self.startTimer()
            }, errorFunc: requestErrorFunc)
        } else {
            //다음 이미지를 요청해 둔다.
            self.dataManager!.downloadImage(strImageUrl: self.dataManager!.flickerList!.arrFlickerUnit[nNowCount + 1].strM,
                                           completFunc: { (image: UIImage) in
                                            self.dataManager!.flickerList!.arrFlickerUnit[self.nNowCount + 1].image = image
                                            self.requestCompletFunc()
            },
                                           errorFunc: {
                                            self.requestErrorFunc()
            })
        }
    }
    
    func requestCompletFunc() {
        
    }
    
    func requestErrorFunc() {
        
        //에러 출력 후 사용자에게 재시도 여부를 물어 봅니다.
        let alert = UIAlertController(title: "알림",
                                      message: "통신에 실패하였습니다.\n다시 요청 하시겠습니까?",
                                      preferredStyle: .alert)
        
        //버튼을 만든다.
        let retryAction = UIAlertAction(title: "재시도", style: .default) { (UIAlertAction) in
            self.dataManager!.requestInitFlickerList(completFunc: self.requestCompletFunc, errorFunc: self.requestErrorFunc)
        }
        let noAction = UIAlertAction(title: "취소", style: .default) { (UIAlertAction) in
            self.showMainViewAlert()
        }
        
        //버튼을 넣는다.
        alert.addAction(retryAction)
        alert.addAction(noAction)
        
        //알럿을 보여준다.
        present(alert, animated: true, completion: nil)
    }
    
    func showMainViewAlert() {
        
        let alert = UIAlertController(title: "알림",
                                      message: "메인 화면으로 이동합니다.",
                                      preferredStyle: .alert)
        
        let noAction = UIAlertAction(title: "확인", style: .default) { (UIAlertAction) in
            self.navigationController?.popViewController(animated: true)
        }
        
        alert.addAction(noAction)
        present(alert, animated: true, completion: nil)
    }
}
