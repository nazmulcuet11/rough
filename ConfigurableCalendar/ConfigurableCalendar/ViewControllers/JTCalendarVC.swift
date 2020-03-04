//
//  JTCalendarVC.swift
//  ConfigurableCalendar
//
//  Created by Sharetrip-iOS on 02/03/2020.
//  Copyright © 2020 TBBD. All rights reserved.
//

import UIKit
import JTAppleCalendar

protocol JTCalendarViewModelProvider {
    var minAllowableDate: Date? { get }
    var maxAllowableDate: Date? { get }
    var firstDate: Date? { get }
    var lastDate: Date? { get }
    var dateSelectionMode: DateSelectionMode { get }
    var calendarDateRange: (startDate: Date, endDate: Date) { get }

    func isValid(_ date: Date) -> Bool
    func onNewDateSelected(_ selectedDate: Date)
    func cellWidth(calendarWidth: Double) -> Double
    func positionTypeForDate(_ date: Date, cellSate: CellState) -> SelectionRangePosition
}

class JTCalendarVC: UIViewController {

    @IBOutlet weak var calendarView: JTACMonthView!

    @IBOutlet weak var firstDateView: UIView!
    @IBOutlet weak var firstDateLabel: UILabel!

    @IBOutlet weak var secondDateView: UIView!
    @IBOutlet weak var secondDateLabel: UILabel!

    @IBOutlet weak var applyButton: UIButton!

    private var viewModel: JTCalendarViewModelProvider!

    private var dateSelectionMode: DateSelectionMode = .range
    private var singleDateAllowedDuringRangeSelection: Bool = false
    /// Must be called before view did load to function properly
    func configure(dateSelectionMode: DateSelectionMode,
                   singleDateAllowedDuringRangeSelection: Bool = false) {
        self.dateSelectionMode = dateSelectionMode
        self.singleDateAllowedDuringRangeSelection = singleDateAllowedDuringRangeSelection
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = JTCalendarViewModel(dateSelectionMode: self.dateSelectionMode) { [weak self] in
            self?.setDateText()
            self?.setApplyButtonStatus()
        }
        setupUI()
    }

    private func setupUI() {
        title = "Awsome Calendar"

        calendarView.calendarDataSource = self
        calendarView.calendarDelegate = self

        let cellNib = UINib(nibName: "\(JTDateCell.self)", bundle: nil)
        calendarView.register(cellNib, forCellWithReuseIdentifier: "\(JTDateCell.self)")

        let headerNib = UINib(nibName: "\(JTCalendarHeader.self)", bundle: nil)
        calendarView.register(headerNib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "\(JTCalendarHeader.self)")

        let calendarWidth = Double(UIScreen.main.bounds.size.width)
        calendarView.cellSize = CGFloat(viewModel.cellWidth(calendarWidth: calendarWidth))

        calendarView.allowsRangedSelection = true
        calendarView.rangeSelectionMode = .continuous
        // Allow selection of an already selected cell
        calendarView.allowsMultipleSelection = true

        secondDateView.isHidden = dateSelectionMode == .single

        setDateText()
        setApplyButtonStatus()
    }

    private func setDateText() {
        let firstDate = viewModel.firstDate ?? Date()
        let secondDate = viewModel.lastDate ?? firstDate
        firstDateLabel.text = firstDate.toString(format: .shortDate).uppercased()
        secondDateLabel.text = secondDate.toString(format: .shortDate).uppercased()
    }

    private func setApplyButtonStatus() {
        if viewModel.dateSelectionMode == .range && !singleDateAllowedDuringRangeSelection {
            applyButton.isEnabled = viewModel.firstDate != nil && viewModel.lastDate != nil
        } else {
            applyButton.isEnabled = viewModel.firstDate != nil
        }

        if applyButton.isEnabled {
            applyButton.backgroundColor = .clearBlue
        } else {
            applyButton.backgroundColor = UIColor.clearBlue.withAlphaComponent(0.7)
        }
    }

    @IBAction func onApplyButtonTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}

extension JTCalendarVC: JTACMonthViewDataSource {
    func configureCalendar(_ calendar: JTACMonthView) -> ConfigurationParameters {
        let calendarDateRange = viewModel.calendarDateRange
        return ConfigurationParameters(
            startDate: calendarDateRange.startDate,
            endDate: calendarDateRange.endDate,
            numberOfRows: 10,
            generateOutDates: .tillEndOfRow,
            firstDayOfWeek: .sunday
        )
    }
}

