//
//  EventEditorViewController.swift
//  Huddle
//
//  Team Atlas - OSU Capstone - Winter '19
//  Gerry Ashlock and Dan Mitu
//

import UIKit
import MapKit

fileprivate struct EventForm {
    
    var groupId: Int?
    var name: String?
    var description: String?
    var location: CLLocation?
    var locationName: String?
    var start: Date?
    var end: Date?
    
    init(groupId: Int) { // for creating a new event
        self.groupId = groupId
        self.name = nil
        self.description = nil
        self.location = nil
        self.start = nil
        self.end = nil
    }
    
    init(event: Event) { // for editing an existing one
        self.groupId = event.groupId
        self.name = event.name
        self.description = event.description
        self.location = event.location.location
        self.locationName = event.location.name
        self.start = event.start
        self.end = event.end
    }
    
    func getEmptyFields() -> [String] {
        var b = [String]()
        if name == nil { b.append("name") }
        if description == nil { b.append("description") }
        if location == nil { b.append("location") }
        if start == nil { b.append("start date") }
        if end == nil { b.append("end date") }
        return b
    }
    
    func merge(with previousEvent: Event) -> Event {
        
        let namedLocation = NamedLocation(id: previousEvent.location.id,
                                          name: self.locationName ?? previousEvent.location.name,
                                          location: self.location ?? previousEvent.location.location)
        
        return Event(id: previousEvent.id,
                     groupId: previousEvent.groupId,
                     name: self.name ?? previousEvent.name,
                     description: self.description ?? previousEvent.description,
                     location: namedLocation,
                     start: self.start ?? previousEvent.start,
                     end: self.end ?? previousEvent.end,
                     rsvp: previousEvent.rsvp)
    }
    
}

class EventEditorViewController: FormTableViewController {
    
    init(for mode: Mode) {
        self.mode = mode
        switch mode {
        case .creating(groupId: let id):
            self.eventForm = EventForm(groupId: id)
        case .editing(event: let e):
            self.eventForm = EventForm(event: e)
        }
        super.init(style: .grouped)
        
        setAllCells(event: self.eventForm)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }
    
    private var eventForm: EventForm
    
    private let networkManager = NetworkManager()
    
    let mode: Mode
    
    enum Mode {
        case creating(groupId: Int) /// creating a new event
        case editing(event: Event) /// editing an existing event
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = {
            switch mode {
            case .creating: return "New Event"
            case .editing: return "Edit Event"
            }
        }()
        
        nameCell.textField.addTarget(self, action: #selector(updateName), for: .editingChanged)
    }
    
    private func setAllCells(event: EventForm) {
        if let name = event.name { setNameView(name) }
        if let start = event.start { setStartDateView(start) }
        if let end = event.end { setEndDateView(end) }
        if let location = event.location { setLocationView(to: location) }
    }
    
    // MARK: - Name
    
    private let nameCell: TitledTextFieldTableViewCell = {
        let cell = TitledTextFieldTableViewCell()
        cell.titleLabel.text = "Name"
        cell.textField.returnKeyType = .done
        return cell
    }()
    
    func setNameView(_ string: String) {
        nameCell.textField.text = string
    }
    
    @objc func updateName() {
        eventForm.name = nameCell.textField.text
    }
    
    // MARK: - Description
    
    private let descriptionCell: UITableViewCell = {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.text = "Description"
        return cell
    }()
    
    func launchDescriptionTextViewController() {
        let textViewController = TextViewController()
        textViewController.setInitialText(eventForm.description ?? "")
        textViewController.whenDoneEditing = { [weak self] string in
            self?.eventForm.description = string
        }
        navigationController?.pushViewController(textViewController, animated: true)
    }
    
    // MARK: - Date Displays
    
    private let startDateCell: UITableViewCell = {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: nil)
        cell.textLabel?.text = "Starts"
        return cell
    }()
    
    private func setStartDateView(_ date: Date?) {
        setView(date: date, for: startDateCell)
    }
    
