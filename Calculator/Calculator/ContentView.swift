import SwiftUI

struct ContentView: View {
    @State private var displayText = "0"
    @State private var currentOperation: Operation?
    @State private var firstNumber: Double?
    @State private var isEnteringSecondNumber = false
    
    let buttonLabels = [
        ["AC", "+/-", "%", "÷"],
        ["7", "8", "9", "×"],
        ["4", "5", "6", "-"],
        ["1", "2", "3", "+"],
        ["0", ".", "="]
    ]
    
    enum Operation {
        case add, subtract, multiply, divide, none
    }
    
    var body: some View {
        VStack(spacing: 10) {
            Spacer()
            // Display Screen
            Text(displayText)
                .font(.system(size: 120, weight: .bold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding()
                .background(Color.black)
            
            // Buttons
            ForEach(buttonLabels, id: \.self) { row in
                HStack(spacing: 10) {
                    ForEach(row, id: \.self) { label in
                        Button(action: {
                            buttonTapped(label)
                        }) {
                            Text(label)
                                .font(.system(size: 60, weight: .bold))
                                .frame(width: buttonWidth(label), height: buttonHeight())
                                .background(buttonColor(label))
                                .foregroundColor(.white)
                                .cornerRadius(buttonHeight() / 2)
                        }
                    }
                }
            }
        }
        .padding()
        .background(Color.black)
        .edgesIgnoringSafeArea(.all)
    }
    
    // Button Colors
    func buttonColor(_ label: String) -> Color {
        if label == "AC" || label == "+/-" || label == "%" {
            return Color.gray
        } else if label == "=" || label == "+" || label == "-" || label == "×" || label == "÷" {
            return Color.orange
        } else {
            return Color(white: 0.2)
        }
    }
    
    // Button Size
    func buttonWidth(_ label: String) -> CGFloat {
        return label == "0" ? ((UIScreen.main.bounds.width - 50) / 4) * 2 + 10 : (UIScreen.main.bounds.width - 50) / 4
    }
    
    func buttonHeight() -> CGFloat {
        return (UIScreen.main.bounds.width - 50) / 4
    }
    
    // Button Actions
    func buttonTapped(_ label: String) {
        switch label {
        case "AC":
            resetCalculator()
        case "+/-":
            toggleSign()
        case "%":
            applyPercentage()
        case "÷":
            setOperation(.divide)
        case "×":
            setOperation(.multiply)
        case "-":
            setOperation(.subtract)
        case "+":
            setOperation(.add)
        case "=":
            performOperation()
        case ".":
            appendDecimal()
        default:
            appendNumber(label)
        }
    }
    
    // Calculator Logic
    func resetCalculator() {
        displayText = "0"
        currentOperation = .none
        firstNumber = nil
        isEnteringSecondNumber = false
    }
    
    func toggleSign() {
        if let number = Double(displayText) {
            displayText = String(number * -1)
        }
    }
    
    func applyPercentage() {
        if let number = Double(displayText) {
            displayText = String(number / 100)
        }
    }
    
    func setOperation(_ operation: Operation) {
        currentOperation = operation
        firstNumber = Double(displayText)
        isEnteringSecondNumber = true
    }
    
    func performOperation() {
        if let operation = currentOperation, let firstNumber = firstNumber, let secondNumber = Double(displayText) {
            switch operation {
            case .add:
                displayText = String(firstNumber + secondNumber)
            case .subtract:
                displayText = String(firstNumber - secondNumber)
            case .multiply:
                displayText = String(firstNumber * secondNumber)
            case .divide:
                displayText = secondNumber == 0 ? "Error" : String(firstNumber / secondNumber)
            default:
                break
            }
        }
        isEnteringSecondNumber = false
        currentOperation = .none
    }
    
    func appendDecimal() {
        if !displayText.contains(".") {
            displayText += "."
        }
    }
    
    func appendNumber(_ number: String) {
        if displayText == "0" || isEnteringSecondNumber {
            displayText = number
            isEnteringSecondNumber = false
        } else {
            displayText += number
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
