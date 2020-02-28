//
//  ViewController.swift
//  Depnedant
//
//  Created by Nazmul Islam on 14/2/20.
//  Copyright © 2020 Nazmul Islam. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Dependant"
    }

    @IBAction func onButtonTapped(_ sender: Any) {
        let hotelContainer = AppManager.shared.hotelContainer
        hotelContainer.resetObjectScope(.hotelScope)
        
        let searchViewModel = hotelContainer.resolve(SearchViewModel.self)!
        let searchVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "\(SearchVC.self)") as SearchVC
        searchVC.viewModel = searchViewModel

        navigationController?.pushViewController(searchVC, animated: true)
    }
}

