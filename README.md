# IWORK 01
> iOS assignment 1: Calculator App.
>
> 本人本科期间的课程作业，有许多不够好以及有问题的地方，欢迎批评与交流。:tada:
>
> 仅供**学习交流**，由于使用本项目造成不良后果，本人概不负责。

## 目录

- **[1 界面设计](#1%20界面设计)**
  - **[1.1 StackView](#1.1%20StackView)**
    - [1.1.1 主要约束](#1.1.1%20主要约束)
    - [1.1.2 显示区域（View1）](#1.1.2%20显示区域（View1）)
    - [1.1.3 按键区域（View2）](#1.1.3%20按键区域（View2）)
      - [1.1.3.1. 常规按键区](#1.1.3.1%20常规按键区)
      - [1.1.3.2 附加按键区](#1.1.3.2%20附加按键区)
      - [1.1.3.3 按钮细节](#1.1.3.3%20按钮细节)
  - **[1.2. D/R Show Label](#1.2%20D/R%20Show%20Label)**
- **[2 功能实现](#2%20功能实现)**
  - **[2.1 基础功能](#2.1%20基础功能)**
    - [2.1.1 用户输入处理](#2.1.1%20用户输入处理)
    - [2.1.2 主要运算逻辑](#2.1.2%20主要运算逻辑)
    - [2.1.3 memery 操作](#2.1.3%20memery%20操作)
    - [2.1.4 角度制与弧度制的切换](#2.1.4%20角度制与弧度制的切换)
    - [2.1.5 按钮功能切换（函数与反函数之间的互换）](#2.1.5%20按钮功能切换（函数与反函数之间的互换）)
    - [2.1.6 转动设备时的界面切换](#2.1.6%20转动设备时的界面切换)
  - **[2.2 辅助功能](#2.2%20辅助功能)**
    - [2.2.1 等于操作的作用](#2.2.1%20等于操作的作用)
    - [2.2.2. 更好的删除操作](#2.2.2%20更好的删除操作)
    - [2.2.3 面向用户的报错机制](#2.2.3%20面向用户的报错机制)
- **[3 问题与解决](#3%20问题与解决)**
  - **[3.1 使 Stack View 中的空间按比例布局](#3.1%20使%20Stack%20View%20中的空间按比例布局)**
  - **[3.2 Swift获取当前设备的状态](#3.2%20Swift%20获取当前设备的状态)**
  - **[3.3 代码实现修改Button字体大小](#3.3%20代码实现修改%20Button%20字体大小)**
  - **[3.4 设置圆形的Button](#3.4%20设置圆形的%20Button)**
- **[4 成果展示](#4%20成果展示)**
  - **[4.1 完整流程](#4.1%20完整流程)**
  - **[4.2 压力测试（随便乱按）](#4.2%20压力测试（随便乱按）)**

## 1 界面设计

> 静态布局

<div align=left>
  <img src=https://blog.kekwy.com/media/iw1/%E6%88%AA%E5%B1%8F2022-10-21%20%E4%B8%8B%E5%8D%888.08.35.png width=175 />
</div>

### 1.1 StackView

大体分为上下两部分，上方为计算器的显示区域，下方为按键区域。

<div align=left>
  <img src=https://blog.kekwy.com/media/iw1/image-20221021214843621.png width=300 />
  <img src=https://blog.kekwy.com/media/iw1/image-20221021215053626.png width=175 />
</div>

#### 1.1.1 主要约束

```
Stack View.top = Safe Area.top
Stack View.leading = Safe Area.leading
Safe Area.bottom = Stack View.bottom
Safe Area.trailing = Stack View.trailing
```

使当前控件大小与父控件大小一致，即填充满父控件。

#### 1.1.2 显示区域（View1）

<div align=left>
  <img src=https://blog.kekwy.com/media/iw1/image-20221021220541500.png width=225 />
  <img src=https://blog.kekwy.com/media/iw1/image-20221022103357516.png width=175 />
</div>
- View：为该区域提供指定的背景色。

- Stack View：管理两个主要的UILabel。

  - Exp Label：显示表达式；

  - Res Label：显示表达式的运算结果；

  - 主要约束：纵向填充，左右边缘与 View 始终存在10的间隔。

    <div align=left>
      <img src=https://blog.kekwy.com/media/iw1/image-20221022104342889.png width=225 />
      <img src=https://blog.kekwy.com/media/iw1/image-20221022103847478.png width=250 />
    </div>

#### 1.1.3 按键区域（View2）

<div align=left>
  <img src=https://blog.kekwy.com/media/iw1/image-20221022105450619.png width=300 />
  <img src=https://blog.kekwy.com/media/iw1/image-20221022110946864.png width=225 />
</div>
- VIew：为按键区域提供指定的背景色。

- Stack View：管理附加按键区与常规按键区。

- 主要约束：将按键区的高设置为屏幕高的70%：

  ```
  View.height = 0.7 × height
  ```

##### 1.1.3.1. 常规按键区

<div align=left>
  <img src=https://blog.kekwy.com/media/iw1/image-20221022125626690.png width=225 />
  <img src=https://blog.kekwy.com/media/iw1/image-20221022111946572.png width=225 />
</div>
- **前四行按钮：**

  1. 填充策略为 `Fill Equally`；
  2. 每行四个按钮由一个 `Stack View` 管理，填充策略同样为 `Fill Equally`；
  3. 通过约束将其高度设置为整个按键区高度的66%。

  <div align=left>
    <img src=https://blog.kekwy.com/media/iw1/image-20221022130536389.png width=225 />
    <img src=https://blog.kekwy.com/media/iw1/image-20221022130320506.png width=175 />
  </div>

- **后两行按钮**：

  包含两个 `Stack View`。位于左侧的 `Stack View` 管理左侧六个按钮，排成两行，其中每行三个按钮又由一个 `Stack View` 管理；位于右侧的 `Stack View` 中只有作为等于操作键的一个按钮，可使其高度约为其他按钮的两倍。

  <div align=left>
    <img src=https://blog.kekwy.com/media/iw1/image-20221022130925213.png width=225 />
    <img src=https://blog.kekwy.com/media/iw1/image-20221022131554415.png width=175 />
  </div>
通过设置约束，将左侧 `Stack View` 的宽约束为整个常规按键区宽度的75%。 

##### 1.1.3.2 附加按键区

> 在切换为科学计算器（设备横屏）时自动显示

<div align=left>
  <img src=https://blog.kekwy.com/media/iw1/image-20221022135217250.png width=550 />
</div>
- 与常规按键区类似，每行三个按钮由一个 `Stack View` 管理，该部分所有 `Stack View` 的填充方式均为 `Fill Equally`。
- 设置约束，将管理整个附加按键区的 `Stack View` 的宽设置为整个按键区宽的3/7。

##### 1.1.3.3 按钮细节

通过设置按钮属性 `layer.cornerRadius` 设置按钮圆角的弧度。竖屏状态设置为20，横屏状态设置为40.

### 1.2. D/R Show Label

<div align=left>
  <img src=https://blog.kekwy.com/media/iw1/image-20221022140840244.png width=550 />
</div>
用于显示当前的计算模式是弧度制（Rad）还是角度制（Deg）。横屏模式下显示于显示区域的左上角（通过约束实现），竖屏模式自动隐藏，可通过相关功能按键进行切换。

## 2 功能实现

### 2.1 基础功能

#### 2.1.1 用户输入处理

用户每次点击按钮时，计算器会执行其运行逻辑。对于非功能按钮，用户输入会在 ViewController 中被追加在当前表达式之后，然后整个表达式会被传入 Calculator 进行解析。

若用户点击功能性按钮，将在 ViewController 中调用相应的函数进行处理。

#### 2.1.2 主要运算逻辑

> 良好的支持多优先级操作符

使用中缀表达式转后缀表达式的计算思路，参考《数据结构》。为每个操作符设置栈中优先级和栈外优先级，天然的支持多优先级运算，即良好的支持了科学计算器中出现的多个复杂操作符。

```swift
let isp = ["#": 0,
               "(": 1,
               "×": 5,
               "÷": 5,
               ...
    ]
    
    let icp = ["#": 0,
               "(": 10,
               "×": 4,
               "÷": 4,
               ...
    ]
```

同时设置两个栈结构，一个用于保存操作数，另一个用于保存操作符，当有操作符退栈时，根据其运算规则从操作数栈中退出若干操作数，进行运算后将结果压入操作数栈。

```swift
private func calSubExp(opt: String) -> Bool{
        ...
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
            ...
```

#### 2.1.3 memery 操作

主要处理 memery 中出错和 memery 为空的情况：

```swift
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
```

#### 2.1.4 角度制与弧度制的切换

计算三角函数时，根据当前计算器的模式对操作数进行转换（浮点数精度可能导致误差）：

```swift
if !isRad { // 表示处于角度制模式
  tmp = 360 * tmp / (2 * acos(-1.0))
}
```

#### 2.1.5 按钮功能切换（函数与反函数之间的互换）

当使用者点击 `inv` 按钮时，会更改部分按钮的 title。被更改 title 的按钮被点击时，在根据新的 title 在 `buttonTouched` 中执行对应的分支。再次点击 `inv` 会复原这些按钮之前的 title，即实现按钮功能的切换。

```swift
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
```

#### 2.1.6 转动设备时的界面切换

重写 `didRotate` 对设备旋转时的事件进行处理：

```swift
override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
    let device = UIDevice.current
    if device.orientation == .landscapeLeft || device.orientation == .landscapeRight {
        //横屏时候要做的事 do something
        launchScienceMode()
    } else {
        launchNormalMode()
    }
}
```

- 设备旋转为横屏时，调用 `launchScienceMode`：

  显示附加按键区，更改按钮 title 的字号，更改按钮四个角的弧度。

- 设备旋转为竖屏时，调用 `launchNormalMode`：

  隐藏附加按键区，恢复按钮 title 的字号，恢复按钮四个角的弧度。

### 2.2 辅助功能

#### 2.2.1 等于操作的作用

> 自动显示运算结果的工作模式下，等于操作符的作用

使用者点击等于操作符时，会将当前的待计算表达式替换为当前的运算结果。

#### 2.2.2. 更好的删除操作

一般状态下使用者点击删除按钮会删除表达式中前一个字符，但当前一个字符与其之前的若干字符为一个整体时，会将其一同删除。（如 `sin(` 会作为一个整体同时删除）

#### 2.2.3 面向用户的报错机制

当计算过程中遇到任何语法错误无法向下计算时，会返回运算结果“ERROR”提示用户更改表达式，而不会继续解析格式错误的表达式。

## 3 问题与解决

### 3.1 使 Stack View 中的空间按比例布局

> tags: Swift; StoryBoard; Stack View; xcode; iOS; 比例; 布局; 控件; UIKit;

首先将 `Stack View` 的属性 `Distribution` 更改为 `Fill Proportionally`。

<body style="text-align:left">
<img src="https://blog.kekwy.com/media/iw1/image-20221108143937299.png" alt="image-20221108143937299" width=300 />
</body>

选中需要布局的控件，按住 `command` 键拖到该 `Stack View` 上，

<body style="text-align:left">
<img src="https://blog.kekwy.com/media/iw1/image-20221108145000732.png" alt="image-20221108145000732" width=450 />
</body>

选择 `Equal Widths` （若需要纵向成比例布局，则选择 `Equal Heights`）添加约束。

`Additional Buttons.width = 0.4285 × width` 即表示控件 `Additional Buttons` 的宽为 `Stack View` 宽度的42.85%。

<body style="text-align:left">
<img src="https://blog.kekwy.com/media/iw1/image-20221108153913974.png" alt="image-20221108153913974" width=350 />
</body>

### 3.2 Swift获取当前设备的状态

> tags: Swift; StoryBoard; xcode; iOS; 横屏; 竖屏; 设备状态; 

```swift
let device = UIDevice.current	// 获取当前设备对象
// 通过orientation属性获取设备朝向
if device.orientation == .landscapeLeft || device.orientation == .landscapeRight {
  // 横屏时要做的事
  ...
}
```

### 3.3 代码实现修改Button字体大小

> tags: Swift; xcode; iOS; UIButton; 字体大小;

```swift
// 获取指定大小的字体
func getFont(size: CGFloat) -> UIFont {
    return UIFont.systemFont(ofSize: size)
}
// 修改原有字体
expLabel.font = getFont(size: 38.0)
```

### 3.4 设置圆形的Button

在 xcode 中为 Button 添加如下属性：

<body style="text-align:left">
<img src="https://blog.kekwy.com/media/iw1/image-20221108153117616.png" alt="image-20221108153117616" width=320 />
</body>

代码实现：

``` swift
dotButton.layer.cornerRadius = 40.0
```

该属性为 Button 四角的弧度，经调整后即可实现圆形的 Button。

## 4 成果展示

### 4.1 完整流程

https://blog.kekwy.com/media/iw1/01.mp4

### 4.2 压力测试（随便乱按）

https://blog.kekwy.com/media/iw1/test.mov

