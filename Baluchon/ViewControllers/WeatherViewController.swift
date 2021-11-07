//
//  WeatherViewController.swift
//  Baluchon
//
//  Created by JEAN SEBASTIEN BRUNET on 5/11/21.
//

import UIKit

class WeatherViewController: UIViewController {
    
    @IBOutlet weak var detailsView: UIView!
    @IBOutlet weak var currentConditionsView: UIView!
    @IBOutlet weak var currentConditionsBottomView: UIView!
    @IBOutlet weak var detailsBottomView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeRoundCornersToViews()
    }

    private func makeRoundCornersToViews() {
        detailsView.layer.cornerRadius = 10
        currentConditionsView.layer.cornerRadius = 10
        detailsBottomView.layer.cornerRadius = 10
        currentConditionsBottomView.layer.cornerRadius = 10
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
