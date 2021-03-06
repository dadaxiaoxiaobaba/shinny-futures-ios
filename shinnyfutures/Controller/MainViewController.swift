//
//  MainViewController.swift
//  shinnyfutures
//
//  Created by chenli on 2018/3/28.
//  Copyright © 2018年 xinyi. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    // MARK: Properties
    @IBOutlet weak var slideMenuConstraint: NSLayoutConstraint!
    @IBOutlet weak var menu: UIStackView!
    @IBOutlet weak var optional: UIButton!
    @IBOutlet weak var domain: UIButton!
    @IBOutlet weak var shanghai: UIButton!
    @IBOutlet weak var nengyuan: UIButton!
    @IBOutlet weak var dalian: UIButton!
    @IBOutlet weak var zhengzhou: UIButton!
    @IBOutlet weak var zhongjin: UIButton!
    @IBOutlet weak var dalianzuhe: UIButton!
    @IBOutlet weak var zhengzhouzuhe: UIButton!
    @IBOutlet weak var account: UIButton!
    @IBOutlet weak var position: UIButton!
    @IBOutlet weak var trade: UIButton!
    @IBOutlet weak var feedback: UIButton!
    @IBOutlet weak var background: UIButton!
    @IBOutlet weak var left: UIButton!
    @IBOutlet weak var right: UIButton!
    @IBOutlet weak var quoteNavgationView: UIView!
    @IBOutlet weak var quoteNavigationConstraint: NSLayoutConstraint!
    var isSlideMenuHidden = true
    var quotePageViewController: QuotePageViewController!
    var quoteNavigationCollectionViewController: QuoteNavigationCollectionViewController!

    override func viewDidLoad() {
        super.viewDidLoad()
        let dict: NSDictionary = [NSAttributedStringKey.foregroundColor: UIColor.white, NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 18)]
        self.navigationController?.navigationBar.barTintColor = UIColor.black
        self.navigationController?.navigationBar.titleTextAttributes = dict as? [NSAttributedStringKey: Any]
        initSlideMenuWidth()
    }

    deinit {
        print("主页销毁")
    }

    // change the width of slide menu when the orientation changes
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        initSlideMenuWidth()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case CommonConstants.FeedbackViewController:
            controlSlideMenuVisibility()
        case CommonConstants.QuotePageViewController:
            quotePageViewController = segue.destination as! QuotePageViewController
        case CommonConstants.QuoteNavigationCollectionViewController:
            quoteNavigationCollectionViewController = segue.destination as! QuoteNavigationCollectionViewController
        default:
            return
        }
    }

    // MARK: Actions
    @IBAction func loginViewControllerUnwindSegue(segue: UIStoryboardSegue) {
        print("我从登陆页来～")
    }

    @IBAction func accountViewControllerUnwindSegue(segue: UIStoryboardSegue) {
        print("我从账户资金来～")
    }

    @IBAction func toAccount(_ sender: UIButton) {
        controlSlideMenuVisibility()
        if !DataManager.getInstance().sIsLogin {
            DataManager.getInstance().sToLoginTarget = "Account"
            performSegue(withIdentifier: CommonConstants.LoginViewController, sender: sender)
        } else {
            performSegue(withIdentifier: CommonConstants.AccountViewController, sender: sender)
        }
    }

    @IBAction func quoteViewControllerUnwindSegue(segue: UIStoryboardSegue) {
        print("我从合约详情页来～")
        if let segue = segue.identifier {
            switch segue {
            case CommonConstants.QuoteViewControllerUnwindSegue:
                MDWebSocketUtils.getInstance().sendSubscribeQuote(insList: DataManager.getInstance().sPreInsList)
                MDWebSocketUtils.getInstance().sendSetChart(insList: "")
                MDWebSocketUtils.getInstance().sendSetChartDay(insList: "", viewWidth: CommonConstants.VIEW_WIDTH)
                MDWebSocketUtils.getInstance().sendSetChartHour(insList: "", viewWidth: CommonConstants.VIEW_WIDTH)
                MDWebSocketUtils.getInstance().sendSetChartMinute(insList: "", viewWidth: CommonConstants.VIEW_WIDTH)
            default:
                break
            }
        }
    }

    @IBAction func toPosition(_ sender: UIButton) {
        controlSlideMenuVisibility()
        if !DataManager.getInstance().sIsLogin {
            DataManager.getInstance().sToLoginTarget = "Position"
            performSegue(withIdentifier: CommonConstants.LoginViewController, sender: sender)
        } else {
            performSegue(withIdentifier: CommonConstants.QuoteViewController, sender: sender)
            let instrumentId = DataManager.getInstance().sQuotes[1].sorted(by: {$0.key < $1.key}).map {$0.key}[0]
            //进入合约详情页的入口有：合约列表页，登陆页，搜索页，主页
            DataManager.getInstance().sPreInsList = DataManager.getInstance().sRtnMD[RtnMDConstants.ins_list].stringValue
            DataManager.getInstance().sInstrumentId = instrumentId
            MDWebSocketUtils.getInstance().sendSubscribeQuote(insList: instrumentId)
            MDWebSocketUtils.getInstance().sendSetChart(insList: instrumentId)
            MDWebSocketUtils.getInstance().sendSetChartDay(insList: instrumentId, viewWidth: CommonConstants.VIEW_WIDTH)
            MDWebSocketUtils.getInstance().sendSetChartHour(insList: instrumentId, viewWidth: CommonConstants.VIEW_WIDTH)
            MDWebSocketUtils.getInstance().sendSetChartMinute(insList: instrumentId, viewWidth: CommonConstants.VIEW_WIDTH)
        }
    }

    @IBAction func tradeTableViewControllerUnwindSegue(segue: UIStoryboardSegue) {
        print("我从成交记录来～")
    }

    @IBAction func toTrade(_ sender: UIButton) {
        controlSlideMenuVisibility()
        if !DataManager.getInstance().sIsLogin {
            DataManager.getInstance().sToLoginTarget = "Trade"
            performSegue(withIdentifier: CommonConstants.LoginViewController, sender: sender)
        } else {
            performSegue(withIdentifier: CommonConstants.TradeTableViewController, sender: sender)
        }
    }

    @IBAction func navigation(_ sender: UIBarButtonItem) {
        controlSlideMenuVisibility()
    }

    @IBAction func toOptional(_ sender: UIButton) {
        controlSlideMenuVisibility()
        self.title = CommonConstants.titleArray[0]
        switchPage(index: 0)
    }

    @IBAction func toDomain(_ sender: UIButton) {
        controlSlideMenuVisibility()
        self.title = CommonConstants.titleArray[1]
        switchPage(index: 1)
    }

    @IBAction func toShanghai(_ sender: UIButton) {
        controlSlideMenuVisibility()
        self.title = CommonConstants.titleArray[2]
        switchPage(index: 2)
    }

    @IBAction func toNengyuan(_ sender: UIButton) {
        controlSlideMenuVisibility()
        self.title = CommonConstants.titleArray[3]
        switchPage(index: 3)
    }

    @IBAction func toDalian(_ sender: UIButton) {
        controlSlideMenuVisibility()
        self.title = CommonConstants.titleArray[4]
        switchPage(index: 4)
    }

    @IBAction func toZhengzhou(_ sender: UIButton) {
        controlSlideMenuVisibility()
        self.title = CommonConstants.titleArray[5]
        switchPage(index: 5)
    }

    @IBAction func toZhongjin(_ sender: UIButton) {
        controlSlideMenuVisibility()
        self.title = CommonConstants.titleArray[6]
        switchPage(index: 6)
    }

    @IBAction func toDaLianZuHe(_ sender: UIButton) {
        controlSlideMenuVisibility()
        self.title = CommonConstants.titleArray[7]
        switchPage(index: 7)
    }

    @IBAction func toZhengZhouZuHe(_ sender: UIButton) {
        controlSlideMenuVisibility()
        self.title = CommonConstants.titleArray[8]
        switchPage(index: 8)
    }

    @IBAction func left(_ sender: UIButton) {
        if let collectionView = quoteNavigationCollectionViewController.collectionView {
            var indexPaths = collectionView.indexPathsForVisibleItems
            indexPaths.sort(by: <)
            if let index = indexPaths.first?.row {
                collectionView.scrollToItem(at: IndexPath(row: index, section: 0), at: .right, animated: true)
            }
        }
    }

    @IBAction func right(_ sender: UIButton) {
        if let collectionView = quoteNavigationCollectionViewController.collectionView {
            var indexPaths = collectionView.indexPathsForVisibleItems
            indexPaths.sort(by: <)
            if let index = indexPaths.last?.row {
                collectionView.scrollToItem(at: IndexPath(row: index, section: 0), at: .left, animated: true)
            }
        }
    }

    @IBAction func background(_ sender: UIButton) {
        controlSlideMenuVisibility()
    }

    // MARK: private func
    //初始化侧滑栏约束，控制其隐藏显示
    private func initSlideMenuWidth() {
        switch UIDevice.current.orientation {
        case .portrait:
            slideMenuConstraint.constant = -180
        case .portraitUpsideDown:
            slideMenuConstraint.constant = -180
        case .landscapeLeft:
            slideMenuConstraint.constant = -120
        case .landscapeRight:
            slideMenuConstraint.constant = -120
        default:
            print("什么鬼～")
        }

    }

    //控制侧滑栏隐藏显示
    private func controlSlideMenuVisibility() {
        if isSlideMenuHidden {
            slideMenuConstraint.constant = 0
            UIView.animate(withDuration: 0.3, animations: {
                self.view.layoutIfNeeded()})
            UIView.animate(withDuration: 0.3, animations: {
                self.background.alpha = 0.5
            })
        } else {
            slideMenuConstraint.constant = -menu.frame.size.width
            UIView.animate(withDuration: 0.3, animations: {
                self.view.layoutIfNeeded()
            })
            UIView.animate(withDuration: 0.3, animations: {
                self.background.alpha = 0.0
            })
        }
        isSlideMenuHidden = !isSlideMenuHidden
    }

    //切换交易所行情列表
    private func switchPage(index: Int) {
        if quotePageViewController.currentIndex < index {
            quotePageViewController.forwardPage(index: index)
        } else if quotePageViewController.currentIndex > index {
            quotePageViewController.backwardPage(index: index)
        }

        loadQuoteNavigation(index: index)
    }

    //加载导航栏
    func loadQuoteNavigation(index: Int) {
        if index == 0 {
            quoteNavgationView.isHidden = true
            left.isHidden = true
            right.isHidden = true
            quoteNavigationConstraint.constant = 0
        } else {
            quoteNavgationView.isHidden = false
            left.isHidden = false
            right.isHidden = false
            quoteNavigationConstraint.constant = -44
        }
        quoteNavigationCollectionViewController.loadDatas(index: index)
    }

}
