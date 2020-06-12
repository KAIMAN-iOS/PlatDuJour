//
//  AddPictureViewController.swift
//  PlatDuJour
//
//  Created by GG on 04/06/2020.
//  Copyright © 2020 GG. All rights reserved.
//

import UIKit
import Photos

class AddContentViewController: UIViewController {

    var content: ShareModel.ModelType!
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

    private var viewModel : AddContentViewModel!
    static func create(with delegate: AddPictureCoordinatorDelegate, content: ShareModel.ModelType) -> AddContentViewController {
        let controller = AddContentViewController.loadFromStoryboard(identifier: "AddContentViewController", storyboardName: "AddContent") as! AddContentViewController
        controller.coordinatorDelegate = delegate
        controller.content = content
        controller.viewModel = AddContentViewModel(content: content)
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
        coordinatorDelegate?.showImagePicker(with: type, delegate: self)
    }
}

extension AddContentViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            
            switch self.content! {
            case .dailySpecial:
                guard let image = (info[.editedImage] ?? info[.originalImage]) as? UIImage else {
                    return
                }
                self.viewModel.update(image)
            case .event, .basic:
                guard let asset = info[.phAsset] as? PHAsset else {
                    return
                }
                self.viewModel.update(asset)
            }
            self.tableView.reloadData()
        }
    }
}

extension AddContentViewController: AddPictureCellDelegate {
    func showImagePicker() {
        // assure that both media types are available
        guard UIImagePickerController.isSourceTypeAvailable(.camera) == true, UIImagePickerController.isSourceTypeAvailable(.photoLibrary) == true else {
            showImagePicker(with: UIImagePickerController.isSourceTypeAvailable(.camera) ? .camera : .photoLibrary)
            return
        }
        
        let actionSheet = UIAlertController(title: "Choose an image".local(), message: nil, preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "From Library".local(), style: .default, handler: { [weak self] _ in
            self?.showImagePicker(with: .photoLibrary)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Take picture".local(), style: .default, handler: { [weak self] _ in
            self?.showImagePicker(with: .camera)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel".local(), style: .cancel, handler: { [weak self] _ in
//            self?.dismiss(animated: true, completion: nil)
        }))
        
        navigationController?.present(actionSheet, animated: true, completion: nil)
    }
}

//MARK: UITableViewDelegate
extension AddContentViewController: UITableViewDelegate {
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
extension AddContentViewController: UITableViewDataSource {
    
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

extension AddContentViewController: UpdateButtonDelegate {
    func updateButton(_ enabled: Bool) {
        continueButton.isEnabled = enabled
    }
}
