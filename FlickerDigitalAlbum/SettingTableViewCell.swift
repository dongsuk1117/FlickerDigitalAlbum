//
//  SettingTableViewCell.swift
//  FlickerDigitalAlbum
//
//  Created by jiran on 27/05/2019.
//  Copyright © 2019 jiran. All rights reserved.
//

import UIKit

class SettingTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var timeSlider: UISlider!
    
    var changeEvent: ((Int) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setInfo(strTitle: String, nTime: Int, changeEvent: @escaping (Int) -> Void) {
        titleLabel.text = strTitle
        timeLabel.text = "\(nTime) 초"
        self.timeSlider.setValue(Float(nTime), animated: false)
        self.changeEvent = changeEvent
    }

    @IBAction func sliderUpEvent(_ sender: Any) {
        let nChangeValue: Int = Int(self.timeSlider.value)
        timeLabel.text = "\(nChangeValue) 초"
        self.changeEvent!(nChangeValue)
    }
    
}
