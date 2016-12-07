//
//  MeetingViewCell.swift
//  auto_scheduler
//
//  Created by macbook_user on 12/6/16.
//
//
import AddressBook
import Contacts
import UIKit

class MeetingViewCell: UITableViewCell {
    
    @IBOutlet weak var titleName: UILabel!
    @IBOutlet weak var ownerName: UILabel!
    
    @IBOutlet weak var Location: UILabel!
    
    var meetingId = "1"
}
