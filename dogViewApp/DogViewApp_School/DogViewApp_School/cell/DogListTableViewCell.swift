//
//  DogListTableViewCell.swift
//  DogViewApp_School
//
//  Created by user on 2023/09/12.
//

import UIKit

class DogListTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var dogName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
