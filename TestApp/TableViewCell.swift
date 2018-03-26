//
//  TableViewCell.swift
//  TestApp
//
//  Created by Rohini on 23/03/18.
//  Copyright © 2018 Rohini. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell
{

    @IBOutlet weak var titleLbl: UILabel! //Cell variable for display title
    @IBOutlet weak var discTextview: UITextView! // Cell variable for display Description
    @IBOutlet var imageHrefView: UIImageView! // Cell variable for display images
    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
