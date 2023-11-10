//
//  Calculator.swift
//  Calculator
//
//  Created by nju on 2022/10/7.
//

import UIKit

class Calculator: NSObject {
    
    
    private var isRad = false
    
    public func setDeg() {
        isRad = false
    }
    
    public func setRad() {
        isRad = true
    }
    
    
    var expression = ""
    var result = " "
    
    var numStack = [Double]()
    var optStack = [String]()
    
    let isp = ["#": 0,
               "(": 1,
               "×": 5,
               "÷": 5,
               "%": 5,
               "+": 3,
               "-": 3,
               "√": 7,
               "^": 7,
               "ln": 9,
               "log": 9,
               "sin": 9,
               "cos": 9,
               "tan": 9,
               "sin⁻¹": 9,
               "cos⁻¹": 9,
               "tan⁻¹": 9,
               ")": 10
    ]
    
    let icp = ["#": 0,
               "(": 10,
               "×": 4,
               "÷": 4,
               "%": 4,
               "+": 2,
               "-": 2,
               "√": 6,
               "^": 6,
               "ln": 8,
               "log": 8,
               "sin": 8,
               "cos": 8,
               "tan": 8,
               "sin⁻¹": 8,
               "cos⁻¹": 8,
               "tan⁻¹": 8,
               ")": 1
    ]

    func factorial(n: Int) ->Int {
        var res = 1
        for i in 1...n {
            res *= i
        }
        return res
    }
    
    private func optStackPush(opt: String) -> Bool{
        // print(opt)
        if opt == "!" {
            if numStack.isEmpty {
                return false
            }
            let tmp = numStack.popLast()!
            if tmp != floor(tmp) {
                return false
            }
            numStack.append(Double(factorial(n: Int(tmp))))
            return true
        }
        
        if !isp.keys.contains(opt) {
            return false
        }
        
        while optStack.count >= 1 {
            if icp[opt]! > isp[optStack.last!]! {
                optStack.append(opt)
                return true
            } else if icp[opt]! < isp[optStack.last!]! {
                let tmp = optStack.popLast()!
                if !calSubExp(opt: tmp) {
                    return false
                }
            } else {
                optStack.removeLast()
                return true
            }
            
        }
        return true
    }
    
