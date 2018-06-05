//
//  TUGTeepsterSearchedResult.swift
//  Teepso
//
//  Created by techugo on 11/05/18.
//  Copyright © 2018 TechUgo. All rights reserved.
//

import UIKit

class TUGTeepsterSearchedResult: UIViewController {
    @IBOutlet weak var vwHeader: UIView!
    @IBOutlet weak var cvMain: UICollectionView!
    @IBOutlet weak var txtSocialLinks: UITextView!
    @IBOutlet weak var vwAlpha: UIView!
    @IBOutlet weak var lblHeading: UILabel!
    @IBOutlet weak var vwPopup: UIView!
    var teepsterDatabyLoc = [SwipeableProfileData]()
    var idArrayString = ""
    var indexpathRow = 0
    var isSingleUser = false
    var toLoadAnimationOfCell = false
    var isfirstTimeTransform:Bool = true
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpHeaderView()
        setInitialSetup()
        getTeepsterProfiles()
        // Do any additional setup after loading the view.
    }
    func getTeepsterProfiles() {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.showProcessingIndicatorOnView(vwBg: self.view, title: APP_NAME)
        var request = CYLRequestObject()
        let dictBody:[String:Any] = ["userId":idArrayString]
        request = CYLServices.requestToGetTeepsterProfile(dict: dictBody as NSDictionary)
        CYLServiceMaster.sharedInstance.callWebServiceWithRequest(rqst: request, withResponse:
            { (serviceResponse) -> Void in
                if ((serviceResponse?.object?.value(forKey: "status") as! NSNumber) == 200)
                {
                    appDelegate.hideProcessingIndicatorFromView(vwBg: self.view)
                    if self.isSingleUser == true{
                        let teeplistSingleUser = SingleUserProfile.init(object: (serviceResponse?.object)!)
                        self.teepsterDatabyLoc.append(teeplistSingleUser.data!)
                        self.cvMain.reloadData()
                    }else{
                        let teeplistObj = SwipeableProfileModel.init(object: (serviceResponse?.object)!)
                        self.teepsterDatabyLoc = teeplistObj.data!
                        self.cvMain.reloadData()
                        self.toLoadAnimationOfCell = true
                        let indexp = IndexPath.init(row: self.indexpathRow, section: 0)
                        self.cvMain.scrollToItem(at: indexp, at: .centeredHorizontally, animated: false)
                    }
                    
                    
                }
                else
                {
                    if let msg = serviceResponse?.object?.value(forKey: "message")
                    {
                        appDelegate.hideProcessingIndicatorFromView(vwBg: self.view)
                        TUGHelpers().showAlertWithTitle(alertTitle: APP_NAME, messageBody: msg as! String, controller: self)
                    }
                }
        },  withError: { (error) -> Void in
            appDelegate.hideProcessingIndicatorFromView(vwBg: self.view)
            TUGHelpers().showAlertWithTitle(alertTitle: APP_NAME, messageBody: "Please Try Again.", controller: self)
        }) { (isNetworkFailure) -> Void in
            
            appDelegate.hideProcessingIndicatorFromView(vwBg: self.view)
            TUGHelpers().showAlertWithTitle(alertTitle: APP_NAME, messageBody: INTERNET_CONNECTION_MESSAGE, controller: self)
        }
        
        
    }
    
    
    @IBAction func ClickToGo(_ sender: UIButton) {
        UIApplication.shared.openURL(URL(string: self.txtSocialLinks.text)!)
    }
    
    @IBAction func TappedToHideAlpha(_ sender: UITapGestureRecognizer) {
        vwAlpha.isHidden = true
    }
    
    func setUpHeaderView()
    {
        let commonHeader = TUGCommonHeader()
        self.vwHeader.addSubview(commonHeader.view)
        commonHeader.lblMyProfileHeading.text = "Teepster's Profile"
        self.addChildViewController(commonHeader)
        commonHeader.setScreenComponentsWithTitleAndFlag(strTitle: "Teepster", menuFlag: "-1")
        commonHeader.backBtnAction =
            {_ in
                self.navigationController!.popViewController(animated: false)
        }
        commonHeader.loginBtnAction =
            {_ in
                
        }
    }
    func setInitialSetup() {
        let nibImageCell = UINib(nibName: "TeepsterListCell", bundle: nil)
        self.cvMain.register(nibImageCell, forCellWithReuseIdentifier: "TeepsterListCell")
        cvMain.delegate=self
        cvMain.dataSource=self
        vwPopup.layer.borderWidth = 2.0
        vwPopup.layer.borderColor = UIColor.init(colorLiteralRed: 17.0/255.0, green: 163.0/255.0, blue: 168.0/255.0, alpha: 1.0).cgColor
    }

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

}
extension TUGTeepsterSearchedResult: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 280, height: collectionView.frame.size.height-50)
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        
//        return CGSize(width: 300, height: 500)
//    }
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        
////        let totalCellWidth = 300 * 5
////        let totalSpacingWidth = 10 * (5 - 1)
////        
////        let leftInset = (375*5 - CGFloat(totalCellWidth + totalSpacingWidth)) / 2
////        let rightInset = leftInset
//        
//        return UIEdgeInsetsMake(0, 35, 0, 35)
//    }
    
    //  Converted with Swiftify v1.0.6472 - https://objectivec2swift.com/
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let pageWidth: Float = 280 + 10
        // width + space
        //let pageWidth: Float = Float(self.cvMain.frame.width/5 + 50)
        let currentOffset: Float = Float(scrollView.contentOffset.x)
        let targetOffset: Float = Float(targetContentOffset.pointee.x)
        var newTargetOffset: Float = 0
        if targetOffset > currentOffset {
            newTargetOffset = ceilf(currentOffset / pageWidth) * pageWidth
        }
        else {
            newTargetOffset = floorf(currentOffset / pageWidth) * pageWidth
        }
        if newTargetOffset < 0 {
            newTargetOffset = 0
        }
        else if newTargetOffset > Float(scrollView.contentSize.width) {
            newTargetOffset = Float(scrollView.contentSize.width)
        }
        
        targetContentOffset.pointee.x = CGFloat(currentOffset)
        scrollView.setContentOffset(CGPoint(x: CGFloat(newTargetOffset), y: scrollView.contentOffset.y), animated: true)
        
        //  Converted with Swiftify v1.0.6472 - https://objectivec2swift.com/
        var index: Int = Int(newTargetOffset / pageWidth)
        if index == 0 {
            // If first index
            var cell: UICollectionViewCell? = self.cvMain.cellForItem(at: IndexPath(item: index, section: 0))
            UIView.animate(withDuration: ANIMATION_SPEED, animations: {() -> Void in
                cell?.transform = CGAffineTransform.identity
            })
            cell = self.cvMain.cellForItem(at: IndexPath(item: index + 1, section: 0))
            UIView.animate(withDuration: ANIMATION_SPEED, animations: {() -> Void in
                cell?.transform = TRANSFORM_CELL_VALUE
            })
        }
        else {
            var cell: UICollectionViewCell? = self.cvMain.cellForItem(at: IndexPath(item: index, section: 0))
            UIView.animate(withDuration: ANIMATION_SPEED, animations: {() -> Void in
                cell?.transform = CGAffineTransform.identity
            })
            index -= 1
            // left
            cell = self.cvMain.cellForItem(at: IndexPath(item: index, section: 0))
            UIView.animate(withDuration: ANIMATION_SPEED, animations: {() -> Void in
                cell?.transform = TRANSFORM_CELL_VALUE
            })
            index += 1
            index += 1
            // right
            cell = self.cvMain.cellForItem(at: IndexPath(item: index, section: 0))
            UIView.animate(withDuration: ANIMATION_SPEED, animations: {() -> Void in
                cell?.transform = TRANSFORM_CELL_VALUE
            })
        }
    }
    
    

}
extension TUGTeepsterSearchedResult: UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("clicked")
    }
    
}
extension TUGTeepsterSearchedResult:UICollectionViewDataSource,UIScrollViewDelegate{
    // MARK: - collection View delegate
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
            return self.teepsterDatabyLoc.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TeepsterListCell", for: indexPath)
            if let annotateCell = cell as? TeepsterListCell {
                annotateCell.bindData(temp: self.teepsterDatabyLoc[indexPath.row])
                if self.toLoadAnimationOfCell == true{
                    if self.indexpathRow == indexPath.row{
                        self.toLoadAnimationOfCell = false
                        self.isfirstTimeTransform = false
                    }else{
                        cell.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
                    }
                }else{
                    if (indexPath.row == 0 && isfirstTimeTransform) {
                        isfirstTimeTransform = false
                    }else{
                        cell.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
                    }
                }
                annotateCell.sectionClicked = {x in
                    print(x)
                    let myspotList = TUGOtherProfilesScreen()
                    myspotList.spotArray = (self.teepsterDatabyLoc[indexPath.row].region?[x].spots)!
                    self.navigationController?.pushViewController(myspotList, animated: false)
                }
                annotateCell.ITeepsClicked = {_ in
                    CommonClassTeeps().iTeepsAPI(teepid: "\(String(describing: (self.teepsterDatabyLoc[indexPath.row].user?.userId)!))", completionHandler: { (temp) in
                        if temp{
                            if annotateCell.imgHeartOut.image == #imageLiteral(resourceName: "heart_fill"){
                                annotateCell.imgHeartOut.image = #imageLiteral(resourceName: "heart_out")
                            }else{
                                
                                annotateCell.imgHeartOut.image = #imageLiteral(resourceName: "heart_fill")
                            }
                        }else{
                            
                        }
                    })

                }
                annotateCell.FollowClicked = {_ in
                    CommonClassTeeps().FollowedAPI(teepid: "\(String(describing: (self.teepsterDatabyLoc[indexPath.row].user?.userId)!))", completionHandler: { (temp) in
                        if temp{
                            if annotateCell.imgFollowed.image == #imageLiteral(resourceName: "follow"){
                                annotateCell.imgFollowed.image = #imageLiteral(resourceName: "follow_filed")
                            }else{
                                
                                annotateCell.imgFollowed.image = #imageLiteral(resourceName: "follow")
                            }
                        }else{
                            
                        }
                    })
                }
                annotateCell.SocialLinkClicked = {str in
                    self.txtSocialLinks.text = str
                    self.vwAlpha.isHidden = false
                }

            }
            return cell
    }
    
    
  
    
    
}
