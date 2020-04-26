//
//  SearchResultViewController.swift
//  NewsApp
//
//  Created by 潘一帆 on 2020/4/25.
//  Copyright © 2020 Yifan. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class SearchResultViewController: UITableViewController {
    var searchResults = [String]()
    var text: String = ""
    var selectedQuery: String = ""
    var nav: UINavigationController!
    
    override func viewDidLoad() {
        self.tableView.register(SearchCell.self, forCellReuseIdentifier: "SearchCell")
        self.tableView.tableFooterView = UIView()
    }
    
    @objc func getResults() {
        print("query: \(self.text)")
        if(self.text.count >= 3) {
            getResultsandReloadTable(query: self.text)
        }
    }
    
    func getResultsandReloadTable(query: String) {
        self.searchResults = [String]()
        let url = "https://yifan-pan.cognitiveservices.azure.com/bing/v7.0/suggestions"
        let headers: HTTPHeaders = [
            "Ocp-Apim-Subscription-Key": "4954b94809bc44f591bde5a8b837e52b"
        ]
        AF.request(url, parameters: ["mkt": "en-US", "q": query], headers: headers).responseJSON {
            response in
            switch response.result {
            case .success:
                do {
                    let data = try JSON(data: response.data!)
                    for (_, result):(String, JSON) in data["suggestionGroups"][0]["searchSuggestions"] {
                        self.searchResults.append(result["displayText"].stringValue)
                    }
                    self.tableView.reloadData()
                } catch {
                    print("can't convert to json")
                }
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(searchResults[indexPath.row])
        self.selectedQuery = searchResults[indexPath.row]
        NotificationCenter.default.post(name: Constants.showSearchResultPage, object: nil)
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchCell") as! SearchCell
        cell.textLabel?.text = searchResults[indexPath.row]
        return cell
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if let vc = segue.destination as? SearchViewController {
//            vc.query = self.selectedQuery
//        }
//    }

}

extension SearchResultViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if(searchController.searchBar.text != nil) {
            self.text = searchController.searchBar.text!
            print("text: \(self.text)")
            if(self.text.count >= 3) {
                NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.getResults), object: nil)
                self.perform(#selector(self.getResults), with: nil, afterDelay: 0.5)
            }
        }
    }
}
