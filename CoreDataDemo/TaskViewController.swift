//
//  TaskViewController.swift
//  CoreDataDemo
//
//  Created by brubru on 29.09.2022.
//

import UIKit
import CoreData

class TaskViewController: UIViewController {
    
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    
    private lazy var taskTextField: UITextField = {
        let textField = UITextField()
        
        textField.placeholder = "New Task"
        textField.borderStyle = .roundedRect
        
        return textField
    }()
    
    private lazy var saveButton: UIButton = {
        createButton(
            with: "Save Task",
            and: UIColor(red: 21/255, green: 101/255, blue: 192/255, alpha: 1),
            action:  UIAction { _ in
                self.save()
            }
        )
    }()
    
    private lazy var cancelButton: UIButton = {
        createButton(
            with: "Cancel",
            and: .systemRed,
            action:  UIAction { _ in
                self.dismiss(animated: true)
            }
        )
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        setup(subviews: taskTextField, saveButton, cancelButton)
        setConstrains()
    }
    
    private func setup(subviews: UIView...) {
        subviews.forEach { subview in
            view.addSubview(subview)
        }
    }
    
    private func createButton(with title: String, and color: UIColor, action: UIAction) -> UIButton {
        var buttonConfiguration = UIButton.Configuration.filled()
        buttonConfiguration.baseBackgroundColor = color
        
        buttonConfiguration.buttonSize = .medium
        
        var attributes = AttributeContainer()
        attributes.font = UIFont.boldSystemFont(ofSize: 18)
        buttonConfiguration.attributedTitle = AttributedString(title, attributes: attributes)
        
        return UIButton(configuration: buttonConfiguration, primaryAction: action)
    }
    
    private func setConstrains() {
        taskTextField.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            taskTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: 80),
            taskTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            taskTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
        ])
        
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            saveButton.topAnchor.constraint(equalTo: taskTextField.bottomAnchor, constant: 20),
            saveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
        ])
        
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            cancelButton.topAnchor.constraint(equalTo: saveButton.bottomAnchor, constant: 20),
            cancelButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            cancelButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
        ])
    }
    
    private func save() {
//        guard let entityDescription = NSEntityDescription.entity(forEntityName: "Task", in: context) else { return }
//        guard let task = NSManagedObject(entity: entityDescription, insertInto: context) as? Task else { return }
        
        let task = Task(context: context)
        
        task.name = taskTextField.text
        
        if context.hasChanges {
            do {
                try context.save()
            } catch let error {
               print(error)
            }
        }
        dismiss(animated: true)
    }
    
}
