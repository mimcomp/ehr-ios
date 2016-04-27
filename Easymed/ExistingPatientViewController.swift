//
//  TriageMenuViewController.swift
//  PassingData
//
//  Created by choi chun ho,chchoiac,20124979 on 9/3/16.
//  Copyright © 2016 John. All rights reserved.
//

import Foundation
import UIKit;
import Alamofire;

class ExistingPatientViewController : UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var ExistingPatientTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad();
        //keyboard
        self.hideKeyboardWhenTappedAround()
    }
    
    
    //Assign number of patient in TriageFT Table
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return patientList2.count;
    }
    
    //Assign content in cell
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        let date = NSDate();
        let calendar = NSCalendar.currentCalendar();
        let components = calendar.components([.Day , .Month , .Year], fromDate: date);
        let year =  components.year;
        let month =  components.month;
        var year_age:Int = Int(year)-patientList1[indexPath.row].birth_year;
        var month_age:Int;
        var age_text:String="";
        var gender_text:String = "Other";
        var firstname_text:String=""
        var middlename_text:String=""
        var lastname_text:String=""
        let cell=self.ExistingPatientTableView.dequeueReusableCellWithIdentifier("Cell_existingPatient", forIndexPath: indexPath) as! Cell_existingPatient;
        
        if(patientList1[indexPath.row].last_name != "NULL"){
            lastname_text=patientList1[indexPath.row].last_name
        }
        if(patientList1[indexPath.row].first_name != "NULL"){
            firstname_text=patientList1[indexPath.row].first_name;
        }
        if(patientList1[indexPath.row].middle_name != "NULL"){
            middlename_text=patientList1[indexPath.row].middle_name;
        }
        if(firstname_text == "" && lastname_text == "" && middlename_text == ""){
            cell.NameLabel.text = "UNKNOWN Patient";
        }
        else{
            cell.NameLabel.text="\(firstname_text) \(middlename_text) \(lastname_text)"
        }
        
        if(patientList1[indexPath.row].birth_month > Int(month)){
            month_age = patientList1[indexPath.row].birth_month-Int(month);
        }
        else {
            month_age = 12-Int(month)+patientList1[indexPath.row].birth_month;
            year_age--;
        }
        
        if(patientList1[indexPath.row].gender_id != "NULL" || patientList1[indexPath.row].gender_id != "undisclosed"){
            for(var i=0; i<gendersList.count ; i++){
                if(patientList1[indexPath.row].gender_id==gendersList[i].gender_id){
                    gender_text=gendersList[i].description;
                    break;
                }
            }
        }
        
        if(year_age<=130 && year_age>0){
            age_text="\(year_age) years \(month_age) months old";
        }
        else if(year_age == 0 && month_age>=0){
            age_text="\(month_age) months old"
        }
        else{
            age_text="Undisclosed age"
        }
        
        if(patientList1[indexPath.row].natvie_name != "NULL"){
            cell.NativeNameLabel.text="\(patientList1[indexPath.row].natvie_name)"
        }
        else{
            cell.NativeNameLabel.text=""
        }
        
        cell.AgeLabel.text="\(gender_text) / \(age_text)"
        return cell;    }
    
    //Onclick Cell Action
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        AddVisitState=1
        
        //Copy target data to variable
        currentVisit=Visit();
        currentVisit.clonePatient(patientList2[indexPath.row]);
        
        //Call Next View Controller
        let nextViewController = storyboard?.instantiateViewControllerWithIdentifier("TriageModifyViewController") as! TriageModifyViewController;
        navigationController?.pushViewController(nextViewController, animated: true);
    }
    
    @IBAction func BackOnclick(sender: UIButton) {
        self.navigationController?.popViewControllerAnimated(true);
    }
    
    
    
}