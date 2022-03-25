//
//  ContentView.swift
//  WeConversion
//
//  Created by Rolando Garcia on 24/03/22.
//

import SwiftUI


// feet, yards, miles
private let lengths = ["m","km","f","yr","ml"]


struct ContentView: View {
    
    // All in meters
    private let m = 1.0
    private let km = 1000.0
    private let f = 0.3
    private let yr = 0.9144
    private let ml = 1609.34
    
    
    @State private var amountToConvert = 0.0
    // Measures to select
    @State private var currentInputLength = lengths[0]
    @State private var expectedOutputLength = lengths[lengths.count - 1]
    // Why this dont use a default value like the @State
    // https://www.hackingwithswift.com/quick-start/swiftui/what-is-the-focusstate-property-wrapper
    // Something intereting. Because this allow to keep the form in an atractive way to the users...
    @FocusState private var isFocused : Bool
    // Computer property
    private var expectedAmout : Double {
        
        // Everything is converted to m
        
        if currentInputLength == expectedOutputLength {return amountToConvert}
        
        let inputInMeters = convertToMeters(amount: amountToConvert, from: currentInputLength)
        
        return convertFromMeters(meters: inputInMeters, to: expectedOutputLength)
    }
    
    /**
           Another way to do this:  https://www.hackingwithswift.com/example-code/system/how-to-convert-units-using-unit-and-measurement
     */
    
    func convertFromMeters(meters : Double, to : String) -> Double {
        
        if to == "m" {return meters}
        
        var valueToDivide = 0.0
        
        switch to {
        case "km":
            valueToDivide = km
        case "f":
            valueToDivide = f
        case "yr":
            valueToDivide = yr
        case "ml":
            valueToDivide = ml
        default:
            valueToDivide = 0
        }
        
        return meters / valueToDivide
    }
    
    func convertToMeters(amount : Double, from : String)  -> Double {
        
        if from == "m" {return amount}
        
        var result : Double = 0
        
        // Math Operations
        switch from {
        case "km":
            result = amount * km
        case "f":
            result = amount * f
        case "yr":
            result = amount * yr
        case "ml":
            result = amount * ml
        default:
            return -1
        }
    
        return result
    }
    
    // Sometimes when the compiler does not knows some result of the view report a bug
    // In that case make sure to use the view and the data in the correct place
    // otherwise u have to debugging the application.
    var body : some View {
        NavigationView {
            Form {
                Section {
                    TextField("Amount",value: $amountToConvert,format: .number)
                        .keyboardType(.decimalPad)
                        .focused($isFocused)
                    Picker("Selected",selection: $currentInputLength) {
                        ForEach(lengths,id:\.self){
                            Text("\($0)")
                        }
                    }.pickerStyle(.segmented)
                    // Create the picker
                } header: {
                    Text("Select your input")
                }
                
                Section {
                    Picker("Selected",selection: $expectedOutputLength) {
                        ForEach(lengths,id:\.self){
                            Text("\($0)")
                        }
                    }.pickerStyle(.segmented)
                  Text(expectedAmout, format: .number)
                } header: {
                    Text("To")
                }
            }.navigationTitle("WeConversion")
                .toolbar {
                    ToolbarItemGroup (placement: .keyboard) {
                        Spacer()
                        Button ("Done") {
                            // Hide the keyboard
                            isFocused = false
                        }
                    }
                }
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
