//
//  JTCalendarViewModel.swift
//  ConfigurableCalendar
//
//  Created by Sharetrip-iOS on 02/03/2020.
//  Copyright © 2020 TBBD. All rights reserved.
//

import Foundation
import JTAppleCalendar

enum DateSelectionMode {
    case single, range
}

class JTCalendarViewModel: JTCalendarViewModelProvider {
    private(set) var minAllowableDate: Date?
    private(set) var maxAllowableDate: Date?
    private(set) var firstDate: Date?
    private(set) var lastDate: Date?
    private(set) var dateSelectionMode: DateSelectionMode

    var calendarDateRange: (startDate: Date, endDate: Date) {
        var _minDate: Date
        var _maxDate: Date

        if let minDate = minAllowableDate, let maxDate = maxAllowableDate {
            _minDate = minDate
            _maxDate = maxDate
        } else if let minDate = minAllowableDate {
            _minDate = minDate
            _maxDate = Calendar.current.startOfDay(for: minDate.adjust(.year, offset: 1))
        } else if let maxDate = maxAllowableDate {
            _minDate = Calendar.current.startOfDay(for: maxDate.adjust(.year, offset: -1))
            _maxDate = maxDate
        } else {
            _minDate = Calendar.current.startOfDay(for: Date())
            _maxDate = Calendar.current.startOfDay(for: _minDate.adjust(.year, offset: 1))
        }

        if _minDate > _maxDate { swap(&_minDate, &_maxDate) }

        return (startDate: _minDate, endDate: _maxDate)
    }

    private var dateSelectionChangedCallback: ()->Void
    init(minAllowableDate: Date? = nil,
         maxAllowableDate: Date? = nil,
         firstDate: Date? = nil,
         lastDate: Date? = nil,
         dateSelectionMode: DateSelectionMode,
         onDateSelectionChanged callback: @escaping ()->Void) {
        self.minAllowableDate = minAllowableDate
        self.maxAllowableDate = maxAllowableDate
        self.firstDate = firstDate
        self.lastDate = lastDate
        self.dateSelectionMode = dateSelectionMode
        self.dateSelectionChangedCallback = callback
    }

    func cellWidth(calendarWidth: Double) -> Double {
        let numberOfCellPerRow = 7.0
        let cellOffset = 5.0
        let cellWidth = floor((calendarWidth + cellOffset) / numberOfCellPerRow) - cellOffset
        return cellWidth
    }


    func isValid(_ date: Date) -> Bool {
        if let minDate = minAllowableDate, let maxDate = maxAllowableDate {
            return minDate <= date && date <= maxDate
        }
        if let minDate = minAllowableDate {
            return date >= minDate
        }
        if let maxDate = maxAllowableDate {
            return date <= maxDate
        }
        return true
    }

    private func isOutOfMonthDateMiddleCell(_ date: Date, cellSate: CellState) -> Bool {
        guard let firstDate = firstDate, let lastDate = lastDate else { return false }
        guard cellSate.dateBelongsTo != .thisMonth else { return false }

        if cellSate.dateBelongsTo == .previousMonthWithinBoundary {
            let activeMonthDate = date.adjust(.month, offset: 1)
            if firstDate.belongsToSomePrevMonth(of: activeMonthDate)
                && !lastDate.belongsToSomePrevMonth(of: activeMonthDate) {
                return true
            }
        } else if cellSate.dateBelongsTo == .followingMonthWithinBoundary {
            let activeMonthDate = date.adjust(.month, offset: -1)
            if lastDate.belongsToSomeNextMonth(of: activeMonthDate)
                && !firstDate.belongsToSomeNextMonth(of: activeMonthDate) {
                return true
            }
        }

        return false
    }

    func positionTypeForDate(_ date: Date, cellSate: CellState) -> SelectionRangePosition {

        if let firstDate = firstDate, let lastDate = lastDate, !firstDate.compare(.isSameDay(as: lastDate)) {

            if date.compare(.isSameDay(as: firstDate)) && cellSate.dateBelongsTo == .thisMonth {
                return .left
            }

            if date.compare(.isSameDay(as: lastDate)) && cellSate.dateBelongsTo == .thisMonth {
                return .right
            }

            if (firstDate < date && date < lastDate && cellSate.dateBelongsTo == .thisMonth)
                || isOutOfMonthDateMiddleCell(date, cellSate: cellSate) {
                return .middle
            }

            return .none
        }

        if let firstDate = firstDate,
            date.compare(.isSameDay(as: firstDate)) && cellSate.dateBelongsTo == .thisMonth {
            return .full
        }

        return .none
    }

    func onNewDateSelected(_ selectedDate: Date) {
        switch dateSelectionMode {
        case .range:
            if let firstDate = self.firstDate, let lastDate = self.lastDate {
                self.firstDate = nil
                self.lastDate = nil
                if selectedDate < firstDate || lastDate < selectedDate {
                    self.firstDate = selectedDate
                }
            } else if let firstDate = self.firstDate {
                if selectedDate.compare(.isSameDay(as: firstDate)) {
                    self.firstDate = nil
                } else if selectedDate < firstDate {
                    self.lastDate = firstDate
                    self.firstDate = selectedDate
                } else {
                    self.lastDate = selectedDate
                }
            } else {
                self.firstDate = selectedDate
            }
        case .single:
            if let firstDate = firstDate, selectedDate.compare(.isSameDay(as: firstDate)) {
                self.firstDate = nil
            } else {
                self.firstDate = selectedDate
            }
        }
        dateSelectionChangedCallback()
    }
}

fileprivate extension Date {
    func belongsToSomePrevMonth(of referenceDate: Date) -> Bool {
        return self < referenceDate && !compare(.isSameMonth(as: referenceDate))
    }

    func belongsToSomeNextMonth(of referenceDate: Date) -> Bool {
        return self > referenceDate && !compare(.isSameMonth(as: referenceDate))
    }
}
