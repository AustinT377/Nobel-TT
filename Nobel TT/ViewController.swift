//
//  ViewController.swift
//  Nobel TT
//
//  Created by Austin Turner on 10/21/20.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, updateSpaceTimeProtocol {
    
    let laureatesMgr = LaureatesModel()
    var location = LocationManager.shared.getCurrentLocation()
    var date = Date()

    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func updateSpaceTime(_ sender: Any) {
        self.performSegue(withIdentifier: "showSpaceTimePopup", sender: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "LaureateTableViewCell", bundle: nil), forCellReuseIdentifier: "laureateCell")
                
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 75, right: 0)
        
        self.startLoading()
        
        DispatchQueue.global(qos: .userInitiated).async { [weak self ] in
            self?.laureatesMgr.getLaureates { (error) in
                DispatchQueue.main.async {
                    self?.stopLoading()
                    if error == nil {
                        self?.sortLaureates()
                    }
                    else {
                        self?.showAlert(title: "Error", message: error!.localizedDescription)
                    }
                }
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationViewController = segue.destination as? SelectSpaceTimeViewController {
            destinationViewController.location = self.location
            destinationViewController.date = self.date
            destinationViewController.delegate = self
        }
    }
    
    func sortLaureates() {
        self.startLoading()
        self.laureatesMgr.sortLaureates(date: self.date, location: self.location) { [weak self] (completed) in
            DispatchQueue.main.async {
                if completed {
                    self?.tableView.reloadData()
                    let indexPath = IndexPath(row: 0, section: 0)
                    self?.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
                    self?.stopLoading()
                }
                else {
                    self?.showAlert(title: "Error", message: "An error occured sorting the data")
                }
            }
        }
    }
    
    func updateSpaceTime(coordinates: CLLocation, date: Date) {
        self.date = date
        self.location = coordinates
        self.sortLaureates()
    }
}



extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let laureateCount = self.laureatesMgr.laureates.count
        if laureateCount <= 20 {
            return laureateCount
        }
        else {
            return 20
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let laureat = self.laureatesMgr.laureates[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "laureateCell", for: indexPath) as! LaureateTableViewCell
                
        cell.bornCityLabel.text = laureat.borncity
        cell.bornYearLabel.text = "Born: " + laureat.born
        cell.categoryLabel.text = laureat.category
        cell.diedCityLabel.text = laureat.diedcity
        cell.diedYearLabel.text = "Died: " + laureat.died
        cell.nameLabel.text = laureat.firstname + " " + laureat.surname
        cell.schoolLabel.text = laureat.name
        cell.yearLabel.text = String(describing: laureat.year!)

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
}
