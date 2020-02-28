//
//  SearchVC.swift
//  Depnedant
//
//  Created by Nazmul Islam on 14/2/20.
//  Copyright © 2020 Nazmul Islam. All rights reserved.
//

import UIKit

protocol SearchVCModalPresentationDelegate: class {
    func onDismissed()
}

class SearchVC: UIViewController {

    @IBOutlet weak var searchStrTF: UITextField!
    @IBOutlet weak var checkinDateTF: UITextField!
    @IBOutlet weak var checkoutDateTF: UITextField!

    var viewModel: SearchViewModel!
    weak var modalPresentationDelegate: SearchVCModalPresentationDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Search Hotel"

        searchStrTF.text = viewModel.searchStr
        checkinDateTF.text = viewModel.checkinDate.description
        checkoutDateTF.text = viewModel.checkoutDate.description
    }

    @IBAction func onSearchButtonTapped(_ sender: Any) {
        if let text = searchStrTF.text {
            viewModel.searchStr = text
        }

        let presentedModaly = presentingViewController != nil
        if presentedModaly {
            modalPresentationDelegate?.onDismissed()
            dismiss(animated: true, completion: nil)
            return
        }

        let hotelContainer = AppManager.shared.hotelContainer
        let hotellistViewModel = hotelContainer.resolve(HotelListViewModel.self)!
        let listVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "\(ListVC.self)") as ListVC
        listVC.viewModel = hotellistViewModel

        navigationController?.pushViewController(listVC, animated: true)
    }
}
