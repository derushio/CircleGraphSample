//
//  ViewController.swift
//  CircleGraphSample
//
//  Created by 中塩成海 on 2015/06/25.
//  Copyright (c) 2015年 Derushio. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var circleGraphView: CircleGraphView!
    
    private var isSetUped: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidLayoutSubviews() {
        if (isSetUped == false) {
            circleGraphView.startAnime(16, numFemale: 23)
            // AutoLayoutならばviewDidLayoutSubViews以降に呼び出してください
            // コードでレイアウトしているならば、どこでもいいです
            // アスペクト比は1:1でお願いします
            isSetUped = true
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

