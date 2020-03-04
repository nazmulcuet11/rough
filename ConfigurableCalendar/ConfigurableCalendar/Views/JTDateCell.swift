//
//  JTDateCell.swift
//  ConfigurableCalendar
//
//  Created by Sharetrip-iOS on 02/03/2020.
//  Copyright © 2020 TBBD. All rights reserved.
//

import UIKit
import JTAppleCalendar

class JTDateCell: JTACDayCell {
    @IBOutlet weak var leftView: UIView!
    @IBOutlet weak var rightView: UIView!
    @IBOutlet weak var selectedView: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var todayLabel: UILabel!

    @IBOutlet weak var dotView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configure(cellState: CellState, valid: Bool, selectedPosition: SelectionRangePosition) {
        /// Hide out of the months date

//        if cellState.dateBelongsTo != .thisMonth {
//            showHideAll(hide: true)
//        } else {
//            showHideAll(hide: false)
//            dateLabel.text = cellState.text
//            handleCellTextColor(for: cellState, valid: valid, selectedPosition: selectedPosition)
//            handleCellSelection(selectedPosition: selectedPosition)
//            todayLabel.isHidden = !(cellState.date.compare(.isSameDay(as: Date())) && selectedPosition == .none)
//            dotView.isHidden = cellState.date.compare(.isSameDay(as: Date()))
//        }

        /// Do Not hide out of the months date

//        dateLabel.text = cellState.text
//        handleCellTextColor(for: cellState, valid: valid, selectedPosition: selectedPosition)
//        handleCellSelection(selectedPosition: selectedPosition)
//        todayLabel.isHidden = !(cellState.date.compare(.isSameDay(as: Date())) && selectedPosition == .none)
//        dotView.isHidden = cellState.date.compare(.isSameDay(as: Date()))

        /// Experimental feature:  Hide out of the months date, but show selection color
        if cellState.dateBelongsTo != .thisMonth {
            showHideAll(hide: true)
            handleCellSelection(selectedPosition: selectedPosition)
        } else {
            showHideAll(hide: false)
            dateLabel.text = cellState.text
            handleCellTextColor(for: cellState, valid: valid, selectedPosition: selectedPosition)
            handleCellSelection(selectedPosition: selectedPosition)
            todayLabel.isHidden = !(cellState.date.compare(.isSameDay(as: Date())) && selectedPosition == .none)
            dotView.isHidden = cellState.date.compare(.isSameDay(as: Date()))
        }
    }

    private func showHideAll(hide: Bool) {
        /// Hide full cell if date out of month
//        if hide {
//            dateLabel.isHidden = true
//            dotView.isHidden = true
//            todayLabel.isHidden = true
//            leftView.isHidden = true
//            rightView.isHidden = true
//            selectedView.isHidden = true
//        } else {
//            dateLabel.isHidden = false
//            dotView.isHidden = false
//            todayLabel.isHidden = false
//            leftView.isHidden = false
//            rightView.isHidden = false
//            selectedView.isHidden = false
//        }

        /// Experimental feature:  Hide only text and dot, but show selection color if date out of month
        if hide {
            dateLabel.isHidden = true
            dotView.isHidden = true
            todayLabel.isHidden = true
//            leftView.isHidden = true
//            rightView.isHidden = true
//            selectedView.isHidden = true
        } else {
            dateLabel.isHidden = false
            dotView.isHidden = false
            todayLabel.isHidden = false
//            leftView.isHidden = false
//            rightView.isHidden = false
//            selectedView.isHidden = false
        }
    }

    private func handleCellTextColor(for cellState: CellState, valid: Bool, selectedPosition: SelectionRangePosition) {
        if selectedPosition != .none {
            dateLabel.textColor = .white
        } else if cellState.dateBelongsTo == .thisMonth && valid {
            dateLabel.textColor = .black
        } else if cellState.dateBelongsTo != .thisMonth && valid {
            dateLabel.textColor = .darkGray
        } else {
            dateLabel.textColor = .lightGray
        }
    }

    private func handleCellSelection(selectedPosition: SelectionRangePosition) {
        switch selectedPosition {
            case .left:
                leftView.isHidden = true
                rightView.isHidden = false
                selectedView.isHidden = false
            case .middle:
                leftView.isHidden = false
                rightView.isHidden = false
                selectedView.isHidden = true
            case .right:
                leftView.isHidden = false
                rightView.isHidden = true
                selectedView.isHidden = false
            case .full:
                leftView.isHidden = true
                rightView.isHidden = true
                selectedView.isHidden = false
            case .none:
                leftView.isHidden = true
                rightView.isHidden = true
                selectedView.isHidden = true
        }
    }
}
