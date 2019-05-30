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
    
    private var isSlideshow: Bool = false
    private var isSlideshowing: Bool = false
    
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
        
        //슬라이드쇼 시작
        self.showNextImage()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //슬라이드쇼 시작
        self.isSlideshow = true

        //슬라이드가 멈추었다면 시작해준다.
        if self.isSlideshowing == false {
            self.showNextImage()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.isSlideshow = false
    }
    
    func showNextImage() {
        
        //슬라이드쇼를 진행 하고 있다고 설정
        isSlideshowing = true
        
        //다음 이미지를 위해 1 플러스
        self.nNowCount += 1
        
        //이미지 뷰에 이미지를 넣는다.
        showImage(image: self.dataManager!.flickerList!.arrFlickerUnit[self.nNowCount].image!)
    }
    
    func requestNextImage() {
        
        //처리 시작 시간을 체크한다.
        let startTime = CFAbsoluteTimeGetCurrent()
        
        //다음 이미지를 가져오거나 새롭게 리스트를 요청한다.
        if self.nNowCount == 19 {
            
            //초기 이미지 요청
            self.dataManager!.requestInitFlickerList(completFunc: {
                
                //슬라이드쇼 시작
                self.nNowCount = -1
                self.requestCompletFunc(startTime: startTime)
                
            }, errorFunc: {
                
                //에러 함수를 불러준다.
                self.isSlideshowing = false
                self.nNowCount -= 1
                self.requestErrorFunc()
            })
        } else {
            //이미지를 다운로드 받는다
            self.dataManager!.downloadImage(strImageUrl: self.dataManager!.flickerList!.arrFlickerUnit[self.nNowCount + 1].strM,
                                            completFunc: { (image: UIImage) in
                                                
                                                self.dataManager!.flickerList!.arrFlickerUnit[self.nNowCount + 1].image = image
                                                self.requestCompletFunc(startTime: startTime)
                                                
            },
                                            errorFunc: {
                                                
                                                //에러 함수를 불러준다.
                                                self.isSlideshowing = false
                                                self.nNowCount -= 1
                                                self.requestErrorFunc()
            })
        }
    }
    
    func requestCompletFunc(startTime: CFAbsoluteTime) {
        
        //처리 완료후 시간을 체크한다.
        let timeElapsed: Double = CFAbsoluteTimeGetCurrent() - startTime
        
        //설정된 목표 시간을 가지고 온다.
        let sleepTime: Double = Double(DataManager.getAlbumImageTime()) - timeElapsed
        
        //두 시간차가 0보다 작으면 바로 다음 이미지를 진행하고, 시간이 남는다면 남는시간동안 쉰다.
        if sleepTime > 0 {
            DispatchQueue.global().async {
                Thread.sleep(forTimeInterval: sleepTime)
                
                DispatchQueue.main.async {
                    
                    if self.isSlideshow {
                        self.showNextImage()
                    } else {
                        self.isSlideshowing = false
                    }
                    
                }
            }
        } else {
            if self.isSlideshow {
                self.showNextImage()
            } else {
                self.isSlideshowing = false
            }
        }
    }
    
    func requestErrorFunc() {
        
        //에러 출력 후 사용자에게 재시도 여부를 물어 봅니다.
        let alert = UIAlertController(title: "알림",
                                      message: "통신에 실패하였습니다.\n다시 요청 하시겠습니까?",
                                      preferredStyle: .alert)
        
        //버튼을 만든다.
        let retryAction = UIAlertAction(title: "재시도", style: .default) { (UIAlertAction) in
            //슬라이드쇼 시작
            self.requestNextImage()
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
    
    func showImage(image: UIImage) {
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
                                              animations: { self.backImageView.image = image },
                                              completion: nil)
        })
        
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
                                              animations: { self.imageView.image = image },
                                              completion: { (finished: Bool) in
                                                self.requestNextImage()
                            })
        })
    }
    
    @objc func tapGesture(recognizer: UITapGestureRecognizer) {
        //네비게이션 바를 숨키거나 보여준다.
        self.navigationController?.setNavigationBarHidden(!self.navigationController!.isNavigationBarHidden,
                                                          animated: true)
    }
}
