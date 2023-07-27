//
//  ContentView.swift
//  WeSplit
//
//  Created by Abul Kalam Azad on 26/7/23.
//

import SwiftUI

struct ContentView: View {
    @State private var checkAmount = 0.0
    @State private var numberOfPeople = 0
    @State private var tipPercentage = 0
    
    @FocusState private var amountIsFoucused: Bool
        
    var totalPerPerson: Double {
        // calculate the total per person here
        let peopleCount = Double(numberOfPeople + 2)
        let tipSelection = Double(tipPercentage)
        
        let tipValue = checkAmount / 100 * tipSelection
        let grandTotal = checkAmount + tipValue
        let amountPerPerson = grandTotal / peopleCount
        
        return amountPerPerson
    }
    
    let currencyCode = Locale.current.currency?.identifier ?? "USD"
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    checkAmountTextField
                        .multilineTextAlignment(.center)
                        .keyboardType(.decimalPad)
                        .focused($amountIsFoucused)
                } header: {
                    Text("Check Amount")
                }
                
                numberOfPeoplePicker()
                
                tipPercentagePicker()
                
                Section {
                    summaryLine(label: "Tip:",
                                amount: (currencyFormatter.string(from: NSNumber(value: checkAmount / 100 * Double(tipPercentage))) ?? "__"),
                                color: .gray)
                    summaryLine(label: "Per Person:",
                                amount: (currencyFormatter.string(from: NSNumber(value: totalPerPerson)) ?? "__"),
                                color: .green)
                }
            }
            .navigationTitle("WeSplit")
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button("Done") {
                        amountIsFoucused = false
                    }
                }
            }
        }
    }
    
    private var currencyFormatter: NumberFormatter = {
        let f = NumberFormatter()
        f.isLenient = true
        f.numberStyle = .currency
        
        return f
    }()
    
    private var checkAmountTextField: some View {
        if #available(iOS 15.0, *) {
            return TextField("Check amount", value: $checkAmount, format: .currency(code: currencyCode))
        } else {
            return TextField("Check amount", value: $checkAmount, formatter: currencyFormatter)
        }
    }
    
    private func summaryLine(label: String, amount: String, color: Color) -> some View {
        HStack {
            Spacer()
            Text(label)
                .font(.title)
                .foregroundColor(color)
            Text(amount)
                .font(.title)
                .foregroundColor(color)
        }.padding(.trailing)
    }
    
    private func tipPercentagePicker() -> some View {
        Section {
            Picker("Tip Percentage", selection: $tipPercentage) {
                ForEach(0 ..< 101) {
                    Text($0, format: .percent
                    )
                }
            }
        } header: {
            Text("How much tip do you want to leave?")
        }
    }
    
    private func numberOfPeoplePicker() -> some View {
        Section {
            Picker("Number of people", selection: $numberOfPeople) {
                ForEach(2 ..< 21) {
                    Text("\($0) people")
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
