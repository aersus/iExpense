//
//  ContentView.swift
//  iExpense
//
//  Created by Ahmet Ersüs on 28.01.21.
//

import SwiftUI

struct ExpenseItem: Identifiable, Codable {
    let id = UUID()
    let name: String
    let type: String
    let amount: Int
    
    enum CodingKeys: String, CodingKey {
        case name, type, amount
    }
}

class Expense: ObservableObject {
    
    @Published var items: [ExpenseItem] {
        didSet {
            let encoder = JSONEncoder()
            if let data = try? encoder.encode(items) {
                UserDefaults.standard.set(data, forKey: "Items")
            }
        }
    }
    
    init() {
        if let data = UserDefaults.standard.data(forKey: "Items") {
            let decoder = JSONDecoder()
            if let decoded = try? decoder.decode([ExpenseItem].self, from: data) {
                self.items = decoded
                return
            }
        }
        self.items = []
    }
}

struct ContentView: View {
    
    @ObservedObject private var expenses = Expense()
    @State private var showingSheet = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(expenses.items) { item in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(item.name)
                            Text(item.type)
                        }
                        Spacer()
                        if item.amount < 10 {
                            Text("$\(item.amount)")
                                .font(.title3)
                        } else if item.amount < 100 {
                            Text("$\(item.amount)")
                                .font(.title2)
                        } else {
                            Text("$\(item.amount)")
                                .font(.title)
                        }
                    }
                }
                .onDelete(perform: removeItem)
            }
            .navigationBarTitle("iExpense")
            .navigationBarItems(leading: EditButton(), trailing:
                                    Button(action: {
                                        self.showingSheet = true
                                    }, label: {
                                        Image(systemName: "plus")
                                    })
                                )
            .sheet(isPresented: $showingSheet, content: {
                AddView(expenses: self.expenses)
            })
        }
    }
    
    func removeItem(at offsets: IndexSet) {
        expenses.items.remove(atOffsets: offsets)
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
