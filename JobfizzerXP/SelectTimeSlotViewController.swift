//
//  SelectTimeSlotViewController.swift
//  UberdooXP
//
//  Created by Karthik Sakthivel on 06/11/17.
//  Copyright © 2017 Uberdoo. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire


protocol TimeSelectionDelegate: class {
    func didFinishSelectingTime(slotsData: [JSON], dayOfTheWeek : Int)
}

class SelectTimeSlotViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    
    weak var delegate: TimeSelectionDelegate?
    var forDay : Int!
    var selectedTimeSlots = [Bool]()
    var mycolor = UIColor()
    var daysData : [JSON]!
    var toSendBackTimeSlots : [JSON] = []
    @IBOutlet weak var timeSlotsCollectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        print(daysData)
        print("timeslots",Constants.timeSlots)
        

        
        if(daysData.count > 0)
        {
        for i in 0 ... daysData.count-1
        {
            print("Count = \(daysData.count)")
            print(daysData[i]["status"].intValue)
            if(daysData[i]["status"].intValue == 1)
            {
                selectedTimeSlots.append(true)
            }
            else{
                selectedTimeSlots.append(false)
            }
            print(selectedTimeSlots)
        }
        }
        else{
            for _ in 0 ... Constants.timeSlots.count-1
            {
                selectedTimeSlots.append(false)
            }
        }
        
        print(Constants.timeSlots.count)
        print(selectedTimeSlots)
        
        timeSlotsCollectionView.delegate = self
        timeSlotsCollectionView.dataSource = self
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
       
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return Constants.timeSlots.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TimeSlotsCollectionViewCell", for: indexPath) as! TimeSlotsCollectionViewCell
        let title = Constants.timeSlots[indexPath.row]["timing"].stringValue
        cell.timeSlotLbl.text = title
        print("selected timeslots=",selectedTimeSlots)
        if(selectedTimeSlots[indexPath.row])
        {
            //cell.outerView.backgroundColor = UIColor.init(red: 52/255, green: 152/255, blue: 219/255, alpha: 1)
            if UserDefaults.standard.object(forKey: "myColor") != nil
            {
                //            mycolor = UserDefaults.standard.object(forKey: "mycolor")as! UIColor
                let colorData = UserDefaults.standard.object(forKey: "myColor") as! Data
                //            var color: UIColor? = nil
                mycolor = NSKeyedUnarchiver.unarchiveObject(with: colorData) as! UIColor
                cell.outerView.backgroundColor = mycolor
            }
            else
            {
                cell.outerView.backgroundColor = UIColor.init(red: 107/255, green: 127/255, blue: 252/255, alpha: 1)
            }
            cell.outerView.layer.borderColor = UIColor.clear.cgColor
        }
        else{
            cell.outerView.backgroundColor = UIColor.clear
            cell.outerView.layer.borderColor = UIColor.white.cgColor
            cell.outerView.layer.borderWidth = 1
        }
        return cell
    }
    

    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       
        if(selectedTimeSlots[indexPath.row])
        {
            selectedTimeSlots[indexPath.row] = false
        }
        else{
            selectedTimeSlots[indexPath.row] = true
        }
        self.timeSlotsCollectionView.reloadData()
    }
    


    @IBAction func passBackResults(_ sender: Any) {
        
        toSendBackTimeSlots.removeAll()
        for i in 0 ... Constants.timeSlots.count-1
        {
            var timeSlot: JSON! = JSON.init()
            timeSlot["time_Slots_id"] = Constants.timeSlots[i]["id"]
          print("timesolts count= \(Constants.timeSlots.count)")
            print("selected timesolts count= \(selectedTimeSlots.count)")
            print("Selected timeslots= \(selectedTimeSlots[i])")
            if(selectedTimeSlots[i])
            {
                timeSlot["status"] = "1"
            }
            else{
                timeSlot["status"] = "0"
            }
            toSendBackTimeSlots.append(timeSlot)
        }
        
        print(toSendBackTimeSlots)
        if(self.delegate != nil){
            self.delegate!.didFinishSelectingTime(slotsData: toSendBackTimeSlots,dayOfTheWeek : forDay)
        }
        self.dismiss(animated: true, completion: nil)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = CGSize.init(width: 120, height: 57)
        return size
    }

}
