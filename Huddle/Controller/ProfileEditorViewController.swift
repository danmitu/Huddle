//
//  ProfileEditorViewController.swift
//  Huddle
//
//  Created by Dan Mitu on 1/30/19.
//  Copyright © 2019 Dan Mitu. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ProfileEditorViewController: UITableViewController, UINavigationControllerDelegate, UITextFieldDelegate, ImageOptionsGiver {
    
    private enum Section: Int, CaseIterable {
        case details
        case privacy
        case groups
    }
    
    // TODO: delete me
    var sampleGroupData = [
        "Group Name 1",
        "Group Name 2",
        "Group Name 3"
    ]
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableHeaderView = profilePhotoEditorView
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonWasPressed))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonWasPressed))
        self.tableView.isEditing = true
        self.tableView.allowsSelectionDuringEditing = true
        self.nameCell.textField.delegate = self
    }
    
    // MARK: - Other Views
    
    let profilePhotoEditorView: ProfilePhotoEditorView = {
       let view = Bundle.main.loadNibNamed("ProfilePhotoEditorView", owner: self, options: nil)![0] as! ProfilePhotoEditorView
        view.autoresizingMask = .flexibleWidth
        view.translatesAutoresizingMaskIntoConstraints = true
        view.changeProfileButton.addTarget(self, action: #selector(changeProfileImageButtonPressed), for: .touchUpInside)
        view.userProfileImageView.maskCircle(withImage: UIImage(named: "User Profile Placeholder")!)
        view.userProfileImageView.layer.borderColor = UIColor.white.cgColor
        view.userProfileImageView.layer.borderWidth = 4
        return view
    }()
    
    // MARK: - Static Cells
    
    // MARK: Personal Section
    
    private let nameCell: TitledTextFieldTableViewCell = {
        let cell = TitledTextFieldTableViewCell(reuseIdentifier: "TitledTextFieldTableViewCell")
        cell.titleLabel.text = "Name"
        cell.textField.placeholder = "Name"
        cell.textField.returnKeyType = .done
        return cell
    }()
    
    private let locationCell: UITableViewCell = {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: nil)
        cell.textLabel!.text = "Location"
        cell.accessoryType = .disclosureIndicator
        cell.detailTextLabel!.text = "Portland"
        return cell
    }()
    
    private let aboutCell: UITableViewCell = {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: nil)
        cell.textLabel!.text = "About Me"
        cell.accessoryType = .disclosureIndicator
        return cell
    }()
    
    // MARK: Privacy Section
    
    private let displayGroupsCell: UITableViewCell = {
        let cell = UITableViewCell()
        let switchView = UISwitch(frame: .zero)
        switchView.setOn(false, animated: true)
        switchView.addTarget(self, action: #selector(groupPrivacySwitchDidChange), for: .valueChanged)
        cell.accessoryView = switchView
        cell.textLabel?.text = "Display Groups"
        return cell
    }()
    
    private let displayLocationCell: UITableViewCell = {
        let cell = UITableViewCell()
        let switchView = UISwitch(frame: .zero)
        switchView.setOn(false, animated: true)
        switchView.addTarget(self, action: #selector(locationPrivacySwitchDidChange), for: .valueChanged)
        cell.accessoryView = switchView
        cell.textLabel?.text = "Display Location"
        return cell
    }()
    
    // MARK: - Table View Data Source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return Section.allCases.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch Section(rawValue: section)! {
        case .details: return 3
        case .privacy: return 2
        case .groups: return sampleGroupData.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch Section(rawValue: indexPath.section)! {
        case .details:
            switch indexPath.row {
            case 0: return nameCell
            case 1: return locationCell
            case 2: return aboutCell
            default: fatalError("Unreachable")
            }
        case .privacy:
            switch indexPath.row {
            case 0: return displayGroupsCell
            case 1: return displayLocationCell
            default: fatalError("Unreachable")
            }
        case .groups:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell") ?? UITableViewCell(style: .default, reuseIdentifier: "TableViewCell")
            cell.textLabel?.text = sampleGroupData[indexPath.row]
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch Section(rawValue: section)! {
        case .privacy: return "Privacy"
        case .groups: return "Groups"
        default: return nil
        }
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        switch Section(rawValue: indexPath.section)! {
        case .groups:
            return true
        default:
            return false
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch Section(rawValue: indexPath.section)! {
        case .groups:
            sampleGroupData.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
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
                    self?.navigationController?.popViewController(animated: true)
                }
                navigationController?.pushViewController(mapViewController, animated: true)
            case 2: // About Me Cell
                let textViewController = TextViewController()
                textViewController.navigationItem.title = "About Me"
                textViewController.setInitialText("This is the about me section.")
                textViewController.whenDoneEditing = { [weak self] text in
                    // TODO: Store the text somewhere.
                    print("received = \(text)")
                }
                navigationController?.pushViewController(textViewController, animated: true)
            default: break
            }
        default: break
        }
        
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        switch Section(rawValue: indexPath.section)! {
        case .groups: return .delete
        default: return .none
        }
    }
    
    // MARK: - Actions
    
    @objc func doneButtonWasPressed() {
        self.dismiss(animated: true)
    }
    
    @objc func cancelButtonWasPressed() {
        self.dismiss(animated: true)
    }
    
    @objc func groupPrivacySwitchDidChange(_ sender: UISwitch) { }
    
    @objc func locationPrivacySwitchDidChange(_ sender: UISwitch) { }
    
    @objc func changeProfileImageButtonPressed() {
        presentImageOptions()
    }

    // MARK: - Image Picker Controller Delegate

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true) {
            if let editedImage = info[.editedImage] as? UIImage {
                self.profilePhotoEditorView.userProfileImageView.maskCircle(withImage: editedImage)
            } else if let originalImage = info[.originalImage] as? UIImage {
                self.profilePhotoEditorView.userProfileImageView.maskCircle(withImage: originalImage)
            }
        }
    }
    
    // MARK: - Text Field Delegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }

}
