//
//  ViewController.swift
//  prepare_image
//
//  Created by Jim on 2018/6/9.
//  Copyright © 2018年 Jim. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    let urlString = "http://k.softarts.cc/00tmp/Cat14MP.JPG"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let encodeed = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            //允許改用urlQueryAllowed 做編碼   不用作web格式 檔名修改
            assertionFailure("Fail to encode urlString")
            return
        }
        
        guard let url = URL(string: encodeed) else{
            return assertionFailure("Invalid URL") }
        
        imageView.showImage(url: url)
        imageView.showImage(url: url)
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

