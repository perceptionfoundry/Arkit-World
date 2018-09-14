//
//  DashboardVC.swift
//  ArtWork AR
//
//  Created by Syed ShahRukh Haider on 06/11/2017.
//  Copyright © 2017 Syed ShahRukh Haider. All rights reserved.
//

import UIKit

class DashboardVC: UIViewController,UITableViewDataSource,UITableViewDelegate {

    
    @IBOutlet weak var contentTable: UITableView!
    
    
    var checkArray = ["nick","john","david"]
    override func viewDidLoad() {
        super.viewDidLoad()

    contentTable.delegate = self
    contentTable.dataSource = self
    }

  
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return checkArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Dash-Cell") as! dashboardCell
        
        cell.titleLabel.text = checkArray[indexPath.row]
        return cell
    }
    

  

}
