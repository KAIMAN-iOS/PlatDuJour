//
//  AddPictureViewController.swift
//  PlatDuJour
//
//  Created by GG on 04/06/2020.
//  Copyright © 2020 GG. All rights reserved.
//

import UIKit

class AddPictureViewController: UIViewController {

    @IBOutlet var tableView: UITableView!  {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
            tableView.commonInit()
            tableView.estimatedRowHeight = 250
        }
    }

    @IBOutlet var continueButton: ActionButton!  {
        didSet {
            continueButton.actionButtonType = .primary
            continueButton.isEnabled = false
        }
    }

    private let viewModel : AddPictureViewModel = AddPictureViewModel()
    static func create(with delegate: AddPictureCoordinatorDelegate) -> AddPictureViewController {
        let controller = AddPictureViewController.loadFromStoryboard(identifier: "AddPictureViewController", storyboardName: "AddPicture") as! AddPictureViewController
        controller.coordinatorDelegate = delegate
        return controller
    }
    weak var coordinatorDelegate: AddPictureCoordinatorDelegate? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.showPickerDelegate = self
        viewModel.updateButtonDelegate = self
        title = "Choose an image".local()
    }
    
    private func showImagePicker(with type: UIImagePickerController.SourceType) {
        let picker = UIImagePickerController()
        picker.sourceType = type
        picker.delegate = self
        present(picker, animated: true, completion: nil)
    }
}

extension AddPictureViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            guard let image = (info[.editedImage] ?? info[.originalImage]) as? UIImage else {
                return
            }
            self.viewModel.update(image)
            self.tableView.reloadData()
        }
    }
}

extension AddPictureViewController: AddPictureCellDelegate {
    func showImagePicker() {
        // assure that both media types are available
        guard UIImagePickerController.isSourceTypeAvailable(.camera) == true, UIImagePickerController.isSourceTypeAvailable(.photoLibrary) == true else {
            showImagePicker(with: UIImagePickerController.isSourceTypeAvailable(.camera) ? .camera : .photoLibrary)
            return
        }
        
        let actionSheet = UIAlertController(title: "Choose an image".local(), message: nil, preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "From Library", style: .default, handler: { [weak self] _ in
            self?.dismiss(animated: true) { [weak self] in
                self?.showImagePicker(with: .photoLibrary)
            }
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Take picture", style: .default, handler: { [weak self] _ in
            self?.dismiss(animated: true) { [weak self] in
                self?.showImagePicker(with: .camera)
            }
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { [weak self] _ in
            self?.dismiss(animated: true, completion: nil)
        }))
        
        present(actionSheet, animated: true, completion: nil)
    }
}

//MARK: UITableViewDelegate
extension AddPictureViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        viewModel.didSelectRow(at: indexPath, in: tableView)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return viewModel.heightForHeader(in: section)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return viewModel.header(for: section)
    }
}

//MARK: UITableViewDataSource
extension AddPictureViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows(in: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return viewModel.configureCell(at: indexPath, in: tableView)
    }
}

extension AddPictureViewController: UpdateButtonDelegate {
    func updateButton(_ enabled: Bool) {
        continueButton.isEnabled = enabled
    }
}
