//
//  DownloadTask.swift
//  DispatchGroup
//
//  Created by Alfian Losari on 25/05/19.
//  Copyright © 2019 alfianlosari. All rights reserved.
//

import Foundation

class DownloadTask {
    
    var progress: Int = 0
    let identifier: String
    let stateUpdateHandler: (DownloadTask) -> ()
    var state = TaskState.pending {
        didSet {
            self.stateUpdateHandler(self)
        }
    }
    
    init(identifier: String, stateUpdateHandler: @escaping (DownloadTask) -> ()) {
        self.identifier = identifier
        self.stateUpdateHandler = stateUpdateHandler
    }
    
    func startTask(queue: DispatchQueue, group: DispatchGroup, semaphore: DispatchSemaphore, randomizeTime: Bool = true) {
        queue.async(group: group) { [weak self] in
            group.enter()
            semaphore.wait()
            self?.state = .inProgess(5)
            self?.startSleep(randomizeTime: randomizeTime)
            self?.state = .inProgess(20)
            self?.startSleep(randomizeTime: randomizeTime)
            self?.state = .inProgess(40)
            self?.startSleep(randomizeTime: randomizeTime)
            self?.state = .inProgess(60)
            self?.startSleep(randomizeTime: randomizeTime)
            self?.state = .inProgess(80)
            self?.startSleep(randomizeTime: randomizeTime)
            self?.state = .completed
            group.leave()
            semaphore.signal()
        }
    }
    
    private func startSleep(randomizeTime: Bool = true) {
        Thread.sleep(forTimeInterval: randomizeTime ? Double(Int.random(in: 1...3)) : 1.0)

    }
}

enum TaskState {
    
    case pending
    case inProgess(Int)
    case completed
    
    var description: String {
        switch self {
        case .pending:
            return "Pending"
            
        case .inProgess(_):
            return "Downloading"
            
        case .completed:
            return "Completed"
            
        }
    
    }
}

extension Array where Element == DownloadTask {
    
    func downloadTaskWith(identifier: String) -> DownloadTask? {
        return self.first { $0.identifier == identifier }
    }
    
    func indexOfTaskWith(identifier: String) -> Int? {
        return self.firstIndex { $0.identifier == identifier }
    }
}

