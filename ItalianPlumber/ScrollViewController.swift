//
//  ScrollViewController.swift
//  ItalianPlumber
//
//  Created by Balazs Szamody on 24/1/20.
//  Copyright © 2020 Balazs Szamody. All rights reserved.
//

import UIKit

class ScrollViewController: UIViewController {
    @IBOutlet weak var imageScrollView: ImageScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageScrollView.delegate = self
        imageScrollView.image = UIImage(named: "surf")
    }

}

extension ScrollViewController: ImageScrollViewDelegate {
    func closeDidTap(on view: ImageScrollView) {
        dismiss(animated: true, completion: nil)
    }
}