extension JTCalendarVC: JTACMonthViewDelegate {
    private func configureCell(_ cell: JTACDayCell?, cellState: CellState, date: Date) {
        guard let cell = cell as? JTDateCell else { return }
        cell.configure(
            cellState: cellState,
            valid: viewModel.isValid(date),
            selectedPosition: viewModel.positionTypeForDate(date, cellSate: cellState)
        )
    }

    func calendar(_ calendar: JTACMonthView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTACDayCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "\(JTDateCell.self)", for: indexPath)
        configureCell(cell, cellState: cellState, date: date)
        return cell
    }

    func calendar(_ calendar: JTACMonthView, willDisplay cell: JTACDayCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        configureCell(cell, cellState: cellState, date: date)
    }

    func calendar(_ calendar: JTACMonthView, headerViewForDateRange range: (start: Date, end: Date), at indexPath: IndexPath) -> JTACMonthReusableView {
        let header = calendar.dequeueReusableJTAppleSupplementaryView(withReuseIdentifier: "\(JTCalendarHeader.self)", for: indexPath) as! JTCalendarHeader
        header.configure(startingDateOfTheMonth: range.start)
        return header
    }

    func calendarSizeForMonths(_ calendar: JTACMonthView?) -> MonthSize? {
        /// Called to retrieve the size to be used for the month headers
        return MonthSize(defaultSize: 70.0)
    }

    func calendar(_ calendar: JTACMonthView, shouldSelectDate date: Date, cell: JTACDayCell?, cellState: CellState, indexPath: IndexPath) -> Bool {
        return viewModel.isValid(date) && cellState.dateBelongsTo == .thisMonth
    }

    func calendar(_ calendar: JTACMonthView, didSelectDate date: Date, cell: JTACDayCell?, cellState: CellState, indexPath: IndexPath) {
        // Never call configure on user initiated selection
        // If required select the same date programatically again

        if cellState.selectionType == .userInitiated {
            viewModel.onNewDateSelected(date)

            // get already selected dates
            var datesAffected = calendar.selectedDates
            // cancell user intiated selection
            calendar.deselectAllDates()
            // select new dates
            if let startDate = viewModel.firstDate {
                let endDate = viewModel.lastDate ?? startDate
                let selectedDates = calendar.generateDateRange(from: startDate, to: endDate)
                calendar.selectDates(selectedDates, triggerSelectionDelegate: true, keepSelectionIfMultiSelectionAllowed: true)
            }

            // Reload dates of last month and following month
            // to make sure cell color changes accordingly
            let dateSegment = calendar.visibleDates()
            var visibleDates = [Date]()
            visibleDates.append(contentsOf: dateSegment.indates.map { $0.date} )
            visibleDates.append(contentsOf: dateSegment.outdates.map { $0.date} )
            visibleDates.append(contentsOf: dateSegment.monthDates.map { $0.date} )
            visibleDates = visibleDates.filter { !datesAffected.contains($0) }
            datesAffected.append(contentsOf: visibleDates)

            calendar.reloadDates(datesAffected)
            return
        }

        configureCell(cell, cellState: cellState, date: date)
    }

    func calendar(_ calendar: JTAppleCalendar.JTACMonthView, shouldDeselectDate date: Date, cell: JTAppleCalendar.JTACDayCell?, cellState: JTAppleCalendar.CellState, indexPath: IndexPath) -> Bool {
        guard viewModel.isValid(date) && cellState.dateBelongsTo == .thisMonth else { return false}

        // As we will handle all user initiated selection/deselection from didSelectDate method
        // We will not allow user to deselect date manually.
        // we will create handover the responsibilty to didSelectDate method
        // to generate deselection properly
        if cellState.selectionType == .userInitiated {
            self.calendar(calendar, didSelectDate: date, cell: cell, cellState: cellState, indexPath: indexPath)
            return false
        }
        return true
    }

    func calendar(_ calendar: JTACMonthView, didDeselectDate date: Date, cell: JTACDayCell?, cellState: CellState, indexPath: IndexPath) {
        if cellState.selectionType == .userInitiated { return }
        configureCell(cell, cellState: cellState, date: date)
    }
}
