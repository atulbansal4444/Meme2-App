//
//  detailMemeVController.swift
//  imagePicker
//
//  Created by Atul Bansal on 30/03/18.
//  Copyright © 2018 Atul Bansal. All rights reserved.
//
//
import UIKit

class detailMemeVController: UIViewController {
    
    @IBOutlet weak var memeImageView: UIImageView!
    var meme: Meme!
    override func viewDidLoad() {
        super.viewDidLoad()
        memeImageView.image = meme.memedImage
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        memeImageView.contentMode = .scaleAspectFit
    }
}
