//
//  ViewController.swift
//  VsBingo
//
//  Created by 結城 竜矢 on 2017/05/24.
//  Copyright © 2017年 結城 竜矢. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    enum Player: String {
        case Man = "Man";
        case Com = "Com";
    };
    
    let pointStrArray: Array<String> = ["P_Open", "P_1Bingo", "P_2Bingo", "P_3Bingo", "P_4Bingo"];

    var bingoArray: Array<Bool> = [];
    var numberArray: Array<Int> = [];
    var selectArray: Array<Bool> = [];
    var pointArray: Array<Int> = [0, 20, 50, 100, 200];
    let scoreLabel: Array<UILabel> = [ UILabel(frame: CGRect(x:0, y:0, width:70, height:30)),
                                    UILabel(frame: CGRect(x:0, y:0, width:70, height:30))];
    let resultLabel: UILabel = UILabel(frame: CGRect(x:0, y:0, width:200, height:30))
    let selectBlock: CALayer = CALayer.init();
    let hitLayer: CALayer = CALayer.init();
    
    var seOpen: AVAudioPlayer?;
    var seBeep: AVAudioPlayer?;
    var seBingo: AVAudioPlayer?;
    
    let sizeX: Int = 19;
    let sizeY: Int = 33;
    
    var numOpen: Int = 0;
    var turn: Int = 0;
    var player: Array<Player> = [Player.Man, Player.Com];
    var scoreArray: Array<Int> = [0, 0];

    var gameEndFlag = false;
    
    let arrowImg = UIImageView(frame: CGRect(x:0, y:0, width:32, height: 32));

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        myInit();
        reset();
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated);
    }
    
    func setVS(p1: Bool, p2: Bool) {
        if (p1) {
            player[0] = Player.Man;
        } else {
            player[0] = Player.Com;
        }
        
        if (p2) {
            player[1] = Player.Man;
        } else {
            player[1] = Player.Com;
        }
    }
    
    func myInit() {
        view.backgroundColor = UIColor.white;

        let userDefault = UserDefaults.standard;
        pointArray.removeAll();
        for i in 0...4 {
            pointArray.append(userDefault.integer(forKey: pointStrArray[i]));
        }
        
        let myImageView = UIImageView(frame: CGRect(x:100, y:100, width:625, height:625));
        let myImage = UIImage(named: "balls.jpg");
        myImageView.image = myImage;
        myImageView.layer.position = CGPoint(x:300, y:250);
        self.view.addSubview(myImageView);

        for i:Int in 0...29 {
            numberArray.append(i);
            bingoArray.append(false);
            selectArray.append(true);
        }
        
        // swift2系からtryでエラー処理するようなので、do〜try〜catchで対応
        do {
            var filePath = Bundle.main.path(forResource: "se_open", ofType: "mp3");
            var audioPath = URL(fileURLWithPath: filePath!);
            seOpen = try AVAudioPlayer(contentsOf: audioPath)

            filePath = Bundle.main.path(forResource: "se_Beep", ofType: "mp3");
            audioPath = URL(fileURLWithPath: filePath!);
            seBeep = try AVAudioPlayer(contentsOf: audioPath)

            filePath = Bundle.main.path(forResource: "se_BINGO", ofType: "mp3");
            audioPath = URL(fileURLWithPath: filePath!);
            seBingo = try AVAudioPlayer(contentsOf: audioPath)
        }
        // playerを作成した時にエラーがthrowされたらこっち来る
        catch {
            print("AVAudioPlayer error")
        }
        seOpen!.prepareToPlay();
        seBeep!.prepareToPlay();
        seBingo!.prepareToPlay();

        selectBlock.bounds = CGRect(x: 0, y: 0, width: 300, height: 300);
        selectBlock.position = CGPoint(x:400, y:150);
        selectBlock.zPosition = 10;
 //       selectBlock.backgroundColor = UIColor.brown.cgColor;
        selectBlock.name = "Block";
        selectBlock.isHidden = true;
        view.layer.addSublayer(selectBlock);
        
        hitLayer.bounds = CGRect(x: 0, y: 0, width: sizeX*2+4, height: sizeY+4);
        hitLayer.position = CGPoint(x:400, y:150);
        hitLayer.zPosition = 1;
        hitLayer.backgroundColor = UIColor.orange.cgColor;
        hitLayer.isHidden = true;
        view.layer.addSublayer(hitLayer);
        
        let myLabel: UILabel = UILabel(frame: CGRect(x:0, y:0, width:180, height:25))
        myLabel.backgroundColor = UIColor.white;
        myLabel.text = "=== V.S. BINGO ===";
        myLabel.textColor = UIColor.blue;
        myLabel.shadowColor = UIColor.gray;
        myLabel.textAlignment = NSTextAlignment.center;
        myLabel.layer.position = CGPoint(x: 100,y: 20)
        self.view.addSubview(myLabel)

        let myLabel2: UILabel = UILabel(frame: CGRect(x:0, y:0, width:230, height:25))
        myLabel2.backgroundColor = UIColor.white;
        myLabel2.text = "--- Select the numbers ---";
        myLabel2.textColor = UIColor.blue;
        myLabel2.shadowColor = UIColor.gray;
        myLabel2.textAlignment = NSTextAlignment.center;
        myLabel2.layer.position = CGPoint(x: 350,y: 20)
        self.view.addSubview(myLabel2)
    }
    
    func reset() {
        // シャッフル
        for i:Int in 0...29 {
            let j:Int = (Int)(arc4random_uniform(30));
            let temp: Int = numberArray[i];
            numberArray[i] = numberArray[j];
            numberArray[j] = temp;
        }
        
        // 選択配列初期化
        for i:Int in 1...30 {
            bingoArray[i-1] = false;
            selectArray[i-1] = true;
        }
        
        for i: Int in 1...30 {
            var point: CGPoint = calcSelectPosFromIndex(i-1);
            let layer1: CALayer = makeDigitLayerAtPos(point, number: i/10, name: "sel"+String(i));
            point.x = point.x + CGFloat(sizeX);
            let layer2: CALayer = makeDigitLayerAtPos(point, number: i % 10, name: "sel"+String(i));
            self.view.layer.addSublayer(layer1);
            self.view.layer.addSublayer(layer2);
        }
        
        for i: Int in 1...25 {
            var point: CGPoint = calcBingoPosFromIndex(i-1);
            let layer1: CALayer = makeDigitLayerAtPos(point, number: -1, name: "bng"+String(i));
            point.x = point.x + CGFloat(sizeX);
            let layer2: CALayer = makeDigitLayerAtPos(point, number: -1, name: "bng"+String(i));
            self.view.layer.addSublayer(layer1);
            self.view.layer.addSublayer(layer2);
        }

        numOpen = 0;

        for i in 0...1 {
            scoreArray[i] = 0;
        
            let myLabel: UILabel = UILabel(frame: CGRect(x:0, y:0, width:200, height:40))
            myLabel.backgroundColor = UIColor.white;
            myLabel.text = "Player" + String(i+1) + "(" + player[i].rawValue + "): ";
            myLabel.textColor = UIColor.black;
            myLabel.shadowColor = UIColor.gray;
            myLabel.textAlignment = NSTextAlignment.left
            myLabel.layer.position = CGPoint(x: 150,y: i*40 + 260)
            self.view.addSubview(myLabel)

            scoreLabel[i].backgroundColor = UIColor.white;
            scoreLabel[i].text = String(scoreArray[i]) + " pts.";
            scoreLabel[i].textColor = UIColor.black;
            scoreLabel[i].shadowColor = UIColor.gray;
            scoreLabel[i].textAlignment = NSTextAlignment.right;
            scoreLabel[i].layer.position = CGPoint(x: 200,y: i*40 + 260)
            self.view.addSubview(scoreLabel[i]);
        }

        // UIImageViewを作成する.
        let myImage = UIImage(named: "arrow.png");
        arrowImg.image = myImage;
        arrowImg.layer.position = CGPoint(x: 20, y: 260);
        self.view.addSubview(arrowImg);

        if (player[0] == Player.Com) {
            selectBlock.isHidden = false;
            Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(ViewController.turnComputer), userInfo: nil, repeats: false);
        }
    }
    
    func makeDigitLayerAtPos(_ pos: CGPoint, number: Int, name: String) -> CALayer {
        let layer: CALayer = CALayer.init();
        layer.bounds = CGRect(x: 0, y: 0, width: sizeX, height: sizeY);
        layer.position = pos;
        if (number == -1) {
            layer.contents = UIImage(named: "digitoff.png")?.cgImage;
        } else {
            layer.contents = UIImage(named: "digit" + String(number) + ".png")?.cgImage;
        }
        layer.zPosition = 3;
        layer.name = name;
        
        return layer;
        
    }
    
    func calcBingoPosFromIndex(_ index: Int) -> CGPoint {
        let x: Int = (index % 5);
        let y: Int = (index / 5);
        let pos: CGPoint = CGPoint(x: x*(sizeX*2+2) + 20, y: y*(sizeY+2) + 50);
        
        return pos;
    }
    
    func calcSelectPosFromIndex(_ index: Int) -> CGPoint {
        let x: Int = (index % 5);
        let y: Int = (index / 5);
        let pos: CGPoint = CGPoint(x: x*(sizeX*2+7) + 260, y: y*(sizeY+7) + 50);
        
        return pos;
    }
    
    func checkBingo(index: Int) {
        var bingo: Int = 0;
        hitLayer.isHidden = true;
        
        // 縦
        var row = index % 5;
        if (bingoArray[row] && bingoArray[row + 5] && bingoArray[row + 10] && bingoArray[row + 15] && bingoArray[row + 20]) {
            let pos: CGPoint = calcBingoPosFromIndex(row);
            let redRect = UIView(frame: CGRect(x: Int(pos.x-12), y: Int(pos.y-19), width: sizeX*2+4, height: (sizeY+2)*5+2));
            redRect.backgroundColor = UIColor.red;
            view.addSubview(redRect);
            bingo = bingo + 1;
        }
        
        // 横
        row = (index / 5) * 5;
        if (bingoArray[row] && bingoArray[row + 1] && bingoArray[row + 2] && bingoArray[row + 3] && bingoArray[row + 4]) {
            let pos: CGPoint = calcBingoPosFromIndex(row);
            let redRect = UIView(frame: CGRect(x: Int(pos.x-12), y: Int(pos.y-19), width: (sizeX*2+2)*5+2, height: sizeY+4));
            redRect.backgroundColor = UIColor.red;
            view.addSubview(redRect);
            bingo = bingo + 1;
        }
        
        // 斜め１
        if ((index % 6) == 0) {
            if (bingoArray[0] && bingoArray[6] && bingoArray[12] && bingoArray[18] && bingoArray[24]) {
                for i in 0...4 {
                    row = i * 6;
                    let pos: CGPoint = calcBingoPosFromIndex(row);
                    let redRect = UIView(frame: CGRect(x: Int(pos.x-12), y: Int(pos.y-19), width: sizeX*2+4, height: sizeY+4));
                    redRect.backgroundColor = UIColor.red;
                    view.addSubview(redRect);
                }
                bingo = bingo + 1;
            }
        }

        // 斜め2
        if (((index % 4) == 0) && (index != 0) && (index != 24)) {
            if (bingoArray[4] && bingoArray[8] && bingoArray[12] && bingoArray[16] && bingoArray[20]) {
                for i in 0...4 {
                    row = (i + 1) * 4;
                    let pos: CGPoint = calcBingoPosFromIndex(row);
                    let redRect = UIView(frame: CGRect(x: Int(pos.x-12), y: Int(pos.y-19), width: sizeX*2+4, height: sizeY+4));
                    redRect.backgroundColor = UIColor.red;
                    view.addSubview(redRect);
                }
                bingo = bingo + 1;
            }
        }
        
        if (bingo > 0) {
            seBingo?.play();

            let pointLabel: UILabel = UILabel(frame: CGRect(x:0, y:0, width:200, height:30))
            pointLabel.backgroundColor = UIColor.white;
            pointLabel.text = String(bingo) + " BINGO!! " + String(pointArray[bingo]) + "pts.!";
            pointLabel.textColor = UIColor.blue;
            pointLabel.shadowColor = UIColor.gray;
            pointLabel.textAlignment = NSTextAlignment.center;
            pointLabel.layer.position = CGPoint(x: 130,y: 230);
            self.view.addSubview(pointLabel)

            self.scoreArray[self.turn] = self.scoreArray[self.turn] + self.pointArray[bingo];

            DispatchQueue.global(qos: .default).async() {
                while (self.seBingo?.isPlaying)! {}
                DispatchQueue.main.async {
                    pointLabel.removeFromSuperview();
                    let pos: CGPoint = self.calcBingoPosFromIndex(0);
                    let clearRect = UIView(frame: CGRect(x: Int(pos.x-12), y: Int(pos.y-19), width: (self.sizeX*2+2)*5+2, height: (self.sizeY+2)*5+2));
                    clearRect.backgroundColor = UIColor.white;
                    self.view.addSubview(clearRect);
                    self.switchTurn();
                    self.updateScore();
                    if (self.numOpen >= 25) {
                        self.gameEnd();
                    }
                }
            }
            
        } else {
            if (self.numOpen >= 25) {
                self.gameEnd();
                return;
            }
            self.switchTurn();
            self.updateScore();
         }
    }

    func updateScore() {

        for i in 0...1 {
            scoreLabel[i].text = String(scoreArray[i]) + " pts.";
        }
        
        arrowImg.layer.position = CGPoint(x: 20, y: turn*40 + 260);
    }

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch: UITouch = touches.first!;

        if (gameEndFlag) {
            gameEndFlag = false;
            resultLabel.removeFromSuperview();

            let myVC: UIViewController = TitleViewController();
            myVC.modalTransitionStyle = UIModalTransitionStyle.flipHorizontal;
            self.dismiss(animated: true, completion: nil);

            return;
        }
        
        let pos: CGPoint = touch.location(in: self.view);
        
        let layer: CALayer = self.view.layer.hitTest(pos)!;
        if (layer.name != nil) {
            let strName: String = layer.name!;
            if (strName.hasPrefix("sel")) {
                let strindex = strName.index(strName.startIndex, offsetBy: 3);
                let index: Int = Int((strName.substring(from: strindex)))!;
                choice(index: index);
            }
        }
    }
    
    func choice(index: Int) {
        selectBlock.isHidden = false;
        
        if (selectArray[index - 1]) {
            var point: CGPoint = calcSelectPosFromIndex(index-1);
            let layer1: CALayer = makeDigitLayerAtPos(point, number: -1, name: "off");
            point.x = point.x + CGFloat(sizeX);
            let layer2: CALayer = makeDigitLayerAtPos(point, number: -1, name: "off");
            self.view.layer.addSublayer(layer1);
            self.view.layer.addSublayer(layer2);
            
            selectArray[index-1] = false;
            
            let bngNum = numberArray[index - 1];
            if (bngNum < 25) {
                seOpen!.play();
                scoreArray[turn] = scoreArray[turn] + 5;
                numOpen = numOpen + 1;
                var point: CGPoint = calcBingoPosFromIndex(bngNum);
                hitLayer.position = CGPoint(x: point.x + 9, y: point.y);

                let layer1: CALayer = makeDigitLayerAtPos(point, number: index/10, name:"on");
                point.x = point.x + CGFloat(sizeX);
                let layer2: CALayer = makeDigitLayerAtPos(point, number: index%10, name: "on");
                self.view.layer.addSublayer(layer1);
                self.view.layer.addSublayer(layer2);
                bingoArray[bngNum] = true;
                
                DispatchQueue.global(qos: .default).async() {
                    self.hitLayer.isHidden = false;
                    DispatchQueue.main.async {
                        while (self.seOpen?.isPlaying)! {}
                        self.checkBingo(index: bngNum);
                    }
                }
                
            } else {
                // ハズレ
                seBeep!.play();
                DispatchQueue.global(qos: .default).async() {
                    DispatchQueue.main.async() {
                        while (self.seBeep?.isPlaying)! {}
                        self.switchTurn();
                    }
                }
            }
        }
    }
    
    func switchTurn() {
        self.turn = (self.turn + 1) % 2;
        self.updateScore();
        
        if (numOpen >= 25) { return; }
        
        if (player[turn] == Player.Com) {
            selectBlock.isHidden = false;
            Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(ViewController.turnComputer), userInfo: nil, repeats: false);
        } else {
            selectBlock.isHidden = true;
        }
        
    }
    
    @objc func turnComputer() {
        
        var bng: Int = (Int)(arc4random_uniform(30));
        while (!selectArray[bng]) { bng = (bng + 1) % 30; }
        let group = DispatchGroup();
        DispatchQueue.global(qos: .default).async(group: group) {
        }
        group.notify(queue: DispatchQueue.main) {
            self.choice(index: bng+1);
        }
    }
    
    func gameEnd() {
        gameEndFlag = true;
        arrowImg.removeFromSuperview();

        resultLabel.backgroundColor = UIColor.white;
        resultLabel.textColor = UIColor.blue;
        resultLabel.shadowColor = UIColor.gray;
        resultLabel.textAlignment = NSTextAlignment.left;
        resultLabel.layer.position = CGPoint(x: 130,y: 230);
        self.view.addSubview(resultLabel);
        
        if (scoreArray[0] > scoreArray[1]) {
            resultLabel.text = "Player1 Win!!";
        } else if (scoreArray[0] < scoreArray[1]) {
            resultLabel.text = "Player2 Win!!";
        } else {
            resultLabel.text = "Draw!";
        }
    }
}