    private let endDateCell: UITableViewCell = {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: nil)
        cell.textLabel?.text = "Ends"
        return cell
    }()
    
    private func setEndDateView(_ date: Date?) {
        setView(date: date, for: endDateCell)
    }
    
    private func setView(date: Date?, for cell: UITableViewCell) {
        guard let date = date else { cell.detailTextLabel!.text = ""; return }
        cell.detailTextLabel!.text = PreferredDateFormat.describe(date, using: .format2)
    }
    
    private func startDateSelected() {
        setStartDateView(eventForm.start ?? Date())
        insertDatePicker(below: startDateCell, minimumDate: Date(), maximumDate: eventForm.end)
    }
    
    private func endDateSelected() {
        setEndDateView(eventForm.end ?? Date())
        insertDatePicker(below: endDateCell, minimumDate: eventForm.start, maximumDate: nil)
    }

    // MARK: - Date Picker
    
    private var activeDatePicker: (parentCell: UITableViewCell, datePickerCell: DatePickerTableViewCell)?
    
    @objc private func datePickerDidChangeValue() {
        guard let activeDatePicker = activeDatePicker else { return }
        
        let selectedDate = activeDatePicker.datePickerCell.datePicker.date
        
        if activeDatePicker.parentCell == startDateCell {
            setStartDateView(selectedDate)
            eventForm.start = selectedDate
            if let endDate = eventForm.end {
                if endDate < selectedDate {
                    setEndDateView(nil)
                    eventForm.end = nil
                } else {
                    print("\(endDate) vs \(selectedDate)")
                }
            }
        } else if activeDatePicker.parentCell == endDateCell {
            setEndDateView(selectedDate)
            eventForm.end = selectedDate
            if let startDate = eventForm.start {
                if startDate > selectedDate {
                    setStartDateView(nil)
                    eventForm.start = nil
                } else {
                    print("\(startDate) vs \(selectedDate)")
                }
            }
        } else {
            fatalError("Unreachable")
        }
    }
    
    private func insertDatePicker(below parentCell: UITableViewCell, minimumDate: Date?, maximumDate: Date?) {
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
        datePickerCell.datePicker.minimumDate = minimumDate
        datePickerCell.datePicker.maximumDate = maximumDate
        cells.insert(datePickerCell, at: datePickerCellIndex.row)
        tableView.insertRows(at: [datePickerCellIndex], with: .top)
        activeDatePicker = (parentCell: parentCell, datePickerCell: datePickerCell)
    }
    
    // MARK: - Location Picker
    
    private let locationCell: UITableViewCell = {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: nil)
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.text = "Location"
        return cell
    }()
    
    func launchLocationPickerViewController() {
        let mapViewController = ChooseLocationViewController()
        mapViewController.navigationItem.title = "Location"
        mapViewController.whenDoneSelecting = { [weak self] placemark in
            if let location = placemark.location {
                self?.eventForm.location = location
                self?.setLocationView(to: location)
                self?.saveName(forLocation: location)
            }
        }
        navigationController?.pushViewController(mapViewController, animated: true)
    }
    
    func saveName(forLocation location: CLLocation) {
        PreferredLocationFormat.describe(location, using: .shortAddress) { [weak self] strings in
            guard let strings = strings?.first else { return }
            let locationName = strings.joined(separator: ", ")
            self?.eventForm.locationName = locationName
        }
    }
    
    func setLocationView(to location: CLLocation) {
        PreferredLocationFormat.describe(location, using: .cityState) { [weak self] strings in
            guard let strings = strings?.first else { return }
            let oldValue = self?.locationCell.detailTextLabel?.text
            let newValue = strings.joined(separator: ", ")
            if oldValue != newValue {
                self?.locationCell.detailTextLabel?.text = newValue
            }
        }
    }
    
    // MARK: - Deletion
    
    private let deleteButtonCell: ButtonTableViewCell = {
        let cell = ButtonTableViewCell()
        cell.button.setTitle("Delete Event", for: .normal)
        cell.button.setTitleColor(.red, for: .normal)
        cell.button.addTarget(self, action: #selector(deleteButtonWasPressed), for: .touchUpInside)
        cell.selectionStyle = .none
        return cell
    }()
    
    @objc private func deleteButtonWasPressed() {
        confirmDelete() { [weak self] yesDelete in
            if yesDelete {
                self?.sendDelete()
            }
        }
    }
    
    private func confirmDelete(completer: @escaping (Bool)->()) {
        DestructiveConfirmationPresenter(title: "Delete this event?", message: "Are you sure you want to permanently delete this event?", acceptTitle: "Delete", rejectTitle: "Cancel", handler: { outcome in
            switch outcome {
            case .accepted: completer(true)
            case .rejected: completer(false)
            }
        }).present(in: self)
    }
    
    // MARK: - Table View Stuff
    
    private lazy var cells: [UITableViewCell] = {
        var cells = [nameCell, descriptionCell, locationCell, startDateCell, endDateCell]
        if case .editing = mode { cells.append(deleteButtonCell) }
        return cells
    }()
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cells.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return cells[indexPath.row]
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCell = cells[indexPath.row]
        
        if selectedCell == startDateCell {
            startDateSelected()
        } else if selectedCell == endDateCell {
            endDateSelected()
        } else if selectedCell == descriptionCell {
            launchDescriptionTextViewController()
        } else if selectedCell == locationCell {
            launchLocationPickerViewController()
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - Submission
    
    override func doneButtonWasPressed() {
        switch mode {
        case .creating: sendNewEvent()
        case .editing: sendUpdatedEvent()
        }
    }
    
    private func sendNewEvent() {
        guard case .creating = mode else { return }
        
        // Check for any necessary fields being left blank.
        let emptyFields = eventForm.getEmptyFields()
        guard emptyFields.isEmpty else {
            let errorMessage = "The follow fields cannot be blank: \(emptyFields.joined(separator: ", "))."
            displayError(message: errorMessage, {})
            submissionStatus = .waitingForInput
            return
        }
        
        submissionStatus = .submitting
        let e = eventForm
        networkManager.createEvent(groupId: e.groupId!, title: e.name!, description: e.description!, location: "", latitude: e.location!.coordinate.latitude, longitude: e.location!.coordinate.longitude, start: e.start!, end: e.end!) { [weak self] error in
            guard error == nil else {
                self?.displayError(message: "Something went wrong submitting your form!") { [weak self] in
                    self?.submissionStatus = .waitingForInput
                }
                return
            }
            self?.submissionStatus = .submitted
            self?.dismiss(animated: true)
        }
    }
    
    private func sendUpdatedEvent() {
        guard case .editing(let oldEvent) = mode else { return }
        submissionStatus = .submitting
        let updatedEvent = eventForm.merge(with: oldEvent)
        networkManager.update(event: updatedEvent) { [weak self] error in
            guard error == nil else {
                self?.displayError(message: "Something went wrong submitting your form!") { [weak self] in
                    self?.submissionStatus = .waitingForInput
                }
                return
            }
            self?.submissionStatus = .submitted
            self?.dismiss(animated: true)
        }
    }
    
    private func sendDelete() {
        guard case .editing(let oldEvent) = mode else { return }
        networkManager.delete(event: oldEvent.id) { [weak self] error in
            guard error == nil else {
                self?.displayError(message: "Something went wrong deleting your event!") { [weak self] in
                    self?.submissionStatus = .waitingForInput
                }
                return
            }
            self?.submissionStatus = .submitted
            self?.dismiss(animated: true)
        }
    }
    
}
