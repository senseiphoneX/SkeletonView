//
//  ViewController.swift
//  SkeletonViewExample
//
//  Created by Juanpe Catalán on 02/11/2017.
//  Copyright © 2017 SkeletonView. All rights reserved.
//

import UIKit
import SkeletonView

let colors = [(UIColor.turquoise,"turquoise"), (UIColor.emerald,"emerald"), (UIColor.peterRiver,"peterRiver"), (UIColor.amethyst,"amethyst"),(UIColor.wetAsphalt,"wetAsphalt"), (UIColor.nephritis,"nephritis"), (UIColor.belizeHole,"belizeHole"), (UIColor.wisteria,"wisteria"), (UIColor.midnightBlue,"midnightBlue"), (UIColor.sunFlower,"sunFlower"), (UIColor.carrot,"carrot"), (UIColor.alizarin,"alizarin"),(UIColor.clouds,"clouds"), (UIColor.concrete,"concrete"), (UIColor.flatOrange,"flatOrange"), (UIColor.pumpkin,"pumpkin"), (UIColor.pomegranate,"pomegranate"), (UIColor.silver,"silver"), (UIColor.asbestos,"asbestos")]

class ViewController: UIViewController {
    
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var colorSelectedView: UIView! {
        didSet {
            colorSelectedView.layer.cornerRadius = 5
            colorSelectedView.layer.masksToBounds = true
            colorSelectedView.backgroundColor = SkeletonDefaultConfig.tintColor
        }
    }

    @IBOutlet weak var switchAnimated: UISwitch!
    @IBOutlet weak var switchHidden: UISwitch!
    @IBOutlet weak var skeletonTypeSelector: UISegmentedControl!
    
    var type: SkeletonType {
        return skeletonTypeSelector.selectedSegmentIndex == 0 ? .solid : .gradient
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        view.showAnimatedSkeleton()
    }

    @IBAction func changeAnimated(_ sender: Any) {
        if switchAnimated.isOn {
            view.startSkeletonAnimation()
        } else {
            view.stopSkeletonAnimation()
        }
    }
    
    @IBAction func changeHidden(_ sender: Any) {
        if switchHidden.isOn {
            view.hideSkeleton()
        } else {
            if type == .gradient { showGradientSkeleton() }
            else { showSolidSkeleton() }
        }
    }

    @IBAction func changeSkeletonType(_ sender: Any) {
        refreshSkeleton()
    }
    
    @IBAction func btnChangeColorTouchUpInside(_ sender: Any) {
        showAlertPicker()
    }
    
    func refreshSkeleton() {
        guard !switchHidden.isOn else { return }
        self.view.hideSkeleton()
        if type == .gradient { showGradientSkeleton() }
        else { showSolidSkeleton() }
    }
    
    func showSolidSkeleton() {
        if switchAnimated.isOn {
            view.showAnimatedSkeleton(usingColor: colorSelectedView.backgroundColor!)
        } else {
            view.showSkeleton(usingColor: colorSelectedView.backgroundColor!)
        }
    }
    
    func showGradientSkeleton() {
        let gradient = SkeletonGradient(baseColor: colorSelectedView.backgroundColor!)
        if switchAnimated.isOn {
            view.showAnimatedGradientSkeleton(usingGradient: gradient)
        } else {
            view.showGradientSkeleton(usingGradient: gradient)
        }
    }
    
    func showAlertPicker() {
       
        let alertView = UIAlertController(title: "Select color", message: "\n\n\n\n\n\n", preferredStyle: .alert)
        
        let pickerView = UIPickerView(frame: CGRect(x: 0, y: 50, width: 260, height: 115))
        pickerView.dataSource = self
        pickerView.delegate = self
        
        alertView.view.addSubview(pickerView)
        
        let action = UIAlertAction(title: "OK", style: .default) { [unowned pickerView, unowned self] _ in
            let row = pickerView.selectedRow(inComponent: 0)
            self.colorSelectedView.backgroundColor = colors[row].0
            self.refreshSkeleton()
        }
        alertView.addAction(action)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertView.addAction(cancelAction)
        
        present(alertView, animated: false, completion: {
            pickerView.frame.size.width = alertView.view.frame.size.width
        })
    }
}

extension ViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
       return colors.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return colors[row].1
    }
}

extension ViewController: SkeletonTableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 9
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdenfierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return "CellIdentifier"
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellIdentifier", for: indexPath) as! Cell
        cell.label1.text = "cell => \(indexPath.row)"
        return cell
    }
}

