//
//  SecondViewController.swift
//  LocationChallange
//
//  Created by Sanchit Mittal on 17/10/17.
//  Copyright © 2017 Sanchit Mittal. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    var winnersRecords: [String:Int] = [String: Int]()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.reloadData()
        winnersRecords =  (UserDefaults.standard.dictionary(forKey: "winnersRecord") != nil) ? UserDefaults.standard.dictionary(forKey: "winnersRecord") as! [String : Int] : [String: Int]()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return winnersRecords.count
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Winners"
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SecondViewControllerCellIdentifier", for: indexPath)
        let key = Array(winnersRecords.keys)[indexPath.row]
        cell.textLabel?.text = key
        cell.detailTextLabel?.text = winnersRecords[key]?.description
        return cell
    }
}
