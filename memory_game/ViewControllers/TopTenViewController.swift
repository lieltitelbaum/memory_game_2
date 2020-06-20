//
//  TopTenViewController.swift
//  memory_game
//
//  Created by Liel Titelbaum on 19/06/2020.
//  Copyright © 2020 Liel Titelbaum. All rights reserved.
//

import UIKit
import MapKit

class TopTenViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var topTenTable: UITableView!
    
    private var myUserDef = MyUserDefaults()
    
    var highScores = [HighScore]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        highScores = myUserDef.retriveUserDefualts()
        topTenTable.delegate = self
        topTenTable.dataSource = self
    }
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//
//        if self.isMovingFromParent {
//            let vc = GameViewController()
//            vc.initGame()
//        }
//    }
}


extension TopTenViewController : CLLocationManagerDelegate
{
    func createPinPointOnMap(location: Location,title: String){
        let mkAnnotation: MKPointAnnotation = MKPointAnnotation()
        mkAnnotation.coordinate = CLLocationCoordinate2DMake(location.latitude, location.longitude)
        mkAnnotation.title = title
        mapView.addAnnotation(mkAnnotation)
    }
    
    func createRegion(location:Location){
        let mRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: location.latitude,longitude: location.longitude),latitudinalMeters: 1000, longitudinalMeters: 1000)
        mapView.setRegion(mRegion, animated: true)
    }
    
}

extension TopTenViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return highScores.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = self.topTenTable.dequeueReusableCell(withIdentifier: "HighScoreRow", for: indexPath) as? HighScoreTableViewCell
        
        cell?.index_in_row.text = "\(indexPath.row + 1))"
        cell?.playerName.text = self.highScores[indexPath.row].playerName
        cell?.dateTime.text = self.highScores[indexPath.row].gameDate
        cell?.score.text = "\(self.highScores[indexPath.row].score)"
        
        createPinPointOnMap(location: self.highScores[indexPath.row].gameLocation, title: self.highScores[indexPath.row].gameDate)
        
        if (cell == nil){
            cell = HighScoreTableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "HighScoreRow")
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        createRegion(location: self.highScores[indexPath.row].gameLocation)
    }
    
}
