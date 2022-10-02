//
//  ViewController.swift
//  CoreDataDemo
//
//  Created by brubru on 29.09.2022.
//

import UIKit

class TaskListViewController: UITableViewController {
    
    //MARK: - Private Properties
    private let context = StorageManager.shared.persistentContainer.viewContext
    private let cellID = "task"
    private var taskList: [Task] = []
    
    //MARK: - Override Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
        setupNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchData()
        tableView.reloadData()
    }
    //MARK: - Private Methods
    private func setupNavigationBar() {
        title = "Task List"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        navBarAppearance.backgroundColor = UIColor(
            red: 21/255,
            green: 101/255,
            blue: 192/255,
            alpha: 194/255
        )
        
        navigationController?.navigationBar.standardAppearance = navBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addNewTask)
        )
        
        navigationController?.navigationBar.tintColor = .white
    }
    
    @objc private func addNewTask() {
        showAlert(with: "New Task", and: "What do you want to do?")
    }
    
    private func fetchData() {
        let fetchRequest = Task.fetchRequest()
        
        do {
            taskList = try context.fetch(fetchRequest)
        } catch {
            print("Failed to fetch data", error)
        }
    }
}
//MARK: - Extensions

extension TaskListViewController {
    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        taskList.count
    }
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID,
                                                 for: indexPath)
        
        let task = taskList[indexPath.row]
        var content = cell.defaultContentConfiguration()
        content.text = task.name
        cell.contentConfiguration = content
        return cell
    }
    // удаление строки
    override func tableView(_ tableView: UITableView,
                            commit editingStyle: UITableViewCell.EditingStyle,
                            forRowAt indexPath: IndexPath) {
        let task = taskList[indexPath.row]
        context.delete(task)
        taskList.remove(at: indexPath.row)
        StorageManager.shared.saveContext()
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    // изменения строки
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let taskList = taskList[indexPath.row]
        let alert = UIAlertController(title: "Update task",
                                      message: "Would you like to update?",
                                      preferredStyle: .alert)
        let chageAction = UIAlertAction(title: "Update", style: .default)
        { [unowned self] _ in
            guard let task = alert.textFields?.first?.text else { return }
            context.name = task
            taskList.setValue(context.name , forKey: "name") // ключ из CoreDate
            StorageManager.shared.saveContext()
            tableView.reloadData()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
        alert.addAction(chageAction)
        alert.addAction(cancelAction)
        alert.addTextField()
        
        present(alert, animated: true)
    }
    
    private func showAlert(with title: String, and messege: String) {
        let alert = UIAlertController(title: title, message: messege,
                                      preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
            guard let task = alert.textFields?.first?.text,
                  !task.isEmpty else { return }
            self.save(task)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        alert.addTextField { textField in
            textField.placeholder = "New Task"
        }
        
        present(alert, animated: true)
    }
    
    private func save(_ taskName: String) {
        let task = Task(context: context)
        task.name = taskName
        taskList.append(task)
        
        let cellIndex = IndexPath(row: taskList.count - 1, section: 0)
        tableView.insertRows(at: [cellIndex], with: .automatic)
        
        do {
            try context.save()
        } catch {
            print(error)
        }
    }
}
