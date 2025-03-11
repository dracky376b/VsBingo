//
//  TitleViewController.swift
//  VsBingo
//
//  Created by 結城 竜矢 on 2017/05/25.
//  Copyright © 2017年 結城 竜矢. All rights reserved.
//

import UIKit
import Foundation

class TitleViewController: UIViewController, UITextFieldDelegate {

    var controller: ViewController?;
    var myWindow: UIWindow!;
    var myWindowButtonOk: UIButton!;
    var myWindowButtonCancel: UIButton!;
    var myTextBingo: Array<UITextField> = [
        UITextField(frame: CGRect(x: 120, y: 10, width: 50, height: 30)),
        UITextField(frame: CGRect(x: 120, y: 50, width: 50, height: 30)),
        UITextField(frame: CGRect(x: 120, y: 90, width: 50, height: 30)),
        UITextField(frame: CGRect(x: 370, y: 10, width: 50, height: 30)),
        UITextField(frame: CGRect(x: 370, y: 50, width: 50, height: 30))];
    
    let strArray: Array<String> = ["Open", "1BINGO", "2BINGO", "3BINGO", "4BINGO"];
    let pointArray: Array<String> = ["P_Open", "P_1Bingo", "P_2Bingo", "P_3Bingo", "P_4Bingo"];
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let userDefault = UserDefaults.standard;
        userDefault.register(defaults: ["P_Open" : 5]);
        userDefault.register(defaults: ["P_1Bingo" : 20]);
        userDefault.register(defaults: ["P_2Bingo" : 50]);
        userDefault.register(defaults: ["P_3Bingo" : 100]);
        userDefault.register(defaults: ["P_4Bingo" : 200]);
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        myWindow = UIWindow();
        myWindowButtonOk = UIButton();
        myWindowButtonCancel = UIButton();
        
        controller = ViewController();
        controller?.modalTransitionStyle = UIModalTransitionStyle.flipHorizontal;
        self.view.layer.backgroundColor = UIColor.white.cgColor;

        let myImageView = UIImageView(frame: CGRect(x:100, y:100, width:625, height:625));
        let myImage = UIImage(named: "balls.jpg");
        myImageView.image = myImage;
        myImageView.layer.position = CGPoint(x:300, y:250);
        self.view.addSubview(myImageView);
        
        let myLabel: UILabel = UILabel(frame: CGRect(x:0, y:0, width:200, height:25))
        myLabel.text = "=== V.S. BINGO ===";
        myLabel.backgroundColor = UIColor.white;
        myLabel.textColor = UIColor.blue;
        myLabel.shadowColor = UIColor.gray;
        myLabel.textAlignment = NSTextAlignment.center;
        myLabel.layer.position = CGPoint(x: self.view.frame.width/2,y: 80);
        self.view.addSubview(myLabel);

