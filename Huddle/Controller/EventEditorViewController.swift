//
//  EventEditorViewController.swift
//  Huddle
//
//  Created by Dan Mitu on 2/22/19.
//  Copyright © 2019 Dan Mitu. All rights reserved.
//

import UIKit

class EventEditorViewController: UITableViewController {
    
    // MARK: - Initialization
    
    init(for mode: Mode) {
        self.mode = mode
        super.init(style: .grouped)
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) is not supported") }
    
    // MARK: - Properties
    
    let mode: Mode
    
    enum Mode {
        case creating /// creating a new event
        case editing /// editing an existing event
    }

    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = {
            switch mode {
            case .creating: return "New Event"
            case .editing: return "Edit Event"
            }
        }()
        
        navigationItem.rightBarButtonItem = doneBarButton
        navigationItem.leftBarButtonItem = cancelBarButton
        doneBarButton.target = self
        doneBarButton.action = #selector(doneButtonWasPressed)
        cancelBarButton.target = self
        cancelBarButton.action = #selector(cancelButtonWasPressed)
    }
    
    // MARK: - Other Views
    
    private let doneBarButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: nil)
    
    private lazy var cancelBarButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: nil, action: nil)
    
    private let activityIndicatorBarItem = UIBarButtonItem(customView: UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 20, height: 20)))
    
    // MARK: - Cells
    
    private lazy var cells: [UITableViewCell] = {
        var cells = [nameCell, descriptionCell, locationCell, startDateCell, endDateCell]
        if case .editing = mode { cells.append(deleteButtonCell) }
        return cells
    }()
    
    private var activeDatePicker: (parentCell: UITableViewCell, datePickerCell: DatePickerTableViewCell)?
    
    private let nameCell: TitledTextFieldTableViewCell = {
        let cell = TitledTextFieldTableViewCell()
        cell.titleLabel.text = "Name"
        cell.textField.returnKeyType = .done
        return cell
    }()
    
    private let descriptionCell: UITableViewCell = {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.text = "Description"
        return cell
    }()
    
    private let locationCell: UITableViewCell = {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: nil)
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.text = "Location"
        return cell
    }()
    
    private let startDateCell: UITableViewCell = {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: nil)
        cell.textLabel?.text = "Starts"
        return cell
    }()
    
    private let endDateCell: UITableViewCell = {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: nil)
        cell.textLabel?.text = "Ends"
        return cell
    }()
    
    private let deleteButtonCell: ButtonTableViewCell = {
       let cell = ButtonTableViewCell()
        cell.button.setTitle("Delete Event", for: .normal)
        cell.button.setTitleColor(.red, for: .normal)
        cell.button.addTarget(self, action: #selector(deleteButtonWasPressed), for: .touchUpInside)
        cell.selectionStyle = .none
        return cell
    }()
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cells.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return cells[indexPath.row]
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCell = cells[indexPath.row]
        
        if selectedCell == startDateCell {
            insertDatePicker(below: startDateCell)
        } else if selectedCell == endDateCell {
            insertDatePicker(below: endDateCell)
        } else if selectedCell == descriptionCell {
            let textViewController = TextViewController()
            textViewController.whenDoneEditing = { string in print(string) }
            navigationController?.pushViewController(textViewController, animated: true)
        } else if selectedCell == locationCell {
            let mapViewController = ChooseLocationViewController()
            mapViewController.navigationItem.title = "Location"
            mapViewController.whenDoneSelecting = { placemark in print(placemark) }
            navigationController?.pushViewController(mapViewController, animated: true)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    private func insertDatePicker(below parentCell: UITableViewCell) {
        guard var parentCellIndex = cells.firstIndex(where: { parentCell == $0 }) else { return }
        
        if let activeDatePickerCell = self.activeDatePicker?.datePickerCell {
            let activeDatePickerIndex = cells.firstIndex(where: { activeDatePickerCell == $0 })!
            guard activeDatePickerIndex != parentCellIndex + 1 else { return }
            cells.remove(at: activeDatePickerIndex)
            tableView.deleteRows(at: [IndexPath(row: activeDatePickerIndex, section: 0)], with: .top)
            parentCellIndex = cells.firstIndex(where: { parentCell == $0 })!
        }
        
        let datePickerCell = DatePickerTableViewCell()
        let datePickerCellIndex = IndexPath(row: parentCellIndex+1, section: 0)
        datePickerCell.datePicker.addTarget(self, action: #selector(datePickerDidChangeValue), for: .valueChanged)
        cells.insert(datePickerCell, at: datePickerCellIndex.row)
        tableView.insertRows(at: [datePickerCellIndex], with: .top)
        activeDatePicker = (parentCell: parentCell, datePickerCell: datePickerCell)
    }
    
    // MARK: - Actions
    
    @objc func doneButtonWasPressed() {
        self.dismiss(animated: true)
    }
    
    @objc func cancelButtonWasPressed() {
        self.dismiss(animated: true)
    }
    
    @objc private func deleteButtonWasPressed() {
        self.dismiss(animated: true)
    }
    
    @objc private func datePickerDidChangeValue() {
        guard let activeDatePicker = activeDatePicker else { return }
        let selectedDate = activeDatePicker.datePickerCell.datePicker.date
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EE, MMM dd, yyyy, H:mm"
        let formattedDateString = dateFormatter.string(from: selectedDate)
        
        activeDatePicker.parentCell.detailTextLabel?.text = formattedDateString
    }
    
    // MARK: - Other Methods
    
    private func setButtons(for status: SubmissionStatus) {
        switch status {
        case .waitingForInput:
            cancelBarButton.isEnabled = true
            doneBarButton.isEnabled = true
            navigationItem.setRightBarButton(cancelBarButton, animated: true)
            (activityIndicatorBarItem.customView as! UIActivityIndicatorView).stopAnimating()
        case .submitting:
            cancelBarButton.isEnabled = false
            navigationItem.setRightBarButton(activityIndicatorBarItem, animated: true)
            (activityIndicatorBarItem.customView as! UIActivityIndicatorView).startAnimating()
        default: break
        }
    }

}
