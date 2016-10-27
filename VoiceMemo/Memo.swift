//
//  Memo.swift
//  VoiceMemo
//
//  Created by Joey on 27/10/2016.
//  Copyright © 2016 Treehouse Island, Inc. All rights reserved.
//

import Foundation
import CloudKit

struct Memo {
    
    static let entityName = "\(Memo.self)"
    
    let id: CKRecordID?
    let title: String
    let fileUrlString: String
    
}

extension Memo {
    
    var persistableRecord: CKRecord {
        
        let record = CKRecord(recordType: Memo.entityName)
        record.setValue(title, forKey: "title")
        
        let asset = CKAsset(fileURL: fileUrl)
        record.setValue(asset, forKey: "recording")
        
        return record
    }
    
    var fileUrl: URL {
        return URL(fileURLWithPath: fileUrlString)
    }
    
    var track: Data? {
        
        var data = Data()
        
        do {
            data = try Data(contentsOf: fileUrl)
            
        }catch let error {
            print(error)
        }
        
        return data
    }
    
    init?(record: CKRecord) {
        
        guard let title = record.value(forKey: "title") as? String, let asset = record.value(forKey: "recording") as? CKAsset else {
            
            return nil
        }
        
        self.id = record.recordID
        self.title = title
        self.fileUrlString = asset.fileURL.absoluteString
    }
}
