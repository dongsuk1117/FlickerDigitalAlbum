//
//  AlbumViewController.swift
//  FlickerDigitalAlbum
//
//  Created by jiran on 25/05/2019.
//  Copyright © 2019 jiran. All rights reserved.
//

import UIKit

class AlbumViewController: UIViewController {

    @IBOutlet weak var backImageView: UIImageView!
    @IBOutlet weak var imageView: UIImageView!
    
    //슬라이드쇼 에서 사용할 객체
    private let slideshowlQueue = DispatchQueue(label: "slideshow")
    
    //슬라이드쇼를 계속 진행할지를 설정하게 하는 BOOL 값
    private var isSlideshow: Bool = true
    var isSlideshowState: Bool {
        get {
            return slideshowlQueue.sync { isSlideshow }
        }
        
        set (newIsSlideshow) {
            slideshowlQueue.sync { isSlideshow = newIsSlideshow }
        }
    }
    
    //슬라이드쇼 쓰레드가 종료되었는지 체크하는 BOOL 값
    private var isSlideshowing: Bool = false
    var isSlideshowingState: Bool {
        get {
            return slideshowlQueue.sync { isSlideshowing }
        }
        
        set (newIsSlideshow) {
            slideshowlQueue.sync { isSlideshowing = newIsSlideshow }
        }
    }
    
    var dataManager: DataManager?
    var nNowCount: Int = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //탭 제스처를 넣는다.
        let taps = UITapGestureRecognizer(target: self, action: #selector(tapGesture))
        self.view.addGestureRecognizer(taps)
        
        //네비게이션 바를 보여준다.
        self.navigationController?.isNavigationBarHidden = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //슬라이드쇼 시작
        self.isSlideshowState = true
        
        //슬라이드 쓰레드가 죽었다면 다시 실행해준다.
        if self.isSlideshowingState == false {
            self.slideshow()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.isSlideshowState = false
    }
    
    func slideshow() {
        DispatchQueue.global().async {
            
            //슬라이드쇼 쓰레드가 살아있다고 설정 한다.
            self.isSlideshowingState = true
            
            //슬라이드쇼 쓰레드를 실행한다.
            while self.isSlideshowState {
                
                //처리 시작 시간을 체크한다.
                let startTime = CFAbsoluteTimeGetCurrent()
                
                //다음 이미지를 위해 1 플러스
                self.nNowCount += 1
                
                //이미지 뷰에 이미지를 넣는다.
                DispatchQueue.main.sync {
                    UIView.transition(with: self.imageView,
                                      duration: 0.25,
                                      options: .transitionCrossDissolve,
                                      animations: {
                                        self.imageView.image = nil
                    },
                                      completion: { (isCompletion: Bool) in
                                        UIView.transition(with: self.imageView,
                                                          duration: 0.25,
                                                          options: .transitionCrossDissolve,
                                                          animations: { self.imageView.image = self.dataManager!.flickerList!.arrFlickerUnit[self.nNowCount].image },
                                                          completion: nil)
                    })
                    
                    UIView.transition(with: self.backImageView,
                                      duration: 0.25,
                                      options: .transitionCrossDissolve,
                                      animations: {
                                        self.backImageView.image = nil
                    },
                                      completion: { (isCompletion: Bool) in
                                        UIView.transition(with: self.backImageView,
                                                          duration: 0.25,
                                                          options: .transitionCrossDissolve,
                                                          animations: { self.backImageView.image = self.dataManager!.flickerList!.arrFlickerUnit[self.nNowCount].image },
                                                          completion: nil)
                    })
                }
                
                //다음 이미지를 가져오거나 새롭게 리스트를 요청한다.
                var isBreakLoop = false
                
                if self.nNowCount == 19 {
                    //이 루프를 탈출 하도록 한다.
                    isBreakLoop = true
                    
                    //초기 이미지 요청
                    self.dataManager!.requestInitFlickerList(completFunc: {
                        
                        //슬라이드쇼 시작
                        self.nNowCount = -1
                        self.slideshow()
                        
                    }, errorFunc: self.requestErrorFunc)
                } else {
                    //이미지를 다운로드 받는다
                    self.dataManager!.downloadImage(strImageUrl: self.dataManager!.flickerList!.arrFlickerUnit[self.nNowCount + 1].strM,
                                                    completFunc: { (image: UIImage) in
                                                        
                                                        //메인 쓰레드로 값을 넣어준다.
                                                        DispatchQueue.main.async {
                                                            self.dataManager!.flickerList!.arrFlickerUnit[self.nNowCount + 1].image = image
                                                            self.requestCompletFunc()
                                                        }
                    },
                                                    errorFunc: {
                                                        
                                                        //메인 쓰레드로 에러를 불러준다.
                                                        DispatchQueue.main.async {
                                                            self.requestErrorFunc()
                                                        }
                    })
                }
                
                //루프 탈출인지 확인 한다.
                if isBreakLoop {
                    break
                } else {
                    //화면 전환 시간동안 슬립해준다.
                    Thread.sleep(forTimeInterval: 0.5)
                    
                    //처리 완료후 시간을 체크한다.
                    let timeElapsed: Double = CFAbsoluteTimeGetCurrent() - startTime
                    
                    //설정된 목표 시간을 가지고 온다.
                    let sleepTime: Double = Double(DataManager.getAlbumImageTime()) + 0.5 - timeElapsed
                    
                    //두 시간차가 0보다 작으면 바로 다음 이미지를 진행하고, 시간이 남는다면 남는시간동안 쉰다.
                    if sleepTime > 0 {
                        Thread.sleep(forTimeInterval: sleepTime)
                    }
                }
            }
            
            //슬라이드쇼 쓰레드가 끝났다고 설정 한다.
            self.isSlideshowingState = false
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
    
    @objc func tapGesture(recognizer: UITapGestureRecognizer) {
        //네비게이션 바를 숨키거나 보여준다.
        self.navigationController?.setNavigationBarHidden(!self.navigationController!.isNavigationBarHidden,
                                                          animated: true)
    }
}
