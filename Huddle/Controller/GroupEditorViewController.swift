//
//  GroupEditorViewController.swift
//  Huddle
//
//  Created by Gerry Ashlock on 2/19/19.
//  Copyright © 2019 Dan Mitu. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class GroupEditorViewController: UITableViewController, UINavigationControllerDelegate, UITextFieldDelegate, ImageOptionsGiver {
    
    private let networkManager = NetworkManager()
    
    var group: Group?
    
    var joinedGroups = [Group]()
    
    private var groupsToLeave = Set<Group>()
    
    private enum Section: Int, CaseIterable {
        case details
    }
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = doneBarButton
        navigationItem.leftBarButtonItem = cancelBarButton
        self.tableView.isEditing = true
        self.tableView.allowsSelectionDuringEditing = true
        self.navigationItem.title = "Update Group"
        self.titleCell.textField.delegate = self
        self.titleCell.textField.text = group?.title
        locationCell.detailTextLabel!.text = group?.location?.name ?? ""
        categoryCell.detailTextLabel!.text = group?.category.name
        
        // cannot be done at initialization 😢
        doneBarButton.target = self
        doneBarButton.action = #selector(doneButtonWasPressed)
        cancelBarButton.target = self
        cancelBarButton.action = #selector(cancelButtonWasPressed)
    }
    
    // MARK: - Other Views
    
    private let doneBarButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: nil)
    
    private lazy var cancelBarButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: nil, action: nil)
    
    private let activityIndicatorBarItem = UIBarButtonItem(customView: UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 20, height: 20)))
    
    // MARK: - Static Cells
    
    // MARK: Personal Section
    
    private let titleCell: TitledTextFieldTableViewCell = {
        let cell = TitledTextFieldTableViewCell(reuseIdentifier: "TitledTextFieldTableViewCell")
        cell.titleLabel.text = "Name"
        cell.textField.placeholder = "enter name"
        cell.textField.returnKeyType = .done
        cell.selectionStyle = .none
        return cell
    }()
    
    
    private let categoryCell: UITableViewCell = {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: nil)
        cell.textLabel!.text = "Category"
        cell.accessoryType = .disclosureIndicator
        cell.selectionStyle = .none
        return cell
    }()
    
    private let locationCell: UITableViewCell = {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: nil)
        cell.textLabel!.text = "Location"
        cell.accessoryType = .disclosureIndicator
        cell.selectionStyle = .none
        return cell
    }()
    
    private let aboutCell: UITableViewCell = {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: nil)
        cell.textLabel!.text = "About Group"
        cell.accessoryType = .disclosureIndicator
        cell.selectionStyle = .none
        return cell
    }()
    
    // MARK: - Table View Data Source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return Section.allCases.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch Section(rawValue: section)! {
        case .details: return 4
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch Section(rawValue: indexPath.section)! {
        case .details:
            switch indexPath.row {
            case 0: return titleCell
            case 1: return locationCell
            case 2: return categoryCell
            case 3: return aboutCell
            default: fatalError("Unreachable")
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch Section(rawValue: section)! {
        default: return nil
        }
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        switch Section(rawValue: indexPath.section)! {
        default:
            return false
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch Section(rawValue: indexPath.section)! {
        default:
            return
        }
    }
    
    // MARK: - Table View Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch Section(rawValue: indexPath.section)! {
        case .details:
            switch indexPath.row {
            case 1: // Loation Cell
                let mapViewController = ChooseLocationViewController()
                mapViewController.navigationItem.title = "Location"
                mapViewController.whenDoneSelecting = { [weak self] placemark in
                    self?.locationCell.detailTextLabel?.text = placemark.locality
                    self?.group?.location?.name = placemark.locality ?? ""
                    self?.group?.location?.location = placemark.location!
                    self?.navigationController?.popViewController(animated: true)
                }
                navigationController?.pushViewController(mapViewController, animated: true)
            case 2: // Category Cell
                let tableViewController = CategoryViewController(style: .grouped)
                tableViewController.navigationItem.title = "Select Category"
                tableViewController.whenSelected = { [weak self] category in
                    self?.group?.category = category
//                    self?.categoryCell.textLabel?.text = category.name
                    self?.viewDidLoad()
                }
                navigationController?.pushViewController(tableViewController, animated: true)
                
            case 3: // About Me Cell
                let textViewController = TextViewController()
                textViewController.navigationItem.title = "About Group"
                textViewController.setInitialText(group?.description ?? "")
                textViewController.whenDoneEditing = { [weak self] text in
                    self?.group?.description = text
                }
                navigationController?.pushViewController(textViewController, animated: true)
            default: break
            }
        }
        
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        switch Section(rawValue: indexPath.section)! {
        default: return .none
        }
    }
    
    // MARK: - Actions
    
    @objc func doneButtonWasPressed() {
        sendUpdates()
    }
    
    @objc func cancelButtonWasPressed() {
        self.dismiss(animated: true)
    }
    
    @objc func changeProfileImageButtonPressed() {
        presentImageOptions()
    }
    
    @objc func passwordButtonWasPressed() {
        let passwordResetViewController = ResetPasswordViewController(style: .grouped)
        let navigationViewController = UINavigationController(rootViewController: passwordResetViewController)
        present(navigationViewController, animated: true)
    }
    
    // MARK: - Text Field Delegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == titleCell.textField {
            group?.title = titleCell.textField.text
        }
    }
    
    // MARK: - Other Methods
    
    func sendUpdates() {
        guard let group = group else { return }
        setButtons(for: .submitting)
        
        let dispatchGroup = DispatchGroup()
        
        dispatchGroup.enter()
        networkManager.update(group: group) { error in
            if let error = error { print(error) }
            dispatchGroup.leave()
        }
        
        dispatchGroup.notify(queue: .main) { [weak self] in
            self?.setButtons(for: .waitingForInput)
            self?.dismiss(animated: true)
        }
        
    }
    
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
