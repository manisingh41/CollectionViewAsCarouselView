//
//  TeepsterListCell.swift
//  Teepso
//
//  Created by techugo on 14/05/18.
//  Copyright © 2018 TechUgo. All rights reserved.
//

import UIKit

class TeepsterListCell: UICollectionViewCell {

    @IBOutlet weak var imgFollowed: UIImageView!
    @IBOutlet weak var imgHeartOut: UIImageView!
    @IBOutlet weak var heightConstraintTbl: NSLayoutConstraint!
    @IBOutlet weak var lblTagsTwo: UILabel!
    @IBOutlet weak var lblTags: UILabel!
    @IBOutlet weak var tblSections: UITableView!
    @IBOutlet weak var lblBio: UILabel!
    @IBOutlet weak var lblFollowedCount: UILabel!
    @IBOutlet weak var lblTeepslistCount: UILabel!
    @IBOutlet weak var lblTeepsCount: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var btnFacebookLink: UIButton!
    @IBOutlet weak var btnTwitterLink: UIButton!
    @IBOutlet weak var btnInstaLink: UIButton!
    @IBOutlet weak var btnBlogLink: UIButton!
    var regionCell = [Region]()
    var userData:SwipeableProfileUser?
    var sectionClicked:(Int)->(Void) = {_ in}
    var ITeepsClicked:(Void)->(Void) = {_ in}
    var FollowClicked:(Void)->(Void) = {_ in}
    var SocialLinkClicked:(String)->(Void) = {_ in}
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imgProfile.layer.cornerRadius = imgProfile.frame.size.height/2
        imgProfile.clipsToBounds = true
        let tableNib = UINib(nibName: "RegionCell", bundle: nil)
        self.tblSections.register(tableNib, forCellReuseIdentifier: "RegionCell")
        tblSections.delegate=self
        tblSections.dataSource=self
    }
    
    func bindData(temp: SwipeableProfileData) {
        let obj = temp.user
        userData = obj
        if let urlProfile = obj?.profilePicture{
            let url:NSURL = NSURL(string:urlProfile)!
            imgProfile.sd_setImage(with: url as URL, placeholderImage: #imageLiteral(resourceName: "profile"))
            imgProfile.contentMode = .scaleAspectFill
        }else{
            imgProfile.image = #imageLiteral(resourceName: "profile")
        }
        lblTeepsCount.text = "\(obj?.teepsCount ?? 0)"
        lblTeepslistCount.text = "\(obj?.teeplistCount ?? 0)"
        lblFollowedCount.text = "\(obj?.followCount ?? 0)"
        lblName.text = obj?.userName
        lblBio.text = obj?.userBio
        if obj?.teeped == "false"{
            self.imgHeartOut.image = #imageLiteral(resourceName: "heart_out")
        }else{
            self.imgHeartOut.image = #imageLiteral(resourceName: "heart_fill")
        }
        if obj?.followed == "false"{
            imgFollowed.image = #imageLiteral(resourceName: "follow")
        }else{
            imgFollowed.image = #imageLiteral(resourceName: "follow_filed")
        }
        if let fblink = obj?.facebookLink{
            print(fblink)
            btnFacebookLink.setImage(#imageLiteral(resourceName: "fb"), for: UIControlState.normal)
        }
        if let tweetLink = obj?.twitterLink{
            print(tweetLink)
            btnTwitterLink.setImage(#imageLiteral(resourceName: "tw"), for: UIControlState.normal)
        }
        if let inlink = obj?.instagramLink{
            print(inlink)
            btnInstaLink.setImage(#imageLiteral(resourceName: "Insta"), for: UIControlState.normal)
        }
        if let bglink = obj?.blogLink{
            print(bglink)
            btnBlogLink.setImage(#imageLiteral(resourceName: "blog"), for: UIControlState.normal)
        }
        var str = ""
        for i in (obj?.style)! {
            str = str+"#"+i.tagName!+" "
        }
        for i in (obj?.music)! {
            str = str+"#"+i.tagName!+" "
        }
        for i in (obj?.hobbie)! {
            str = str+"#"+i.tagName!+" "
        }
        let arr = str.components(separatedBy: " ")
        for i in arr{
            if !((lblTags.text?.contains(i))! || (lblTagsTwo.text?.contains(i))!){
                lblTags.text = lblTags.text!+" "+i
                lblTagsTwo.text = lblTagsTwo.text!+" "+arr[arr.count-1-arr.index(of: i)!]
            }
        }
        self.regionCell = temp.region!
        self.tblSections.reloadData()
        self.tblSections.layoutIfNeeded()
        self.heightConstraintTbl.constant = self.tblSections.contentSize.height
    }
    
    @IBAction func ClickToITeeps(_ sender: UIButton) {
        self.ITeepsClicked()
    }
    @IBAction func ClickToFollow(_ sender: UIButton) {
        self.FollowClicked()
    }
    
    @IBAction func ClickToAddBio(_ sender: UIButton) {
        
        if sender.tag == 101{
            if btnBlogLink.image(for: .normal) == #imageLiteral(resourceName: "blog"){
               self.SocialLinkClicked((userData?.blogLink)!)
            }
        }
        if sender.tag == 102{
            if btnFacebookLink.image(for: .normal) == #imageLiteral(resourceName: "fb"){
                self.SocialLinkClicked((userData?.facebookLink)!)
            }
        }
        if sender.tag == 103{
            if btnInstaLink.image(for: .normal) == #imageLiteral(resourceName: "Insta"){
                self.SocialLinkClicked((userData?.instagramLink)!)
            }
        }
        if sender.tag == 104{
            if btnTwitterLink.image(for: .normal) == #imageLiteral(resourceName: "tw"){
                self.SocialLinkClicked((userData?.twitterLink)!)
            }        }
    }


}
extension TeepsterListCell: UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.regionCell.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RegionCell", for: indexPath) as! RegionCell
        cell.lblSectionName.text = self.regionCell[indexPath.row].region
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.sectionClicked(indexPath.row)
//        let myspotList = TUGMySpotsListScreen()
//        myspotList.spotArray = self.regionCell[indexPath.row].spots!
//        self.navigationController?.pushViewController(myspotList, animated: true)
    }
}
