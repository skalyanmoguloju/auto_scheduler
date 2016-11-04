//
//  HomeScreen_ViewController.swift
//  auto_scheduler
//
//  Created by Sai on 11/2/16.
//
//

import UIKit

class HomeScreen_ViewController: UIViewController {


    @IBOutlet weak var leadingConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var trainingConstraint: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.layer.shadowOpacity = 1
        mainView.layer.shadowRadius = 10

        // Do any additional setup after loading the view.
    }

    @IBOutlet weak var mainView: UIView!
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

 
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    var menuOpen = false

    @IBAction func menuOpening(_ sender: UIButton) {
        if !menuOpen{
            leadingConstraint.constant = 125
            trainingConstraint.constant = -100
        }
        else
        {
            leadingConstraint.constant = 0
            trainingConstraint.constant = 0
            
        }
        UIView.animate(withDuration: 0.3,
                       animations: {
                        self.view.layoutIfNeeded()
        })
        menuOpen = !menuOpen
    }
    
    
}
