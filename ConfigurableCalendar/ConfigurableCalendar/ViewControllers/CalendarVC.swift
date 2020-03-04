//
//  ViewController.swift
//  ConfigurableCalendar
//
//  Created by Sharetrip-iOS on 02/03/2020.
//  Copyright © 2020 TBBD. All rights reserved.
//

import UIKit

class CalendarVC: UIViewController {

    @IBOutlet weak var calendarCollectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        calendarCollectionView.dataSource = self
        calendarCollectionView.delegate = self

        let cellNib = UINib(nibName: "\(CalendarCVCell.self)", bundle: nil)
        calendarCollectionView.register(cellNib, forCellWithReuseIdentifier: "\(CalendarCVCell.self)")

        let headerNib = UINib(nibName: "\(CalendarHeader.self)", bundle: nil)
        calendarCollectionView.register(headerNib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "\(CalendarHeader.self)")

        calculateCellSize()
    }

    private var dateCellSize: CGSize = CGSize(width: 40.0, height: 40.0)
    private func calculateCellSize() {
        let numberOfCellPerRow = 7.0
        let cellOffset = 5.0
        let screenWidth = Double(UIScreen.main.bounds.size.width)
        let cellWidth = floor((screenWidth + cellOffset) / numberOfCellPerRow) - cellOffset
        dateCellSize = CGSize(width: cellWidth, height: cellWidth)
    }
}

extension CalendarVC: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 12 * 100
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 30
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(CalendarCVCell.self)", for: indexPath) as? CalendarCVCell else {
            fatalError("Cell Not Found!")
        }
        cell.configure(date: indexPath.item + 1)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader else {
            fatalError("Unkown supplimentary view. Expected: \(UICollectionView.elementKindSectionHeader), Found: \(kind)")
        }

        guard let headerView = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: "\(CalendarHeader.self)",
            for: indexPath) as? CalendarHeader else {
                fatalError("Can't deque CalendarHeader view")
        }

        let month = indexPath.section % 12
        let year = 2020 + (indexPath.section / 12)
        headerView.configure(month: month, year: year)

        return headerView
    }
}

extension CalendarVC: UICollectionViewDelegate {}

extension CalendarVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return dateCellSize
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let screenWidth = Double(UIScreen.main.bounds.size.width)
        return CGSize(width: screenWidth, height: 70.0)
    }
}



