//
//  SearchViewController.swift
//  mapkitDemo5_cab
//
//  Created by Third Rock Techkno on 19/03/20.
//  Copyright © 2020 Third Rock Techkno. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class SearchViewController: UIViewController {

    var forLocationNo = 0
    @IBOutlet weak var tableView: UITableView!
    var searchCompleter = MKLocalSearchCompleter()
    var searchResults = [MKLocalSearchCompletion]()
    var searchController: UISearchController!
    override func viewWillAppear(_ animated: Bool) {
        dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        searchCompleter.delegate = self
        searchCompleter.region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 23.0335751, longitude: 72.5557826), latitudinalMeters: 1500, longitudinalMeters: 1500)
        
        configTableView()
        
    }
    
    @IBAction func searchButtonClicked(_ sender: UIBarButtonItem) {
        
        searchController = UISearchController(searchResultsController: nil)
        searchController?.hidesNavigationBarDuringPresentation = false
        searchController?.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        present(searchController, animated: true)
        
    }

    func configTableView() {
        
        tableView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        tableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    

}


extension SearchViewController: MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        searchResults = completer.results
        tableView.reloadData()
    }
}

extension SearchViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchCompleter.queryFragment = searchText
    }
    
}

extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        dismiss(animated: true, completion: nil)
        
        
        let completion = searchResults[indexPath.row]
        let searchRequest = MKLocalSearch.Request(completion: completion)
        let search = MKLocalSearch(request: searchRequest)
        search.start { (response, error) in

            guard let vc = self.navigationController?.viewControllers[(self.navigationController?.viewControllers.count)! - 2] as? ViewController else{return}
            
            if self.forLocationNo == 1 {
                vc.textFieldLocation1.text = self.searchResults[indexPath.row].subtitle
                vc.coordinate1 = (response?.mapItems.first?.placemark.coordinate)!
            }
            else if self.forLocationNo == 2 {
                vc.textFieldLocation2.text = self.searchResults[indexPath.row].subtitle
                vc.coordinate1 = (response?.mapItems.first?.placemark.coordinate)!
            }

            self.searchResults = []
            self.navigationController?.popViewController(animated: true)
        
        
        }
    }
}

extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        cell.titleLabel.text = searchResults[indexPath.row].title
        cell.subtitleLabel.text = searchResults[indexPath.row].subtitle
        return cell
    }
    
    
}
