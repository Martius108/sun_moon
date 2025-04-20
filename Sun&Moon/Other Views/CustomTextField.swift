//
//  CustomTextFieldView.swift
//  Sun&Moon
//
//  Created by Martin Lanius on 20.04.25.
//

import SwiftUI
import UIKit

struct CustomTextField: UIViewRepresentable {
    @Binding var text: String
    @Binding var isFocused: Bool
    var keyboardType: UIKeyboardType = .numberPad

    // Creates the underlying UIKit view (UITextField).
    func makeUIView(context: Context) -> UITextField {
        let textField = UITextField()
        textField.delegate = context.coordinator
        textField.keyboardType = keyboardType
        textField.inputView = context.coordinator.numPadHostView?.view
        textField.backgroundColor = UIColor.white
        textField.layer.cornerRadius = 4
        textField.layer.masksToBounds = true

        // Add left padding
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: textField.frame.size.height))
        textField.leftView = paddingView
        textField.leftViewMode = .always

        // Set the placeholder text based on the keyboard type
        switch keyboardType {
        case .numberPad:
            textField.placeholder = (keyboardType == .decimalPad) ? "00.00" : "00.00" // Default case for Double
        default:
            textField.placeholder = "" // Default case for Text
        }
        return textField
    }

    // Updates the UIKit view when the SwiftUI state changes.
    func updateUIView(_ uiView: UITextField, context: Context) {
        uiView.text = text
        if isFocused && !uiView.isFirstResponder {
            uiView.becomeFirstResponder()
        } else if !isFocused && uiView.isFirstResponder {
            uiView.resignFirstResponder()
        }
    }

    // Creates the coordinator that acts as the UITextFieldDelegate.
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    // Coordinator to handle UITextFieldDelegate methods and communication with SwiftUI.
    class Coordinator: NSObject, UITextFieldDelegate {
        let parent: CustomTextField
        var numPadHostView: UIHostingController<NumPadView>?

        // Initializes the coordinator.
        init(_ textField: CustomTextField) {
            parent = textField
            let numPad = NumPadView(text: parent.$text)
            numPadHostView = UIHostingController(rootView: numPad)
            // Set the frame for the NumPadView (adjust height as needed).
            numPadHostView?.view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 3.5 + 22)
        }

        // Called when the text field begins editing (gains focus).
        func textFieldDidBeginEditing(_ textField: UITextField) {
            parent.isFocused = true
        }

        // Called when the text field ends editing (loses focus).
        func textFieldDidEndEditing(_ textField: UITextField) {
            parent.isFocused = false
        }
    }
}
