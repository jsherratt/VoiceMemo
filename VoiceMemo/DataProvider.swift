//
//  DataProvider.swift
//  VoiceMemo
//
//  Created by Joey on 27/10/2016.
//  Copyright © 2016 Treehouse Island, Inc. All rights reserved.
//

import Foundation
import CloudKit

protocol DataProviderDelegate: class {
    
    func processUpdates(updates: [DataProviderUpdate<Memo>])
    func providerFailedWithError(error: MemoErrorType)
}

enum DataProviderUpdate<T> {
    
    case Insert(T)
}

class DataProvider {
    
    let manager = CloudPersistenceManager()
    var updates = [DataProviderUpdate<Memo>]()
    
    fileprivate weak var delegate: DataProviderDelegate?
    
    init(delegate: DataProviderDelegate?) {
        
        self.delegate = delegate
    }
    
    func performQuery(type: QueryType) {
        
        manager.performQuery(query: type.query) { result in
            
            self.processResult(result: result)
        }
    }
    
    func fetch(recordID id: CKRecordID) {
        
        manager.fetch(recordID: id) { result in
            
            self.processResult(result: result)
        }
    }
    
    func save(memo: Memo) {
        
        manager.saveMemo(memo: memo){ result in
            
            self.processResult(result: result)
        }
    }
    
    fileprivate func processResult(result: Result<[Memo]>) {
        
        DispatchQueue.main.async {
            
            switch result {
                
            case .Success(let memos):
                
                self.updates = memos.map { DataProviderUpdate.Insert($0) }
                self.delegate?.processUpdates(updates: self.updates)
                
            case .Failure(let error):
                self.delegate?.providerFailedWithError(error: error)
            }
        }
    }
    
    fileprivate func processResult(result: Result<Memo>) {
        
        DispatchQueue.main.async {
            
            switch result {
                
            case .Success(let memo):
                
                self.updates = [DataProviderUpdate.Insert(memo)]
                self.delegate?.processUpdates(updates: self.updates)
                
            case .Failure(let error):
                self.delegate?.providerFailedWithError(error: error)
            }
        }
    }
}
