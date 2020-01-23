//
//  ViewController.swift
//  ItalianPlumber
//
//  Created by Balazs Szamody on 27/11/19.
//  Copyright © 2019 Balazs Szamody. All rights reserved.
//

import UIKit
import Combine

protocol ViewModel {
    var timeString: PassthroughSubject<String?, Never> { get }
    var disposeBag: DisposeBag { get set }
}

class ViewModelImp: ViewModel {
    let timeString: PassthroughSubject<String?, Never> = PassthroughSubject()
    var timer: Timer!
    var disposeBag = DisposeBag()
    
    @objc func fireTimer(_ sender: Timer) {
        let date = sender.fireDate
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        formatter.timeZone = TimeZone.current
        timeString.send(formatter.string(from: date))
    }
    
    init() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(fireTimer(_:)), userInfo: nil, repeats: true)
    }
}

class ViewController: UIViewController {
    var viewModel: ViewModel!
    @IBOutlet weak var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = ViewModelImp()
        
        viewModel
            .timeString
            .sink(receiveValue: {[weak self] (time) in
                self?.label.text = time
            })
            .disposed(by: &viewModel.disposeBag)
        
        guard let url = URL(string: "app.socialbase://") else {
            print("Shitty URL")
            return
        }
        
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: { isSuccess in
                print(isSuccess ? "done" : "failed")
            })
        } else {
            print("Can't open \(url)")
        }
            
    }
}

typealias DisposeBag = [AnyCancellable]

extension AnyCancellable {
    func disposed(by disposeBag: inout DisposeBag) {
        disposeBag.append(self)
    }
}
