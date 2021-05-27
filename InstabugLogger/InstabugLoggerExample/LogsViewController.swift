//
//  LogsViewController.swift
//  InstabugLoggerExample
//
//  Created by Mohamed Khalid on 27/05/2021.
//

import UIKit
import InstabugLogger

class LogsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var logs: [LogElement]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    
}

extension LogsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return logs?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "logCell", for: indexPath)
        cell.textLabel?.text = String(logs?[indexPath.row].level ?? 0) + ". " + (logs?[indexPath.row].message!)!
        return cell
    }
    
    
}
