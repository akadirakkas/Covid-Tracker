//
//  ViewController.swift
//  Covid Tracker
//
//  Created by AbdulKadir Akkaş on 10.06.2021.
//

import UIKit
import Charts

class ViewController: UIViewController  , UITableViewDelegate , UITableViewDataSource{

    //MARK: -UIElements
    
    @IBOutlet weak var tableView: UITableView!
   
    
    
    
    //MARK: - Properties
   
    private var scope = RequestAPI.DataScope.national
    
    
    private var dayData : [DayData] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.createGraph()
            }
        }
    }
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        createFilterButton()
        fetctData()
        
    }
    
    
    //MARK: - Methods
    
    private func createGraph() {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.width/1.5))
        
        headerView.clipsToBounds = true
        
        let set = dayData.prefix(30)
        
        var entries : [BarChartDataEntry] = []
        
        for index in 0..<set.count{
        let data = set[index]
            entries.append(.init(x: Double(index), y: Double(data.count)))
        }
        
        let dataSet = BarChartDataSet(entries: entries)
        dataSet.colors = ChartColorTemplates.joyful()
        
        let data : BarChartData = BarChartData(dataSet: dataSet)
        
        let  chart = BarChartView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.width/1.5))
        chart.data =  data
        
        headerView.addSubview(chart)
       
        tableView.tableHeaderView = headerView
        
        
        
    }
    
    
    private func fetctData() {
        RequestAPI.shared.getCovidData(for: scope) {[weak self] result in
            switch result {
            case .success(let dayData) :
                self?.dayData = dayData
            case.failure(let error):
                print(error)
            }
        }
    }



    private func createFilterButton () {
        let buttonTitle : String = {
            switch scope {
            case .national : return "National"
            case .state(let state) : return state.name
            }
        }()
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: buttonTitle,
            style: .done,
            target: self,
            action: #selector(didTapFilter))
        
    }
   
    
    @objc private func didTapFilter() {
        let vc = FilterViewController()
        vc.completion = { [weak self] state in
            self?.scope = .state(state)
            self?.fetctData()
            self?.createFilterButton()
            
        }
        let navVc = UINavigationController(rootViewController: vc)
      present(navVc , animated: true)
        
    }
    
    func setupView() {
        title = "Covid Case"
        tableView.delegate = self
        tableView.dataSource = self
        
       
        
    }
    
    
    private func createText(with data : DayData) -> String {
        let dateString = DateFormatter.prettyFormatter.string(from: data.date)
        return " \(dateString) : \(data.count)"
    }
    
    
    
    //MARK: - Actions
 
    
    
    
    
    //MARK: - Table View
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         
        return dayData.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = dayData[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ViewControllerTableViewCell
        cell.textLabel?.text = createText(with: data)
        
        return cell
    }
    
}



//MARK: - Extensions

