//
//  LodingViewController.swift
//  FlickerDigitalAlbum
//
//  Created by jiran on 26/05/2019.
//  Copyright © 2019 jiran. All rights reserved.
//

import UIKit

class LodingViewController: UIViewController {

    var dataManager: DataManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //데이터 저장 클레스를 만듭니다.
        dataManager = DataManager()
        
        //초기 엘범 이미지를 불러옵니다.
        dataManager!.requestInitFlickerList(completFunc: requestCompletFunc, errorFunc: requestErrorFunc)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        //메인 화면으로 이동할때 데이터 저장 클레스를 옮겨 줍니다.
        if segue.identifier == "ShowMainView" {
            guard let mainViewController: MainViewController = segue.destination as? MainViewController else { return }
            mainViewController.dataManager = dataManager
        }
    }
    
    func requestCompletFunc() {
        
        //메인 화면으로 이동 합니다.
        self.performSegue(withIdentifier: "ShowMainView", sender: nil)
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
            self.exitApplication()
        }
        
        //버튼을 넣는다.
        alert.addAction(retryAction)
        alert.addAction(noAction)
        
        //알럿을 보여준다.
        present(alert, animated: true, completion: nil)
    }
    
    func exitApplication() {
        
        let alert = UIAlertController(title: "알림",
                                      message: "초기 통신에 실패하여\n어플리케이션을 종료 합니다.",
                                      preferredStyle: .alert)
        
        let noAction = UIAlertAction(title: "확인", style: .default) { (UIAlertAction) in
            exit(0)
        }
        
        alert.addAction(noAction)
        present(alert, animated: true, completion: nil)
    }
}
