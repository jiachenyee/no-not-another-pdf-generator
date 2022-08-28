//
//  TableView.swift
//  PDF Generator
//
//  Created by Jia Chen Yee on 24/8/22.
//

import Foundation
import SwiftUI
import AppKit

import SwiftCSV

struct TableView: NSViewRepresentable {
    
    var csv: CSV<Named>
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
    
    func makeNSView(context: Context) -> NSScrollView {
        let tableView = NSTableView()
        
        for header in csv.header {
            let tableColumn = NSTableColumn(identifier: NSUserInterfaceItemIdentifier(header))
            
            tableColumn.title = header
            
            tableView.addTableColumn(tableColumn)
        }
        
        tableView.rowSizeStyle = .large

        tableView.rowSizeStyle = .small
        tableView.delegate = context.coordinator
        tableView.dataSource = context.coordinator
        
        let tableContainer = NSScrollView()
        
        tableContainer.documentView = tableView
        
        return tableContainer
    }
    
    func updateNSView(_ nsView: NSScrollView, context: Context) {
        
    }
    
    class Coordinator: NSObject, NSTableViewDelegate, NSTableViewDataSource {
        var parent: TableView
        
        init(parent: TableView) {
            self.parent = parent
        }
        
        func numberOfRows(in tableView: NSTableView) -> Int {
            return parent.csv.rows.count
        }
        
        func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
            
            let rowValues = parent.csv.rows[row]
            guard let tableColumn,
                    let rowContent = rowValues[tableColumn.identifier.rawValue] else { return nil }
            
            let text = NSTextField(labelWithString: rowContent)
            
            let cell = NSTableCellView()
            
            cell.addSubview(text)
            
            text.drawsBackground = false
            text.isBordered = false
            text.translatesAutoresizingMaskIntoConstraints = false
            
            cell.addConstraints([
                cell.centerYAnchor.constraint(equalTo: text.centerYAnchor),
                cell.centerXAnchor.constraint(equalTo: text.centerXAnchor),
                cell.leadingAnchor.constraint(equalTo: text.leadingAnchor),
                cell.trailingAnchor.constraint(equalTo: text.trailingAnchor)
            ])
            
            return cell
        }
    }
}
