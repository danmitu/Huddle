//
//  GroupEditorViewController.swift
//  Huddle
//
//  Team Atlas - OSU Capstone - Winter '19
//  Gerry Ashlock and Dan Mitu
//

import UIKit
import MapKit
import CoreLocation

fileprivate struct GroupForm {
    var title: String?
    var description: String?
    var location: CLLocation?
    var locationName: String?
    var category: Category?
    
    init() {
        self.title = nil
        self.description = nil
        self.location = nil
        self.locationName = nil
        self.category = nil
    }
    
    init(previous group: Group) {
        self.title = group.title
        self.description = group.description
        self.location = group.location.location
        self.locationName = group.location.name
        self.category = group.category
    }
    
    func getEmptyFields() -> [String] {
        var b = [String]()
        if title == nil { b.append("name") }
        if description == nil { b.append("description") }
        if location == nil { b.append("location") }
        if category == nil { b.append("category") }
        return b
    }
    
    func merge(with previousGroup: Group) -> Group {
        
        let namedLocation = NamedLocation(id: previousGroup.location.id,
                                          name: self.locationName ?? previousGroup.location.name,
                                          location: self.location ?? previousGroup.location.location)
        
        return Group(id: previousGroup.id,
                     title: self.title ?? previousGroup.title,
                     description: self.description ?? previousGroup.description,
                     ownerId: previousGroup.ownerId,
                     ownerName: previousGroup.ownerName,
                     location: namedLocation,
                     distance: previousGroup.distance,
                     category: self.category ?? previousGroup.category)
    }

}

class GroupEditorViewController: FormTableViewController {
    
    init(for mode: Mode) {
        self.mode = mode
        switch mode {
        case .creating:
            self.groupForm = GroupForm()
            cells = [ titleCell, aboutCell, categoryCell, locationCell ]
            super.init(style: .grouped)
        case .editing(group: let g):
            self.groupForm = GroupForm(previous: g)
            self.cells = [ titleCell, aboutCell, categoryCell, locationCell, deleteButtonCell ]
            super.init(style: .grouped)
            self.setAllCells(to: groupForm)
        }
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) is not supported") }
    
    private let networkManager = NetworkManager()
    
    private var groupForm: GroupForm
    
    let mode: Mode
    
    enum Mode {
        case creating /// creating a new group
        case editing(group: Group) /// editing an existing group
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = {
            switch mode {
            case .creating: return "New Group"
            case .editing: return "Edit Group"
            }
        }()
        
        titleCell.textField.addTarget(self, action: #selector(updateTitle), for: .editingChanged)
    }
    
    private let cells: [UITableViewCell]
    
    private func setAllCells(to group: GroupForm) {
        if let title = group.title { setTitleView(to: title) }
        if let location = group.location { setLocationView(to: location) }
        if let category = group.category { setCategoryView(to: category) }
    }
    
    // MARK: - Title
    
    private let titleCell: TitledTextFieldTableViewCell = {
        let cell = TitledTextFieldTableViewCell(reuseIdentifier: "TitledTextFieldTableViewCell")
        cell.titleLabel.text = "Name"
        cell.textField.placeholder = "enter name"
        cell.textField.returnKeyType = .done
        cell.selectionStyle = .none
        return cell
    }()
    
    private func setTitleView(to string: String) {
        titleCell.textField.text = string
    }
    
    @objc private func updateTitle() {
        groupForm.title = titleCell.textField.text
    }
    
    // MARK: - About
    
    private let aboutCell: UITableViewCell = {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: nil)
        cell.textLabel!.text = "About"
        cell.accessoryType = .disclosureIndicator
        cell.selectionStyle = .none
        return cell
    }()
    
    func launchAboutGroupTextViewController() {
        let textViewController = TextViewController()
        textViewController.setInitialText(groupForm.description ?? "")
        textViewController.whenDoneEditing = { [weak self] string in
            self?.groupForm.description = string
        }
        navigationController?.pushViewController(textViewController, animated: true)
    }

    // MARK: - Category
    
    private let categoryCell: UITableViewCell = {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: nil)
        cell.textLabel!.text = "Category"
        cell.accessoryType = .disclosureIndicator
        cell.selectionStyle = .none
        return cell
    }()
    
    private func launchCategoryPicker() {
        let categoryViewController = CategoryViewController()
        categoryViewController.whenSelected = { [weak self] category in
            self?.updateCategory(category)
            self?.setCategoryView(to: category)
        }
        navigationController?.pushViewController(categoryViewController, animated: true)
    }
    
    private func setCategoryView(to category: Category) {
        categoryCell.detailTextLabel?.text = category.name
    }
    
    private func updateCategory(_ category: Category) {
        groupForm.category = category
    }
    
    // MARK: - Location
    
    private let locationCell: UITableViewCell = {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: nil)
        cell.textLabel!.text = "Location"
        cell.accessoryType = .disclosureIndicator
        cell.selectionStyle = .none
        return cell
    }()
    
    func launchLocationPickerViewController() {
        let mapViewController = ChooseLocationViewController()
        mapViewController.navigationItem.title = "Location"
        mapViewController.whenDoneSelecting = { [weak self] placemark in
            if let location = placemark.location {
                self?.groupForm.location = location
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
            self?.groupForm.locationName = locationName
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
        DestructiveConfirmationPresenter(title: "Delete this event?", message: "Are you sure you want to permanently delete this group?", acceptTitle: "Delete", rejectTitle: "Cancel", handler: { outcome in
            switch outcome {
            case .accepted: completer(true)
            case .rejected: completer(false)
            }
        }).present(in: self)
    }


    // MARK: - Table View Stuff
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        assert(section == 0)
        return cells.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return cells[indexPath.row]
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCell = cells[indexPath.row]
        
        if selectedCell == aboutCell {
            launchAboutGroupTextViewController()
        } else if selectedCell == categoryCell {
            launchCategoryPicker()
        } else if selectedCell == locationCell {
            launchLocationPickerViewController()
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - Other
    
    override func doneButtonWasPressed() {
        switch mode {
        case .creating: sendNewGroup()
        case .editing: sendUpdatedGroup()
        }
    }

    private func sendNewGroup() {
        guard case .creating = mode else { return }

        // Check for any necessary fields being left blank.
        let emptyFields = groupForm.getEmptyFields()
        guard emptyFields.isEmpty else {
            let errorMessage = "The follow fields cannot be blank: \(emptyFields.joined(separator: ", "))."
            displayError(message: errorMessage, {})
            submissionStatus = .waitingForInput
            return
        }
        
        submissionStatus = .submitting
        networkManager.createGroup(title: groupForm.title!,
                                   description: groupForm.title!,
                                   locationName: groupForm.locationName!,
                                   latitude: (groupForm.location?.coordinate.latitude)!,
                                   longitude: (groupForm.location?.coordinate.longitude)!,
                                   category: groupForm.category!,
                                   completion: requestHandler)
    }
    
    private func sendUpdatedGroup() {
        guard case .editing(let oldGroup) = mode else { return }
        let updatedGroup = groupForm.merge(with: oldGroup)
        networkManager.update(group: updatedGroup, completion: requestHandler)
    }
    
    private func sendDelete() {
        guard case .editing(let oldGroup) = mode else { return }
        submissionStatus = .submitting
        networkManager.delete(group: oldGroup.id, completion: requestHandler)
    }
    
}
