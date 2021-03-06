//
//  KlinePageViewController.swift
//  shinnyfutures
//
//  Created by chenli on 2018/4/10.
//  Copyright © 2018年 xinyi. All rights reserved.
//

import UIKit

class KlinePageViewController: UIPageViewController, UIPageViewControllerDelegate {
    // MARK: Properties
    var currentIndex = 0

    lazy var subViewControllers: [BaseChartViewController] = {
        let viewController1 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: CommonConstants.CurrentDayViewController) as! CurrentDayViewController
        viewController1.klineType = CommonConstants.CURRENT_DAY
        let viewController2 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: CommonConstants.KlineViewController) as! KlineViewController
        viewController2.klineType = CommonConstants.KLINE_DAY
        let viewController3 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: CommonConstants.KlineViewController) as! KlineViewController
        viewController3.klineType = CommonConstants.KLINE_HOUR
        let viewController4 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: CommonConstants.KlineViewController) as! KlineViewController
        viewController4.klineType = CommonConstants.KLINE_MINUTE
        return [viewController1, viewController2, viewController3, viewController4]
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        setViewControllers([subViewControllers[0]], direction: .forward, animated: false, completion: nil)
        // Do any additional setup after loading the view.
    }

}
