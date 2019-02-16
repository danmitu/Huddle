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
    
    private let networkManager = NetworkManager()
    
    var member: Member?
    
    var joinedGroups = [Group]()
    
    private var groupsToLeave = Set<Group>()
    
    private enum Section: Int, CaseIterable {
        case details
        case privacy
        case groups
    }
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableHeaderView = profilePhotoEditorView
        navigationItem.rightBarButtonItem = doneBarButton
        navigationItem.leftBarButtonItem = cancelBarButton
        self.tableView.isEditing = true
        self.tableView.allowsSelectionDuringEditing = true
        self.navigationItem.title = "Update Profile"
        self.nameCell.textField.delegate = self
        self.nameCell.textField.text = member?.name
        (self.displayGroupsCell.accessoryView as! UISwitch).isOn = member?.publicGroup ?? false
        (self.displayLocationCell.accessoryView as! UISwitch).isOn = member?.publicLocation ?? false
        locationCell.detailTextLabel!.text = member?.homeLocation?.name ?? ""
        profilePhotoEditorView.userProfileImageView.image = member?.profilePhoto
        
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
        cell.textField.placeholder = "enter name"
        cell.textField.returnKeyType = .done
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
        cell.textLabel!.text = "About Me"
        cell.accessoryType = .disclosureIndicator
        cell.selectionStyle = .none
        return cell
    }()
    
    private let changePasswordCell: ButtonTableViewCell = {
        let cell = ButtonTableViewCell()
        cell.button.setTitle("Change Password", for: .normal)
        cell.selectionStyle = .none
        cell.button.addTarget(self, action: #selector(passwordButtonWasPressed), for: .touchUpInside)
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
        cell.selectionStyle = .none
        return cell
    }()
    
    private let displayLocationCell: UITableViewCell = {
        let cell = UITableViewCell()
        let switchView = UISwitch(frame: .zero)
        switchView.setOn(false, animated: true)
        switchView.addTarget(self, action: #selector(locationPrivacySwitchDidChange), for: .valueChanged)
        cell.accessoryView = switchView
        cell.textLabel?.text = "Display Location"
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
        case .privacy: return 2
        case .groups: return joinedGroups.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch Section(rawValue: indexPath.section)! {
        case .details:
            switch indexPath.row {
            case 0: return nameCell
            case 1: return locationCell
            case 2: return aboutCell
            case 3: return changePasswordCell
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
            cell.textLabel?.text = joinedGroups[indexPath.row].title
            cell.selectionStyle = .none
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
            groupsToLeave.insert(joinedGroups[indexPath.row])
            joinedGroups.remove(at: indexPath.row)
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
                    self?.member?.homeLocation?.name = placemark.locality ?? ""
                    self?.member?.homeLocation?.location = placemark.location!
                    self?.navigationController?.popViewController(animated: true)
                }
                navigationController?.pushViewController(mapViewController, animated: true)
            case 2: // About Me Cell
                let textViewController = TextViewController()
                textViewController.navigationItem.title = "About Me"
                textViewController.setInitialText(member?.bio ?? "")
                textViewController.whenDoneEditing = { [weak self] text in
                    self?.member?.bio = text
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
        sendUpdates()
    }
    
    @objc func cancelButtonWasPressed() {
        self.dismiss(animated: true)
    }
    
    @objc func groupPrivacySwitchDidChange(_ sender: UISwitch) {
        member?.publicGroup = sender.isOn
    }
    
    @objc func locationPrivacySwitchDidChange(_ sender: UISwitch) {
        member?.publicLocation = sender.isOn
    }
    
    @objc func changeProfileImageButtonPressed() {
        presentImageOptions()
    }
    
    @objc func passwordButtonWasPressed() {
        let passwordResetViewController = ResetPasswordViewController(style: .grouped)
        let navigationViewController = UINavigationController(rootViewController: passwordResetViewController)
        present(navigationViewController, animated: true)
    }
    
    @objc func switchValueDidChange(sender:UISwitch!) {
        if displayGroupsCell.accessoryView == sender {
            member?.publicGroup = sender.isOn
        } else if displayLocationCell.accessoryView == sender {
            member?.publicLocation = sender.isOn
        }
    }
    
    // MARK: - Image Picker Controller Delegate
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true) {
            if let editedImage = info[.editedImage] as? UIImage {
                self.profilePhotoEditorView.userProfileImageView.maskCircle(withImage: editedImage)
                self.member?.profilePhoto = editedImage
            } else if let originalImage = info[.originalImage] as? UIImage {
                self.profilePhotoEditorView.userProfileImageView.maskCircle(withImage: originalImage)
                self.member?.profilePhoto = originalImage
            }
        }
    }
    
    // MARK: - Text Field Delegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == nameCell.textField {
            member?.name = nameCell.textField.text
        }
    }
    
    // MARK: - Other Methods
    
    func sendUpdates() {
        guard let member = member else { return }
        setButtons(for: .submitting)
        
        let dispatchGroup = DispatchGroup()
        
        dispatchGroup.enter()
        networkManager.update(member: member) { error in
            if let error = error { print(error) }
            dispatchGroup.leave()
        }
        
        groupsToLeave.forEach {
            dispatchGroup.enter()
            networkManager.removeSelf(fromGroup: $0.id) { error in
                if let error = error { print(error) }
                dispatchGroup.leave()
            }
        }
        
        if let profilePhoto = member.profilePhoto {
            dispatchGroup.enter()
            networkManager.upload(memberProfileImage: profilePhoto) { error in
                if let error = error { print(error) }
                dispatchGroup.leave()
            }
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
