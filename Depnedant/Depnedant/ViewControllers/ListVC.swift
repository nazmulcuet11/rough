//
//  ListVC.swift
//  Depnedant
//
//  Created by Nazmul Islam on 14/2/20.
//  Copyright © 2020 Nazmul Islam. All rights reserved.
//

import UIKit

class ListVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    var viewModel: HotelListViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Hotel List"

        tableView.dataSource = self
        tableView.delegate = self

        viewModel.loadHotels {
            DispatchQueue.main.async { [weak self] in
                self?.tableView.reloadData()
            }
        }
    }

    @IBAction func onSearchAgainTapped(_ sender: Any) {
        let hotelContainer = AppManager.shared.hotelContainer
        let searchViewModel = hotelContainer.resolve(SearchViewModel.self)!
        let searchVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "\(SearchVC.self)") as SearchVC
        searchVC.viewModel = searchViewModel
        searchVC.modalPresentationDelegate = self
        let navigationController = UINavigationController(rootViewController: searchVC)
        present(navigationController, animated: true)
    }
}

extension ListVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.hotelCount
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(HotelListCell.self)", for: indexPath) as? HotelListCell,
            let hotel = viewModel.getHotel(at: indexPath.row) else {
                return UITableViewCell()
        }
        cell.configure(with: hotel)
        return cell
    }
}

extension ListVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let hotel = viewModel.getHotel(at: indexPath.row) else { return }

        let hotelContainer = AppManager.shared.hotelContainer
        let hotelDetailViewModel = hotelContainer.resolve(HotelDetailViewModel.self,
                                                          argument: hotel.id)!
        let detailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "\(DetailVC.self)") as DetailVC
        detailVC.viewModel = hotelDetailViewModel

        navigationController?.pushViewController(detailVC, animated: true)
    }
}

extension ListVC: SearchVCModalPresentationDelegate {
    func onDismissed() {
        let hotelContainer = AppManager.shared.hotelContainer
        let searchViewModel = hotelContainer.resolve(SearchViewModel.self)!
        let searchRequest = searchViewModel.getSearchRequest()
        viewModel.updateSearchRequest(searchRequest: searchRequest)
        viewModel.loadHotels {
            DispatchQueue.main.async { [weak self] in
                self?.tableView.reloadData()
            }
        }
    }
}
