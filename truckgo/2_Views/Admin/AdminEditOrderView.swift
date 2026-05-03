import SwiftUI
import SwiftData

struct AdminEditOrderView: View {
    @Environment(\.modelContext) private var context
    @Environment(AppSettings.self) private var settings
    @Environment(\.dismiss) private var dismiss
    
    let order: Order
    
    @State private var fromCity = ""
    @State private var toCity = ""
    @State private var lengthCm = ""
    @State private var widthCm = ""
    @State private var heightCm = ""
    @State private var weight = ""
    @State private var price = ""
    
    @State private var status: OrderStatus = .pending
    @State private var cargoType: CargoType = .general
    @State private var driverEmail = ""
    @State private var showDeleteConfirm = false
    
    var t: L { L(settings) }
    
    var body: some View {
        Form {
            Section(t.s("order.route")) {
                Picker(t.s("order.from"), selection: $fromCity) {
                    ForEach(Cities.all, id: \.self) { city in
                        Text(t.s(Cities.localizationKey(for: city))).tag(city)
                    }
                }
                Picker(t.s("order.to"), selection: $toCity) {
                    ForEach(Cities.all, id: \.self) { city in
                        Text(t.s(Cities.localizationKey(for: city))).tag(city)
                    }
                }
            }
            
            Section(t.s("order.cargo")) {
                Picker(t.s("order.type"), selection: $cargoType) {
                    ForEach(CargoType.allCases, id: \.self) { c in
                        Text(t.s(c.localizationKey)).tag(c)
                    }
                }
                TextField(t.s("order.weight"), text: $weight).keyboardType(.decimalPad)
                TextField(t.s("order.length"), text: $lengthCm).keyboardType(.decimalPad)
                TextField(t.s("order.width"), text: $widthCm).keyboardType(.decimalPad)
                TextField(t.s("order.height"), text: $heightCm).keyboardType(.decimalPad)
                TextField(t.s("order.price"), text: $price).keyboardType(.decimalPad)
            }
            
            Section(t.s("order.status")) {
                Picker(t.s("order.status"), selection: $status) {
                    ForEach(OrderStatus.allCases, id: \.self) { s in
                        Text(t.s(s.localizationKey)).tag(s)
                    }
                }
            }
            
            Section(t.s("admin.assignment")) {
                LabeledContent(t.s("admin.customer"), value: order.customerEmail)
                TextField(t.s("admin.driverEmail"), text: $driverEmail)
                    .textInputAutocapitalization(.never)
            }
            
            Section {
                Button(t.s("profile.saveChanges")) { save() }
                    .frame(maxWidth: .infinity)
            }
            
            Section {
                Button(t.s("admin.deleteOrder"), role: .destructive) {
                    showDeleteConfirm = true
                }
                .frame(maxWidth: .infinity)
            }
        }
        .navigationTitle(t.s("admin.editOrder"))
        .navigationBarTitleDisplayMode(.inline)
        .appBackground()
        .onAppear {
            fromCity = order.fromCity
            toCity = order.toCity
            weight = String(order.weight)
            lengthCm = String(order.lengthCm)
            widthCm = String(order.widthCm)
            heightCm = String(order.heightCm)
            price = String(order.price)
            status = order.status
            cargoType = order.cargoType
            driverEmail = order.driverEmail ?? ""
        }
        .alert(t.s("admin.confirmDeleteOrder"), isPresented: $showDeleteConfirm) {
            Button(t.s("admin.cancel"), role: .cancel) { }
            Button(t.s("admin.delete"), role: .destructive) { delete() }
        } message: {
            Text(t.s("admin.cannotUndone"))
        }
    }
    
    private func save() {
        order.fromCity = fromCity
        order.toCity = toCity
        order.weight = Double(weight) ?? order.weight
        order.lengthCm = Double(lengthCm) ?? order.lengthCm
        order.widthCm = Double(widthCm) ?? order.widthCm
        order.heightCm = Double(heightCm) ?? order.heightCm
        order.price = Double(price) ?? order.price
        order.status = status
        order.cargoType = cargoType
        order.driverEmail = driverEmail.isEmpty ? nil : driverEmail
        try? context.save()
        dismiss()
    }
    
    private func delete() {
        context.delete(order)
        try? context.save()
        dismiss()
    }
}