        let button1 = UIButton.init(type: UIButtonType.custom);
        button1.frame = CGRect(x:self.view.frame.width/2-75, y:100, width:150, height:45);
        button1.setTitleColor(UIColor.black, for: UIControlState.normal);
        button1.setTitle("Man vs Com", for: UIControlState.normal);
        button1.setTitleColor(UIColor.white, for: UIControlState.highlighted);
        button1.setTitle("Man vs Com", for: UIControlState.highlighted);
        button1.backgroundColor = UIColor.green;
        button1.layer.cornerRadius = 10.0;
        button1.addTarget(self, action: #selector(vsManCom), for: UIControlEvents.touchUpInside);
        self.view.addSubview(button1);
        
        let button2 = UIButton.init(type: UIButtonType.custom);
        button2.frame = CGRect(x:self.view.frame.width/2-75, y:150, width:150, height:45);
        button2.setTitleColor(UIColor.black, for: UIControlState.normal);
        button2.setTitle("Com vs Man", for: UIControlState.normal);
        button2.setTitleColor(UIColor.white, for: UIControlState.highlighted);
        button2.setTitle("Com vs Man", for: UIControlState.highlighted);
        button2.backgroundColor = UIColor.green;
        button2.layer.cornerRadius = 10.0;
        button2.addTarget(self, action: #selector(vsComMan), for: UIControlEvents.touchUpInside);
        self.view.addSubview(button2);
        
        let button3 = UIButton.init(type: UIButtonType.custom);
        button3.frame = CGRect(x:self.view.frame.width/2-75, y:200, width:150, height:45);
        button3.setTitleColor(UIColor.black, for: UIControlState.normal);
        button3.setTitle("Man vs Man", for: UIControlState.normal);
        button3.setTitleColor(UIColor.white, for: UIControlState.highlighted);
        button3.setTitle("Man vs Man", for: UIControlState.highlighted);
        button3.backgroundColor = UIColor.green;
        button3.layer.cornerRadius = 10.0
        button3.addTarget(self, action: #selector(vsManMan), for: UIControlEvents.touchUpInside);
        self.view.addSubview(button3);
        
        let button4 = UIButton.init(type: UIButtonType.custom);
        button4.frame = CGRect(x:self.view.frame.width/2-75, y:250, width:150, height:45);
        button4.setTitleColor(UIColor.black, for: UIControlState.normal);
        button4.setTitle("Setting", for: UIControlState.normal);
        button4.setTitleColor(UIColor.white, for: UIControlState.highlighted);
        button4.setTitle("Setting", for: UIControlState.highlighted);
        button4.backgroundColor = UIColor.green;
        button4.layer.cornerRadius = 10.0
        button4.addTarget(self, action: #selector(Setting), for: UIControlEvents.touchUpInside);
        self.view.addSubview(button4);
    }

    internal func makeMyWindow(){
        
        // 背景を白に設定する.
        myWindow.backgroundColor = UIColor.cyan;
        myWindow.frame = CGRect(x:0, y:0, width:500, height:300);
        myWindow.layer.position = CGPoint(x: self.view.frame.width/2, y: self.view.frame.height/2);
        myWindow.alpha = 1.0;
        myWindow.layer.cornerRadius = 20;
        
        // myWindowをkeyWindowにする.
        myWindow.makeKey()
        
        // windowを表示する.
        self.myWindow.makeKeyAndVisible()
        
        // ボタンを作成する.
        myWindowButtonOk.frame = CGRect(x:0, y:250, width:100, height:50);
        myWindowButtonOk.backgroundColor = UIColor.orange;
        myWindowButtonOk.setTitle("OK", for: UIControlState.normal);
        myWindowButtonOk.setTitleColor(UIColor.white, for: UIControlState.normal);
        myWindowButtonOk.layer.masksToBounds = true;
        myWindowButtonOk.layer.cornerRadius = 20.0;
        myWindowButtonOk.layer.position = CGPoint(x: 290, y: 120)
        myWindowButtonOk.addTarget(self, action: #selector(onClickOK), for: .touchUpInside);
        self.myWindow.addSubview(myWindowButtonOk);
        
        myWindowButtonCancel.frame = CGRect(x:200, y:250, width:100, height:50);
        myWindowButtonCancel.backgroundColor = UIColor.orange;
        myWindowButtonCancel.setTitle("Cancel", for: UIControlState.normal);
        myWindowButtonCancel.setTitleColor(UIColor.white, for: UIControlState.normal);
        myWindowButtonCancel.layer.masksToBounds = true;
        myWindowButtonCancel.layer.cornerRadius = 20.0;
        myWindowButtonCancel.layer.position = CGPoint(x: 400, y: 120)
        myWindowButtonCancel.addTarget(self, action: #selector(onClickCancel), for: .touchUpInside);
        self.myWindow.addSubview(myWindowButtonCancel);

        let userDefault = UserDefaults.standard;
        
        // TextViewを作成する.
        for i in 0...4 {
            let myLabel: UILabel = UILabel(frame: CGRect(x: 10+(i/3)*250, y: (i%3)*40 + 10, width: 100, height: 30));
            myLabel.backgroundColor = UIColor.clear;
            myLabel.text = strArray[i];
            myLabel.font = UIFont.systemFont(ofSize: CGFloat(15));
            myLabel.textColor = UIColor.black;
            self.myWindow.addSubview(myLabel);

            myTextBingo[i].backgroundColor = UIColor.white;
            myTextBingo[i].text = String(userDefault.integer(forKey: pointArray[i]));
            myTextBingo[i].font = UIFont.systemFont(ofSize: CGFloat(15));
            myTextBingo[i].textColor = UIColor.black;
            myTextBingo[i].textAlignment = NSTextAlignment.right;
            myTextBingo[i].delegate = self;
            myTextBingo[i].keyboardType = UIKeyboardType.numberPad;
            self.myWindow.addSubview(myTextBingo[i]);

            let myLabelPts = UILabel(frame: CGRect(x: 180+(i/3)*250, y: (i%3)*40 + 10, width: 50, height: 30));
            myLabelPts.backgroundColor = UIColor.clear;
            myLabelPts.text = "pts.";
            myLabelPts.font = UIFont.systemFont(ofSize: CGFloat(15));
            myLabelPts.textColor = UIColor.black;
            myLabelPts.textAlignment = NSTextAlignment.left;
            self.myWindow.addSubview(myLabelPts);
        }
    }

    @objc func onClickOK() {
        let userDefault = UserDefaults.standard;
        
        for i in 0...4 {
            userDefault.set(Int(myTextBingo[i].text!), forKey: pointArray[i]);
        }
        
        self.myWindow.isHidden = true;
        self.view.endEditing(true);
        
    }
    
    @objc func onClickCancel() {
        self.myWindow.isHidden = true;
        self.view.endEditing(true);
    }
    
    @objc func vsManCom() {
        controller?.setVS(p1: true, p2: false);
        controller?.modalTransitionStyle = UIModalTransitionStyle.coverVertical;
        self.present(controller!, animated: true, completion: nil);
    }
    
    @objc func vsComMan() {
        controller?.setVS(p1: false, p2: true);
        controller?.modalTransitionStyle = UIModalTransitionStyle.coverVertical;
        self.present(controller!, animated: true, completion: nil);
    }
    
    @objc func vsManMan() {
        controller?.setVS(p1: true, p2: true);
        controller?.modalTransitionStyle = UIModalTransitionStyle.coverVertical;
        self.present(controller!, animated: true, completion: nil);
    }
    
    @objc func Setting() {
        makeMyWindow();
    }
    
    /*
     UITextFieldが編集開始された直後に呼ばれる.
     */
    func textFieldDidBeginEditing(_ textField: UITextField) {
    }
    
    /*
     テキストが編集された際に呼ばれる.
     */
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        // 文字数最大を決める.
        let maxLength: Int = 3
        
        // 入力済みの文字と入力された文字を合わせて取得.
        var str = textField.text! + string
        
        // 文字数がmaxLength以下ならtrueを返す.
        if (str.utf8.count <= maxLength) {
            return true
        }
        return false
    }
    
    /*
     UITextFieldが編集終了する直前に呼ばれる.
     */
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    /*
     改行ボタンが押された際に呼ばれる.
     */
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }

}
