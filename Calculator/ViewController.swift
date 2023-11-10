//
//  ViewController.swift
//  Calculator
//
//  Created by nju on 2022/10/1.
//

import UIKit

class ViewController: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        resLabelText = " "
        expLabelText = " "
        let device = UIDevice.current
        if device.orientation == .landscapeLeft || device.orientation == .landscapeRight {
            //横屏时候要做的事 do something
            // self.performSegue(withIdentifier: "V2H", sender: self)
            launchScienceMode()
        } else {
            launchNormalMode()
        }
        // print(numberButtons.count)
    }
    var calculator = Calculator()
    
    @IBOutlet weak var expLabel: UILabel!
    
    @IBOutlet weak var resLabel: UILabel!
    
    @IBOutlet weak var lnButton: UIButton!
    @IBOutlet weak var logButton: UIButton!
    @IBOutlet weak var sinButton: UIButton!
    @IBOutlet weak var cosButton: UIButton!
    @IBOutlet weak var tanButton: UIButton!
    
    @IBOutlet weak var drSwitchButton: UIButton!
    @IBOutlet weak var drShowLabel: UILabel!
    
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var divButton: UIButton!
    @IBOutlet weak var multiButton: UIButton!
    @IBOutlet weak var eraseButton: UIButton!
    @IBOutlet weak var subButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var equalButton: UIButton!
    
    @IBOutlet var operatorButtons: [UIButton]!
    
    @IBOutlet weak var percentButton: UIButton!
    @IBOutlet weak var dotButton: UIButton!
    
    @IBOutlet var numberButtons: [UIButton]!
    @IBOutlet var memeryOperator: [UIButton]!
    
    @IBOutlet weak var additionalButtons: UIStackView!
    
    private var expression = ""
    
    private var isInv = false
    
    
    
    
    @IBAction func buttonTouched(_ sender: UIButton) {
        
        if expression == " " {
            expression = ""
        }
        
        var subExpression: String = ""
        switch sender.currentTitle {
        case "0": subExpression = "0"
        case "1": subExpression = "1"
        case "2": subExpression = "2"
        case "3": subExpression = "3"
        case "4": subExpression = "4"
        case "5": subExpression = "5"
        case "6": subExpression = "6"
        case "7": subExpression = "7"
        case "8": subExpression = "8"
        case "9": subExpression = "9"
        case "MC": calculator.memeryClear()
        case "M+": calculator.memeryPlus(expression: expLabelText)
        case "M-": calculator.memerySub(expression: expLabelText)
        case "MR":
            expression = calculator.memeryRead()
            expLabelText = expression
            resLabelText = " "
            return
        case "C": expression = " "
        case "÷": subExpression = "÷"
        case "×": subExpression = "×"
        case "⌫": doErase()
        case "-": subExpression = "-"
        case "+": subExpression = "+"
        case "=":
            expression = calculator.getResult()
            expLabelText = expression
            resLabel.text! = " "
            return
        case "%": subExpression = "%"
        case ".": subExpression = "."
        case "(": subExpression = "("
        case ")": subExpression = ")"
        case "1/x": subExpression = "^(-1)"
        case "x²": subExpression = "^(2)"
        case "x³": subExpression = "^(3)"
        case "xʸ": subExpression = "^("
        case "x!": subExpression = "!"
        case "√": subExpression = "√"
        case "ʸ√x": subExpression = "^(1÷"
        case "e": subExpression = "e"
        case "ln": subExpression = "ln("
        case "log": subExpression = "log("
        case "sin": subExpression = "sin("
        case "cos": subExpression = "cos("
        case "tan": subExpression = "tan("
        case "Inv": doInv()
        case "Deg": doDeg()
        case "Rad": doRad()
        case "π": subExpression = "π"
        case "eˣ": subExpression = "e^("
        case "10ˣ": subExpression = "10^("
        case "sin⁻¹": subExpression = "sin⁻¹("
        case "cos⁻¹": subExpression = "cos⁻¹("
        case "tan⁻¹": subExpression = "tan⁻¹("
            
            
        default:
            print("ErrorTitleException!")
            return
        }
        
        // print(Double("10.033")!)
        
        expression.append(subExpression)
        if expression == "" {
            expression = " "
        }
        
        expLabelText = expression
        
        
        // print(expression)
        
        calculator.load(expression: expression)
        resLabel.text! =  calculator.getResult()
        
        // print(sender.currentTitle!)
    }
    
    func doErase() {
        if expression.count > 0 {
            let tmp = expression.popLast()
            if tmp == "(" {
                
                switch expression.last {
                case "n":
                    expression.removeLast(2)
                    if expression.last == "t"
                        || expression.last == "s" {
                        expression.removeLast()
                    }
                case "g","s":
                    expression.removeLast(3)
                case "¹":
                    expression.removeLast(5)
                default:
                    return
                }
            }
        }
    }
    
    func doInv() {
        if isInv {
            lnButton.setTitle("ln", for: UIControl.State.normal)
            logButton.setTitle("log", for: UIControl.State.normal)
            sinButton.setTitle("sin", for: UIControl.State.normal)
            cosButton.setTitle("cos", for: UIControl.State.normal)
            tanButton.setTitle("tan", for: UIControl.State.normal)
            isInv = false
        } else {
            lnButton.setTitle("eˣ", for: UIControl.State.normal)
            logButton.setTitle("10ˣ", for: UIControl.State.normal)
            sinButton.setTitle("sin⁻¹", for: UIControl.State.normal)
            cosButton.setTitle("cos⁻¹", for: UIControl.State.normal)
            tanButton.setTitle("tan⁻¹", for: UIControl.State.normal)
            isInv = true
        }
    }
    
    func doDeg() {
        drSwitchButton.setTitle("Rad", for: UIControl.State.normal)
        drShowLabel.text! = "Deg"
        calculator.setDeg()
    }
    
    func doRad() {
        drSwitchButton.setTitle("Deg", for: UIControl.State.normal)
        drShowLabel.text! = "Rad"
        calculator.setRad()
    }
    
    var expLabelText: String {
        get {
            return self.expLabel.text!
        }
        set {
            self.expLabel.text! = newValue
        }
    }
    
    var resLabelText: String {
        get {
            return self.resLabel.text!
        }
        set {
            self.resLabel.text! = newValue
        }
    }
    

    
    
    
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        let device = UIDevice.current
        if device.orientation == .landscapeLeft || device.orientation == .landscapeRight {
            //横屏时候要做的事 do something
            // self.performSegue(withIdentifier: "V2H", sender: self)
            // ScienceOpt.isHidden = false
            launchScienceMode()
        } else {
            // ScienceOpt.isHidden = true
            launchNormalMode()
        }
    }
    
    
    func getFont(size: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: size)
    }
    
    func launchScienceMode() {
        expLabel.font = getFont(size: 38.0)
        resLabel.font = getFont(size: 25.0)
        
        for button in numberButtons {
            button.titleLabel?.font = getFont(size: 32.0)
            button.layer.cornerRadius = 20.0
        }
        for button in memeryOperator {
            button.titleLabel?.font = getFont(size: 24.0)
            button.layer.cornerRadius = 20.0
        }
        for button in operatorButtons {
            button.layer.cornerRadius = 20.0
        }
        
        clearButton.titleLabel?.font = getFont(size: 30.0)
        divButton.titleLabel?.font = getFont(size: 44.0)
        multiButton.titleLabel?.font = getFont(size: 40.0)
        eraseButton.titleLabel?.font = getFont(size: 32.0)
        subButton.titleLabel?.font = getFont(size: 49.0)
        addButton.titleLabel?.font = getFont(size: 40.0)
        equalButton.titleLabel?.font = getFont(size: 40.0)
        
        percentButton.layer.cornerRadius = 20.0
        dotButton.layer.cornerRadius = 20.0
        
        percentButton.titleLabel?.font = getFont(size: 31.0)
        dotButton.titleLabel?.font = getFont(size: 36.0)
        
        drShowLabel.isHidden = false
        additionalButtons.isHidden = false
    }

    func launchNormalMode() {
        
        expLabel.font = getFont(size: 52.0)
        resLabel.font = getFont(size: 32.0)
        
        for button in numberButtons {
            button.titleLabel?.font = getFont(size: 46.0)
            button.layer.cornerRadius = 40.0
        }
        for button in memeryOperator {
            button.titleLabel?.font = getFont(size: 30.0)
            button.layer.cornerRadius = 40.0
        }
        for button in operatorButtons {
            button.layer.cornerRadius = 40.0
        }
        
        clearButton.titleLabel?.font = getFont(size: 40.0)
        divButton.titleLabel?.font = getFont(size: 60.0)
        multiButton.titleLabel?.font = getFont(size: 55.0)
        eraseButton.titleLabel?.font = getFont(size: 42.0)
        subButton.titleLabel?.font = getFont(size: 65.0)
        addButton.titleLabel?.font = getFont(size: 55.0)
        equalButton.titleLabel?.font = getFont(size: 55.0)
        
        percentButton.layer.cornerRadius = 40.0
        dotButton.layer.cornerRadius = 40.0
        
        percentButton.titleLabel?.font = getFont(size: 45.0)
        dotButton.titleLabel?.font = getFont(size: 50.0)
        
        drShowLabel.isHidden = true
        additionalButtons.isHidden = true
    }
    
}

