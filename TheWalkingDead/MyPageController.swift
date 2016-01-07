//
//  MyPageController.swift
//  TheWalkingDead
//
//  Created by User on 10/12/15.
//  Copyright © 2015 Mario Baumgartner. All rights reserved.
//

import UIKit

class MyPageController: UIViewController, UIPageViewControllerDataSource, UIGestureRecognizerDelegate {
    
    private var pageViewController: UIPageViewController?
    
    var controllers : NSMutableArray = []
    var indexValue = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        indexValue = 0
        let pageController = self.storyboard!.instantiateViewControllerWithIdentifier("PageController") as! UIPageViewController
        pageController.dataSource = self
        
        //loadFromCoreData()
        //if refuelings.count > 2 {
        for i in 0...2 {
            let controller = storyboard!.instantiateViewControllerWithIdentifier("PageController\(i)") 
            controllers.addObject(controller)
        }
        
        createPageViewController()
        setupPageControl()
        //}
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBar.hidden = true
        self.navigationController?.interactivePopGestureRecognizer!.delegate = self
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    private func createPageViewController() {
        let pageController = self.storyboard!.instantiateViewControllerWithIdentifier("PageController") as! UIPageViewController
        pageController.dataSource = self
        
        pageController.setViewControllers([controllers[0] as! UIViewController], direction: UIPageViewControllerNavigationDirection.Forward, animated: false, completion: nil)
        
        
        pageViewController = pageController
        addChildViewController(pageViewController!)
        self.view.addSubview(pageViewController!.view)
        pageViewController!.didMoveToParentViewController(self)
        
    }
    
    private func setupPageControl() {
        let appearance = UIPageControl.appearance()
        appearance.pageIndicatorTintColor = UIColor.whiteColor()
        appearance.currentPageIndicatorTintColor = UIColor(red: 41.0/255.0, green: 171.0/255.0, blue: 226.0/255.0, alpha: 1.0)
        appearance.backgroundColor = UIColor.clearColor()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: - UIPageViewControllerDataSource
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        
        if viewController.isKindOfClass(MainViewController) {
            return nil
        } else if viewController.isKindOfClass(HeartrateViewController) {
            return controllers[0] as? UIViewController
        } else if viewController.isKindOfClass(EnergyExpenditureViewController) {
            return controllers[1] as? UIViewController
        }
        
        /*
        if viewController.isKindOfClass(StatisticsViewController0) {
            return nil
        } else if viewController.isKindOfClass(StatisticsViewController1) {
            return controllers[0] as! UIViewController
        } else if viewController.isKindOfClass(StatisticsViewController2) {
            return controllers[1] as! UIViewController
        } else if viewController.isKindOfClass(StatisticsViewController3) {
            return controllers[2] as! UIViewController
        }
*/
        return nil
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        
        if viewController.isKindOfClass(MainViewController) {
            return controllers[1] as? UIViewController
        } else if viewController.isKindOfClass(HeartrateViewController) {
            return controllers[2] as? UIViewController
        } else if viewController.isKindOfClass(EnergyExpenditureViewController) {
            return nil
        }
        
        /*
        if viewController.isKindOfClass(StatisticsViewController0) {
            return controllers[1] as! UIViewController
        } else if viewController.isKindOfClass(StatisticsViewController1) {
            return controllers[2] as! UIViewController
        } else if viewController.isKindOfClass(StatisticsViewController2) {
            return controllers[3] as! UITableViewController
        } else if viewController.isKindOfClass(StatisticsViewController3) {
            return nil
        }
        */
        return nil
        
    }
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return controllers.count
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
    }
}
