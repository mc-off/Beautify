//
//  MasterCreationViewController.swift
//  Beautify
//
//  Created by Артем Маков on 01.03.2021.
//  Copyright © 2021 mcoff. All rights reserved.
//

import UIKit

class MastersTabViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    let searchController = UISearchController()
    let vm               = MasterListViewModel()
    var filtred          = [MasterListViewModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        initVM()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        initVM()
    }
    
    private func initView() {
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationItem.searchController = searchController
        searchController.dimsBackgroundDuringPresentation = true
        searchController.searchResultsUpdater = self
        searchController.delegate = self
        tableView.register(UINib(nibName: "MasterTableViewCell", bundle: nil), forCellReuseIdentifier: "MasterTableViewCell")
    }
    
    
    
    private func initVM() {
        vm.reloadTableViewClosure = { [weak self] in
            guard let self = self else { return }
            if self.vm.numberOfCells == 0 {
                self.tableView.alpha = 0
            } else {
                self.tableView.reloadData()
                UIView.animate(withDuration: 0.2) {
                    self.tableView.alpha = 1
                }
            }
        }
        vm.initFetch()
    }
    
}

extension MastersTabViewController: UITableViewDataSource, UITableViewDelegate  {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
         return 166 // custom height
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vm.numberOfCells
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MasterTableViewCell", for: indexPath) as! MasterTableViewCell

        cell.cellVM = vm.getCellViewModel(at: indexPath)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        vm.pressedCell(at: indexPath)
        performSegue(withIdentifier: "masterCard", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "masterCard" {
            let vc = segue.destination as! MasterCardViewController
            vc.masterTitle = vm.selectedCell!.name!
            vc.masterType = vm.selectedCell!.type!
            vc.uid  = vm.selectedCell!.uid!
        }
    }
}


extension MastersTabViewController: UISearchControllerDelegate, UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let text = searchController.searchBar.text?.lowercased()
        vm.searchAbout(text: text!)
        
    }
    
    func presentSearchController(_ searchController: UISearchController) {
        vm.startSearching()
    }
    
    func didDismissSearchController(_ searchController: UISearchController) {
        vm.endSearching()
    }
    
}
