//
//  DetailViewController.swift
//  HomePwner
//
//  Created by Nazmul Islam on 9/3/19.
//  Copyright © 2019 Nazmul Islam. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var serialNumberField: UITextField!
    @IBOutlet weak var valueField: UITextField!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet weak var dateLabel: UIButton!
    
    var item: Item! {
        didSet {
            navigationItem.title = item.name
        }
    }
    var imageStore: ImageStore!
    
    let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter
    }()
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        nameField.text = item.name
        serialNumberField.text = item.serialNumber
        valueField.text = numberFormatter.string(from: NSNumber(value: item.valueInDollars))
        dateLabel.setTitle(dateFormatter.string(from: item.dateCreated), for: .normal)
        
        imageView.image = imageStore.image(forKey: item.itemKey)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Resign first responder
        view.endEditing(true)
        
        // Save changes to item
        item.name = nameField.text ?? ""
        item.serialNumber = serialNumberField.text
        
        if let valueText = valueField.text, let value = numberFormatter.number(from: valueText) {
            item.valueInDollars = value.intValue
        } else {
            item.valueInDollars = 0
        }
    }
    
    @IBAction func takePicture(_ sender: UIBarButtonItem) {
        let imagePicker = UIImagePickerController()
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker.sourceType = .camera
            imagePicker.cameraOverlayView = CrosshairView(frame: view.bounds)
        } else {
            imagePicker.sourceType = .photoLibrary
        }
        
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func deletePicture(_ sender: UIBarButtonItem) {
        imageStore.deleteImage(forKey: item.itemKey)
        imageView.image = nil
    }
    
    @IBAction func backgroundTapped(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "PickDateCreated":
            guard let datePickerController = segue.destination as? DatePickerViewController else {
                return
            }
            
            datePickerController.item = item
            
        default:
            preconditionFailure("Unexpected segue identifier!. Expected: PickDateCreated, Found: \(String(describing: segue.identifier))")
        }
    }
}

extension DetailViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension DetailViewController: UINavigationControllerDelegate {
    
}

extension DetailViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
            return
        }
        
        // Store the image in the ImageStore for item's key
        imageStore.setImage(image, forKey: item.itemKey)
        
        imageView.image = image
        
        dismiss(animated: true, completion: nil)
    }
}
