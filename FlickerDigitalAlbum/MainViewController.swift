//
//  MainViewController.swift
//  FlickerDigitalAlbum
//
//  Created by jiran on 25/05/2019.
//  Copyright © 2019 jiran. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    var dataManager: DataManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        //설정 화면으로 이동할때 데이터 저장 클레스를 옮겨 줍니다.
        if segue.identifier == "ShowSettingView" {
            guard let settingViewController: SettingViewController = segue.destination as? SettingViewController else { return }
            settingViewController.dataManager = dataManager
        }
        
        //엘범 화면으로 이동할때 데이터 저장 클레스를 옮겨 줍니다.
        if segue.identifier == "ShowAlbumView" {
            guard let albumViewController: AlbumViewController = segue.destination as? AlbumViewController else { return }
            albumViewController.dataManager = dataManager
        }
    }

}
