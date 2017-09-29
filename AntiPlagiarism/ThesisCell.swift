//
//  ThesisCell.swift
//  AntiPlagiarism
//
//  Created by Tran Bao Toan on 9/27/17.
//  Copyright © 2017 POS. All rights reserved.
//

import UIKit

class ThesisCell: UITableViewCell {

    /*OUTLETS*/
    
    @IBOutlet weak var uvLast: UIView!
    @IBOutlet weak var uvFirst: UIView!
    @IBOutlet weak var lbDate: UILabel!
    @IBOutlet weak var lbTime: UILabel!
    @IBOutlet weak var lbStudentName: UILabel!
    @IBOutlet weak var lbCollege: UILabel!
    @IBOutlet weak var lbThesisName: UILabel!
    @IBOutlet weak var uvDateTime: UIView!
    @IBOutlet weak var imgName: UIButton!
    
    /*ACTIONS*/
    
    var thesis: String! {
        didSet{
            self.updateUI()
        }
    }
    
    override func prepareForReuse() {
            super.prepareForReuse()
        
    }
    
    func updateUI(){
        imgName.setTitle(thesis, for: .normal)
        let randomNum = Utils.random(max: Constants.COLOR.ARRAY.count)
        let randomColor:String = Constants.COLOR.ARRAY[randomNum]
        imgName.backgroundColor = UIColor.init(hex: randomColor)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
