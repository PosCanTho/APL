//
//  ThesisController.swift
//  AntiPlagiarism
//
//  Created by Tran Bao Toan on 9/26/17.
//  Copyright © 2017 POS. All rights reserved.
//

import UIKit

class ThesisController: UIViewController {

    @IBOutlet weak var tbvThesis: UITableView!
    
    var thesis:[String] = []
    
    lazy var searchBar:UISearchBar = UISearchBar()
    
    struct TABLEVIEW {
       static let CELL:String = "ThesisCell"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboard()
        
        for i in 0...10 {
            thesis.append(String(i))
        }
        initSearchBar()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(_ animated: Bool) {
         self.tabBarController?.navigationItem.title = "Home"
        let textAttributes = [NSForegroundColorAttributeName:UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
    }
    
}

extension ThesisController: UISearchBarDelegate {
    
    func initSearchBar(){
        searchBar.searchBarStyle = UISearchBarStyle.minimal
        searchBar.placeholder = " Search..."
        searchBar.sizeToFit()
        //searchBar.backgroundImage = UIImage()
        searchBar.delegate = self
        tbvThesis.tableHeaderView = searchBar
        let sv:CGPoint = CGPoint(x: 0, y: 44)
        tbvThesis.setContentOffset(sv, animated: true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange textSearched: String)
    {
        //print(textSearched)
        
        thesis = thesis.filter({ (mod) -> Bool in
            return mod.contains(textSearched)
        })
        self.tbvThesis.reloadData()
    }
}

extension ThesisController:UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return thesis.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TABLEVIEW.CELL, for: indexPath) as! ThesisCell
        cell.thesis = thesis[indexPath.row]
        reUseCell(cell: cell, indexPath: indexPath)

        return cell
    }
    
    func reUseCell(cell: ThesisCell, indexPath: IndexPath) {
        
        if indexPath.row == 0 {
            cell.uvFirst.isHidden = true
        } else {
            cell.uvFirst.isHidden = false
        }
        if indexPath.row == (thesis.count - 1) {
            cell.uvLast.isHidden = true
        } else {
            cell.uvLast.isHidden = false
        }
        if indexPath.row == 5 {
            cell.uvDateTime.backgroundColor = UIColor(hex: Constants.COLOR.RED)
            cell.lbDate.textColor = UIColor.white
            cell.lbTime.textColor = UIColor.white
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
    
}
