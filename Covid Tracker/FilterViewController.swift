//
//  FilterViewController.swift
//  Covid Tracker
//
//  Created by AbdulKadir Akkaş on 10.06.2021.
//

import UIKit


class FilterViewController: UIViewController  , UITableViewDelegate , UITableViewDataSource{

    //MARK: -UIElements

   
    
    
  
    
    
    //MARK: - Properties
    
    private let tableView : UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        return table
    }()
  
    public var completion : ((State) -> Void)?
    
    private var states : [State] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
           
        }
    }


    //MARK: - Life Cycle
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        fetchStates()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    
    //MARK: - Methods
    func setupView() {
        title = "Select State"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(didTapClose))
        
        view.addSubview(tableView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    
    
    private func fetchStates() {
        RequestAPI.shared.getStateList { [weak self] result in
            switch result {
            case .success(let states) :
                self?.states =  states
            case .failure(let error) :
                print(error)
            
            }
        }
        
    }
    
    
   @objc func didTapClose(){
        dismiss(animated: true, completion: nil)
    }
    
    
    
    //MARK: - Actions

   
    
    //MARK: Table View
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return states.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let state = states[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = state.name

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let state = states[indexPath.row]
        completion?(state)
        dismiss(animated: true, completion: nil)
    }

    
    

}

//MARK: - Extensions

