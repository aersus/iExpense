//
//  AddView.swift
//  iExpense
//
//  Created by Ahmet Ersüs on 28.01.21.
//

import SwiftUI

struct AddView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var expenses: Expense
    @State private var name = ""
    @State private var type = "Personal"
    @State private var amount = ""
    static let types = ["Personal", "Business"]
    @State private var showingAlert = false
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Name", text: $name)
                Picker("Type", selection: $type) {
                    ForEach(AddView.types, id: \.self) {
                        Text($0)
                    }
                }
                TextField("Amount", text: $amount)
                    .keyboardType(.numberPad)
            }
            .navigationBarTitle("Add new expense")
            .navigationBarItems(trailing:
                                    Button("Save") {
                                        if let actualAmount = Int(self.amount) {
                                            let expenseItem = ExpenseItem(name: self.name, type: self.type, amount: actualAmount)
                                            self.expenses.items.append(expenseItem)
                                            self.presentationMode.wrappedValue.dismiss()
                                        } else {
                                            self.showingAlert = true
                                        }
                                    }
            )
            .alert(isPresented: $showingAlert, content: {
                Alert(title: Text("Warning"), message: Text("Please enter proper value."), dismissButton: .default(Text("OK")))
            })
        }
    }
}

struct AddView_Previews: PreviewProvider {
    static var previews: some View {
        AddView(expenses: Expense())
    }
}
