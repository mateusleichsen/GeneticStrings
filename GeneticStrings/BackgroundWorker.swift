//
//  BackgroundWorker.swift
//  GeneticStrings
//
//  Created by Mateus Leichsenring on 01.09.18.
//  Copyright © 2018 Mateus Leichsenring. All rights reserved.
//

import Foundation

class BackgroundWorker {
    var doWork:() -> Void = {}
    var workCompleted:(_ result:Any?) -> Void = { result in }
    var progressChanged:(_ progress:Any) -> Void = { result in }
    var result:Any?
    var isRunning:Bool = false
    var isCancelled:Bool = false
    private var workThread:DispatchWorkItem!
    
    init() {
    }
    
    func start() {
        if self.isRunning { return }
        workThread = DispatchWorkItem {
            self.doWork()
            DispatchQueue.main.async {
                self.workCompleted(self.result)
                self.isRunning = false
                self.isCancelled = false
            }
        }
        DispatchQueue.global(qos: .background).async(execute: workThread!)
        self.isRunning = true
    }
    
    func cancel() {
        if workThread.isCancelled {
            return
        }
        workThread.cancel()
        self.isCancelled = true
        self.isRunning = false
    }
    
    func reportProgress(_ progress:Any) {
        DispatchQueue.main.async {
            self.progressChanged(progress)
        }
    }
}