    /**
     * @param opt
     * @return
     */
    private func operatorReplace(opt: String) -> String {
        switch opt {
        case "ß": return "sin"
        case "ç": return "cos"
        case "†": return "tan"
        case "å": return "sin⁻¹"
        case "≈": return "cos⁻¹"
        case "®": return "tan⁻¹"
        case "¬": return "ln"
        case "˚": return "log"
        default:
            return opt
        }
    }
    
    
    private func calculate() {
        
        optStack.append("#")
        
        var state = 0
        /*
         * 0 - 解析到的前一个字符为数字或为操作符
         * 1 - 解析到的前一个字符为小数点
         * 2 - 解析到的前一个字符为数字且当前操作数子串中已经出现过小数点
         */
        
        var numStr = ""
        
        for char in expression {
            if state == 1 {
                switch char {
                case "0","1","2","3","4","5","6","7","8","9":
                    numStr.append(char)
                    state = 2
                default:
                    error()
                    return
                }
                continue
            }
            
            switch char {
            case "0","1","2","3","4","5","6","7","8","9":
                if numStr == "π" || numStr == "e" {
                    error()
                    return
                }
                numStr.append(char)
            case "e":
                if numStr == "π" || numStr == "e" {
                    error()
                    return
                }
                if numStr == "-" {
                    numStr = "-1"
                } else if numStr == "" {
                    numStr = "1"
                }
                numStack.append(Double(numStr)!)
                optStack.append("×")
                numStr = "e"
            case "π":
                if numStr == "π" || numStr == "e" {
                    error()
                    return
                }
                if numStr == "-" {
                    numStr = "-1"
                } else if numStr == "" {
                    numStr = "1"
                }
                numStack.append(Double(numStr)!)
                optStack.append("×")
                numStr = "π"
            case ".":
                if state == 0 {
                    if numStr == "π" || numStr == "e" {
                        error()
                        return
                    }
                    state = 1
                    numStr.append(char)
                } else {
                    error()
                    return
                }
            /**
             * 默认情况视为操作符，语法正确性将在计算过程中检查
             */
            default:
                if numStr != "" && numStr != "-" {
                    if numStr == "π" {
                        numStack.append(acos(-1.0))
                    } else if numStr == "e" {
                        numStack.append(exp(1.0))
                    } else {
                        numStack.append(Double(numStr)!)
                    }
                    
                } else if numStr == "" && char == "-" {
                    numStr.append(char)
                    continue
                }
                if !optStackPush(opt: operatorReplace(opt: String(char))) {
                    error()
                    return
                }
                numStr = ""
                state = 0
            }
        }
        
        if numStr != "" && numStr != "-" {
            if numStr == "π" {
                numStack.append(acos(-1.0))
            } else if numStr == "e" {
                numStack.append(exp(1.0))
            } else {
                numStack.append(Double(numStr)!)
            }
        }
        
        if numStack.isEmpty {
            error()
            return
        }
        // print(optStack.count)
        while !(optStack.count == 1) {
            let currentOpt = optStack.popLast()!
            // print(currentOpt)
            if !calSubExp(opt: currentOpt) {
                error()
                return
            }
        }
        
        if numStack.count == 1 && optStack.count == 1{
            result = String(numStack[0])
        } else {
            error()
            return
        }
        numStack.removeAll()
        optStack.removeAll()
    }
    
    
    private func calSubExp(opt: String) -> Bool{
        if numStack.count < 1 {
            return false
        }
        var parameter = numStack.last!
        if !isRad {
            parameter = (parameter) / 360 * 2 * acos(-1.0)
        }
        switch opt {
        case "×":
            if numStack.count < 2 {
                return false
            }
            let num1 = numStack.popLast()!
            let num2 = numStack.popLast()!
            numStack.append(num1 * num2)
        case "÷":
            if numStack.count < 2 {
                return false
            }
            let num1 = numStack.popLast()!
            let num2 = numStack.popLast()!
            numStack.append(num2 / num1)
        case "%":
            numStack.append(numStack.popLast()! / 100)
        case "+":
            if numStack.count < 2 {
                return false
            }
            let num1 = numStack.popLast()!
            let num2 = numStack.popLast()!
            numStack.append(num2 + num1)
        case "-":
            if numStack.count < 2 {
                return false
            }
            let num1 = numStack.popLast()!
            let num2 = numStack.popLast()!
            numStack.append(num2 - num1)
        case "√":
            numStack.append(sqrt(numStack.popLast()!))
        case "^":
            if numStack.count < 2 {
                return false
            }
            let num1 = numStack.popLast()!
            let num2 = numStack.popLast()!
            numStack.append(pow(num2, num1))
        case "ln":
            numStack.append(log(numStack.popLast()!))
        case "log":
            numStack.append(log10(numStack.popLast()!))
        case "sin":
            numStack.removeLast()
            numStack.append(sin(parameter))
        case "cos":
            numStack.removeLast()
            numStack.append(cos(parameter))
        case "tan":
            numStack.removeLast()
            numStack.append(tan(parameter))
        case "sin⁻¹":
            var tmp = asin(numStack.popLast()!)
            if !isRad {
                tmp = 360 * tmp / (2 * acos(-1.0))
            }
            numStack.append(tmp)
        case "cos⁻¹":
            var tmp = acos(numStack.popLast()!)
            if !isRad {
                tmp = 360 * tmp / (2 * acos(-1.0))
            }
            numStack.append(tmp)
        case "tan⁻¹":
            var tmp = atan(numStack.popLast()!)
            if !isRad {
                tmp = 360 * tmp / (2 * acos(-1.0))
            }
            numStack.append(tmp)
        default:
            return false
        }
        return true
    }
    
    private func error() {
        self.result = "ERROR"
        numStack.removeAll()
        optStack.removeAll()
    }
    
    public func load(expression: String) {
        /**
         * 字符串操作符不便于解析，故用特殊单字符替换
         */
        var tmp = expression
        tmp = tmp.replacingOccurrences(of: "sin⁻¹", with: "å")
        tmp = tmp.replacingOccurrences(of: "cos⁻¹", with: "≈")
        tmp = tmp.replacingOccurrences(of: "tan⁻¹", with: "®")
        tmp = tmp.replacingOccurrences(of: "sin", with: "ß")
        tmp = tmp.replacingOccurrences(of: "cos", with: "ç")
        tmp = tmp.replacingOccurrences(of: "tan", with: "†")
        tmp = tmp.replacingOccurrences(of: "ln", with: "¬")
        tmp = tmp.replacingOccurrences(of: "log", with: "˚")
        self.expression = tmp
        let index = self.expression.index(self.expression.startIndex, offsetBy: 0)
        if(self.expression[index] != " ") {
            self.calculate()
        } else {
            result = " "
        }
    }
    
    public func getResult() -> String {
        return self.result
    }
    
    
    private var empty = true
    private var isError = false
    private var memery = 0.0
    
    public func memeryPlus(expression: String) {
        self.load(expression: expression)
        if self.result == " " {
            return
        } else if self.result == "ERROR" {
            isError = true
            return
        }
        memery += Double(self.result)!
        empty = false
    }
    
    public func memerySub(expression: String) {
        self.load(expression: expression)
        if self.result == " " {
            return
        } else if self.result == "ERROR" {
            isError = true
            return
        }
        memery -= Double(self.result)!
        empty = false
    }
    
    public func memeryRead() -> String {
        if empty {
            return " "
        } else if isError {
            return "ERROR"
        }
        return String(memery)
    }
    
    public func memeryClear() {
        memery = 0.0
        empty = true
        isError = false
    }
}
