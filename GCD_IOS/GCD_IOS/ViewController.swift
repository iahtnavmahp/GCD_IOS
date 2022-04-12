//
//  ViewController.swift
//  GCD_IOS
//
//  Created by Pham Van Thai on 12/04/2022.
//

import UIKit

class ViewController: UIViewController {
    let urlImg = ["https://cdnmedia.webthethao.vn/uploads/2021-10-07/yasuo-chan-long-kiem.jpg",
                  "https://static.zerochan.net/Pyke.%28League.of.Legends%29.full.3589821.jpg",
                  "https://cdnmedia.webthethao.vn/uploads/2021-06-09/zed-hang-hieu.jpg",
                  "https://static.zerochan.net/Pyke.%28League.of.Legends%29.full.3589821.jpg",
                  "https://cdnmedia.webthethao.vn/uploads/img/files/images/fullsize/rong-lee-sin.jpg",
                  "https://esports-news.co.uk/wp-content/uploads/2022/03/battle-cat-jinx-prestige-skin-768x367.jpg.webp",
                  "https://gamek.mediacdn.vn/133514250583805952/2021/7/23/-1627054773972151039442.jpg",
                  "https://gamek.mediacdn.vn/133514250583805952/2021/6/22/photo-1-16243766643521398604530.jpg",
                  "https://lol-skin.weblog.vc/img/wallpaper/splash/Graves_35.webp?1646165530",
                  "https://cdngarenanow-a.akamaihd.net/webmain/static/pss/lol/items_splash/jayce_5.jpg",
                  "https://gamek.mediacdn.vn/133514250583805952/2020/11/24/photo-1-16061876912511244985316.jpg",
                  "https://i.pinimg.com/564x/92/8b/33/928b331c16d1f44bf6bc411694782a3f.jpg",
                  "https://lol-skin.weblog.vc/img/wallpaper/splash/Renekton_26.webp?1646165530"
                  
    ]
    let semaphore = DispatchSemaphore(value: 3)
    let downloadConcurrent = DispatchQueue(label: "com.app.downloadQueue", attributes: .concurrent)
    let downloadSerial =  DispatchQueue(label: "com.app.downloadSerial")
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func testBtn(_ sender: Any) {
        //        concurrentGCD()
        //        serialGCD()
//        semaphoreGCD()
//        dispatchGroupGCD()
        blockOperation()
    }
    
    func getImg(url: String) {
        if let url = URL(string: url) {
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                guard let _ = data, error == nil else { return }
                let time = "\(Date().timeIntervalSince1970)"
                print(time)
            }
            task.resume()
        }
    }
    
    func getImg(url: String, semaphore: DispatchSemaphore) {
        if let url = URL(string: url) {
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                guard let _ = data, error == nil else { return }
                let time = "\(Date().timeIntervalSince1970)"
                print(time)
                semaphore.signal()
            }
            
            task.resume()
        }
    }
    
    func getImg(url: String, dispatchGroup: DispatchGroup) {
        if let url = URL(string: url) {
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                guard let _ = data, error == nil else { return }
                let time = "\(Date().timeIntervalSince1970)"
                print(time)
                dispatchGroup.leave()
            }
            
            task.resume()
        }
    }
    
    func concurrentGCD() {
        for i in self.urlImg {
            downloadConcurrent.async {
                self.getImg(url: i)
            }
        }
        
    }
    
    func serialGCD() {
        for i in self.urlImg {
            downloadSerial.async {
                self.getImg(url: i)
            }
        }
    }
    
    func semaphoreGCD() {
        for i in self.urlImg {
            downloadConcurrent.async {
                self.semaphore.wait()
                self.getImg(url: i, semaphore: self.semaphore)
            }
        }
    }
    
    func dispatchGroupGCD() {
        downloadConcurrent.async {
            let dispatchGroup = DispatchGroup()
            for i in self.urlImg {
                dispatchGroup.enter()
                self.getImg(url: i, dispatchGroup: dispatchGroup)
            }
            dispatchGroup.notify(queue: .main) {
                print("ALL DONE")
            }
        }
    }
    
    func blockOperation() {
        let block = BlockOperation()
        
        for i in self.urlImg {
            block.addExecutionBlock {
                self.getImg(url: i)
            }
        }

        block.start()
    }
}

