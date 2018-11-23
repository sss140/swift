
//

import UIKit
class MakeBall{
    let gravity:CGFloat = 0.1//重力加速度
    let adjustRate:CGFloat = 0.05//調整のための係数
    let bounceRate:CGFloat = 0.8//反発係数
    let radius:CGFloat = 60.0//ボールの半径
    
    var velX:CGFloat = 0.0, velY:CGFloat = 0.0//ボールの速度
    var posX:CGFloat = 0.0, posY:CGFloat = 0.0//ボールの位置
    var floorX:CGFloat = 0.0, floorY:CGFloat = 0.0//画面の大きさ
    
    var circleView = UIImageView()//ボールのビュー
    
    init(ballColor:UIColor,myPos:CGPoint,velX:CGFloat,velY:CGFloat,myView:UIView){
        self.velX = velX * adjustRate
        self.velY = velY * adjustRate
        self.floorY = myView.bounds.maxY - radius
        self.floorX = myView.bounds.maxX - radius
        posX = myPos.x
        posY = myPos.y
        let size = CGSize(width: 2 * radius, height: 2 * radius)//図形のサイズ。要するに円の直径
        UIGraphicsBeginImageContextWithOptions(size, false, 1.0)//描画のコンテキストを作成
        let context = UIGraphicsGetCurrentContext()//コンテキストを定数に代入
        let drawCircle = CGRect(x: 0.0, y: 0.0, width: radius * 2, height: radius * 2)//描画開始
        let drawPath = UIBezierPath(ovalIn: drawCircle)//パス作成
        context?.setFillColor(UIColor.white.cgColor)//中の色
        drawPath.fill()//中を塗る
        context?.setStrokeColor(ballColor.cgColor)//外枠の色
        drawPath.stroke()//外枠を塗る
        let circleImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        circleView = UIImageView(image:circleImage)
        circleView.center = myPos//表示位置の決定
        Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(self.step),userInfo: nil, repeats: true)//0.01秒ごとに物理計算を繰り返します。
        //生成して３．０秒後に１．０秒かけて徐々に消える。
        UIView.animate(withDuration: 1.0, delay: 3.0, options: UIView.AnimationOptions(), animations: {self.circleView.alpha = 0.0}, completion:{(finished:Bool) in self.circleView.removeFromSuperview()})
        myView.addSubview(circleView)
    }
    @objc func step(){
        velY += gravity
        posY += velY
        //ボールが床に着地したら跳ね返る
        if(posY > floorY ){
            posY = floorY-(posY - floorY)
            velY = -1 * velY * bounceRate
        }
        circleView.center.y = posY
        //壁にあたったら跳ね返る
        posX += velX
        if(posX>floorX){
            posX = floorX - (posX - floorX)
            velX = -1 * velX * bounceRate
        }
        if(posX<radius){
            posX = radius - (posX - radius)
            velX = -1 * velX * bounceRate
        }
        circleView.center.x = posX
    }
}

class ViewController: UIViewController {
    let ballColorsArray:[UIColor] = [UIColor.black,UIColor.blue,UIColor.brown,UIColor.cyan,UIColor.darkGray,UIColor.green,UIColor.magenta,UIColor.orange,UIColor.purple,UIColor.red,UIColor.yellow]
    var oldX:CGFloat = 0.0
    var oldY:CGFloat = 0.0
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        oldX = touches.first!.location(in: self.view).x
        oldY = touches.first!.location(in: self.view).y
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        //タップ位置を動かすたびにボールを生成
        let posStart = touches.first!.location(in: self.view)//場所を決める
        let velY = touches.first!.location(in: self.view).y - oldY,velX = touches.first!.location(in: self.view).x - oldX//初速を決める
        let colorNumber = Int(arc4random_uniform(UInt32(ballColorsArray.count)))//乱数で色を決定
        let myBallColor:UIColor = ballColorsArray[colorNumber]//乱数で色を決定
        weak var myBall = MakeBall(ballColor: myBallColor,myPos: posStart,velX: velX,velY: velY,myView: self.view)//ボールの生成
        myBall = nil//ここがまだ良くわからない。
    }
}

