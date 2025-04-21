//
//  CustomTextFieldView.swift
//  Sun&Moon
//
//  Created by Martin Lanius on 20.04.25.
//

import SwiftUI
import UIKit

// A custom TextField that uses a UIKit UITextField under the hood.
// It became necessary because a SwiftUI TextField always triggers a standard keyboard,
// either letters or numbers. Here a special keyboard is needed for location coordinates.

// This allows for more control and integration with UIKit features,
// such as setting a custom inputView (our NumPadView).
struct CustomTextField: UIViewRepresentable {
    @Binding var text: String // Binding to the text entered in the TextField
    @Binding var isFocused: Bool // Binding to track whether the TextField is currently focused
    var keyboardType: UIKeyboardType = .numberPad // The keyboard type to use by default

    // Creates the underlying UIKit
    func makeUIView(context: Context) -> UITextField {
        let textField = UITextField()
        textField.delegate = context.coordinator // Sets the delegate to our Coordinator for handling events
        textField.keyboardType = keyboardType // Sets the keyboard type for text input
        textField.inputView = context.coordinator.numPadHostView?.view // Sets our custom NumPad as the input view
        textField.backgroundColor = UIColor.white // Sets the background color of the TextField to white
        textField.layer.cornerRadius = 4 // Sets the corner radius for rounded corners
        textField.layer.masksToBounds = true // Ensures that the rounded corners are applied within the bounds

        // Add left padding to match SwiftUI TextField appearance
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: textField.frame.size.height))
        textField.leftView = paddingView // Sets the left view (for padding)
        textField.leftViewMode = .always // Makes the left view always visible

        // Set the placeholder text based on the keyboard type
        switch keyboardType {
        case .numberPad:
            textField.placeholder = (keyboardType == .decimalPad) ? "00.00" : "00.00" // Placeholder for numeric input
        default:
            textField.placeholder = "" // Default placeholder for other keyboard types (if used)
        }
        return textField
    }

    // Updates the UIKit view when the SwiftUI state changes.
    func updateUIView(_ uiView: UITextField, context: Context) {
        uiView.text = text // Updates the text in the UITextField when the SwiftUI text binding changes
        // Handle focus changes: becomeFirstResponder() to focus, resignFirstResponder() to unfocus
        if isFocused && !uiView.isFirstResponder {
            uiView.becomeFirstResponder() // Programmatically focus the UITextField
        } else if !isFocused && uiView.isFirstResponder {
            uiView.resignFirstResponder() // Programmatically unfocus the UITextField
        }
    }

    // Creates the coordinator that acts as the UITextFieldDelegate.
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    // Coordinator to handle UITextFieldDelegate methods and communication with SwiftUI.
    class Coordinator: NSObject, UITextFieldDelegate {
        let parent: CustomTextField // Reference to the parent SwiftUI view
        var numPadHostView: UIHostingController<NumPadView>? // Hosting controller for our custom NumPadView

        // Initializes the coordinator.
        init(_ textField: CustomTextField) {
            parent = textField
            let numPad = NumPadView(text: parent.$text) // Create an instance of our NumPadView
            numPadHostView = UIHostingController(rootView: numPad) // Embed the NumPadView in a UIHostingController
            // Set the frame for the NumPadView to define its size when presented as inputView.
            // Adjust the height as needed to fit the NumPad layout.
            numPadHostView?.view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 3.5 + 22)
        }

        // Called when the text field begins editing (gains focus).
        func textFieldDidBeginEditing(_ textField: UITextField) {
            parent.isFocused = true // Update the SwiftUI isFocused binding when focus occurs
        }

        // Called when the text field ends editing (loses focus).
        func textFieldDidEndEditing(_ textField: UITextField) {
            parent.isFocused = false // Update the SwiftUI isFocused binding when focus is lost
        }
    }
}
