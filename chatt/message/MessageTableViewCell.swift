//
//  MessageTableViewCell.swift
//  chatt
//
//  Created by SoftSuave on 21/04/22.
//

import UIKit

class MessageTableViewCell: UITableViewCell {

 
    @IBOutlet weak var namelbl: UILabel!
    @IBOutlet weak var textlbl: UILabel!
    @IBOutlet weak var personimg: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
       
    }
    func time(){
        let date = Date()
        let formatter = DateFormatter()
        //formatter.dateStyle = .medium
        formatter.timeStyle = .medium
        let time = formatter.string(from: date)
        
           }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
