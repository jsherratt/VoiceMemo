//
//  TableViewDataSource.swift
//  VoiceMemo
//
//  Created by Joey on 27/10/2016.
//  Copyright © 2016 Treehouse Island, Inc. All rights reserved.
//

import Foundation
import UIKit

class TableViewDataSource: NSObject, UITableViewDataSource {
    
    let tableView: UITableView
    var results: [Memo]
    
    init(tableView: UITableView, results: [Memo]) {
        
        self.tableView = tableView
        self.results = results
        
        super.init()
        
        self.tableView.dataSource = self
    }
    
    func objectAtIndexPath(indexPath: IndexPath) -> Memo {
        
        return results[indexPath.row]
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: MemoCell.reuseIdentifier!, for: indexPath)
        
        let memo = results[indexPath.row]
        cell.textLabel?.text = memo.title
        
        return cell
    }
}

extension TableViewDataSource: DataProviderDelegate {
    
    func processUpdates(updates: [DataProviderUpdate<Memo>]) {
        
        tableView.beginUpdates()
        
        for (index, update) in updates.enumerated() {
            
            switch update {
            
            case .Insert(let memo):
                
                results.insert(memo, at: index)
                let indexPath = IndexPath(row: index, section: 0)
                tableView.insertRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
            }
        }
        
        tableView.endUpdates()
    }
    
    func providerFailedWithError(error: MemoErrorType) {
        print("Provider failed with error \(error.description)")
    }
}