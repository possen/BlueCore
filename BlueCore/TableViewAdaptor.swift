//
//  TableViewAdaptor.swift
//
//  Created by Paul Ossenbruggen on 2/25/17.
//

import UIKit

protocol TableSectionAdaptor {
    var cellReuseIdentifier: String { get }
    var title: String { get }
    var count: () -> Int { get set }
    var select: ((Int) -> Void)? { get set }
    func configure(cell: UITableViewCell, index: Int)
}


struct TableViewAdaptorSection<Cell>: TableSectionAdaptor {
    internal let cellReuseIdentifier: String
    internal let title: String
    internal var count: () -> Int
    internal var select: ((Int) -> Void)? = nil
    internal var configure: (Cell, Int) -> Void

    internal func configure(cell: UITableViewCell, index: Int) {
        configure(cell as! Cell, index)
    }
}

class TableViewAdaptor: NSObject, UITableViewDataSource, UITableViewDelegate {
    private let tableView: UITableView
    private let sections: [TableSectionAdaptor]

    init(
        tableView: UITableView,
         sections: [TableSectionAdaptor]
    ) {
        self.tableView = tableView
        self.sections = sections
        super.init()
        tableView.dataSource = self
        tableView.delegate = self
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    func tableView(
        _ tableView: UITableView,
        titleForHeaderInSection section: Int
    ) -> String? {
        return sections[section].title
    }

    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        let section = sections[section]
        return section.count()
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let section = sections[indexPath.section]
        let cell = tableView.dequeueReusableCell(withIdentifier:section.cellReuseIdentifier,
                                                 for: indexPath)
        section.configure(cell: cell, index: indexPath.row)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = sections[indexPath.section]
        section.select?(indexPath.row)
    }
}
