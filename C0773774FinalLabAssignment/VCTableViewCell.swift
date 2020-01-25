//
//  DetailTableViewCell.swift
//  C0773774Assignment2
//
//  Created by Nitin on 19/01/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

class VCTableViewCell: UITableViewCell {
    
    // MARK: - Proprties
    static var reuseId: String {
        return String(describing: self)
    }
    
    @IBOutlet var idLabl: UILabel!
    @IBOutlet var titleLbl: UILabel!
    
    @IBOutlet var priceLbl: UILabel!
 
    @IBOutlet var descrLbl: UILabel!
    
    var task: Tasks? {
        didSet {
            guard let task = task else { return }
            titleLbl.text = task.productName
            idLabl.text = task.productId
            priceLbl.text = task.productPrice
            descrLbl.text = task.productDes
          
        }
    }
    
    static var cellHeight: CGFloat {
        return 100.0
    }
    
    // MARK: - Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
