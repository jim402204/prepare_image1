//
//  image+downloadsData.swift
//  prepare_image
//
//  Created by Jim on 2018/6/9.
//  Copyright © 2018年 Jim. All rights reserved.
//

import UIKit

extension UIImageView{
    
    static var currentTask=[String:URLSessionDataTask]()//字典 裝著目前的各種任務
    
    func showImage(url:URL) {
        
        print("self.description:\(self.description) ")
        
        
        if let existTask = UIImageView.currentTask[self.description] {
            existTask.cancel()
            UIImageView.currentTask.removeValue(forKey: self.description)
            print("existTask canceled")
        }
        
        let filename = String(format: "Cash_%ld", url.hashValue)
        //用url產生唯一hash碼（數字）作為檔名
        
        guard let CashURL = FileManager.default.urls(for:.cachesDirectory,in: .userDomainMask).first else {
                return assertionFailure("CashURL fail")
        }
        
        let fullFileURL = CashURL.appendingPathComponent(filename)
        print("Cash path:\(fullFileURL)")// 默認cash路徑＋檔名 ＝完整的cash路徑

        //fullFileURL.path url 轉 String
        if let image = UIImage(contentsOfFile: fullFileURL.path) {
            self.image=image
            return
        }
        //////////////////////////////////////////////////////////
        //  cash 找不到檔案 只好先下載一個
        
        let loadingView = prepareLoadingView()
//        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: URLSessionConfiguration.default)
        
        let task = session.dataTask(with: url) { (data, respone, error) in //執行背景
            
            if let error = error {//錯誤回報
                return print("這邊是錯誤訊息\(error)")
                //發生錯誤要 return 不然就會繼續跳至 確認data 然後assertion
            }
            
            guard let data = data else {
                return assertionFailure("no data")
            }

            let image = UIImage(data: data)
            
            defer{
                DispatchQueue.main.async {
                    self.image=image
                    //只在ＵＩ thread 做ＵＩ的更新
                    
                    loadingView.stopAnimating()
                    UIImageView.currentTask.removeValue(
                        forKey: self.description)
                }
            }//task end stop animate
            
            try?data.write(to: fullFileURL)//byte圖檔 寫入cash
            //快取要刪圖app才有辦法測試
        }//task
        task.resume()
        loadingView.startAnimating()
        UIImageView.currentTask[self.description]=task //寫入字典確保唯一
        //description 不會重複
    }
    
    func prepareLoadingView() -> UIActivityIndicatorView {
        
        let tag = 123 //for activityIndicatorView
        
        if let view = self.viewWithTag(tag) as? UIActivityIndicatorView
        {//viewWithTag 透過Tag找view意思
            return view
        }
        
//        for view in self.subviews{
//            if view is UIActivityIndicatorView{
//                return view as! UIActivityIndicatorView
//            }//找到veiw 在做處理
//        }
        
//////////////////////////////////////////////////////////////////////
        // 找不到 就產生一個新的默認 更新圖示
        
        let activityIndicatorView =
            UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        
        activityIndicatorView.tag = tag
        
        activityIndicatorView.frame = CGRect(origin: .zero, size: self.frame.size)//全部蓋住
        activityIndicatorView.autoresizingMask = [.flexibleHeight , .flexibleWidth]//調整
        activityIndicatorView.color = .blue
        activityIndicatorView.hidesWhenStopped = true
        
        self.addSubview(activityIndicatorView)
        
        return activityIndicatorView
    }
    
    
    
    
    
}
