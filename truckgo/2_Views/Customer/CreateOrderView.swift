import SwiftUI
import SwiftData

struct CreateOrderView: View {
    @Environment(\.modelContext) private var context
    @Environment(SessionManager.self) private var session
    @Environment(AppSettings.self) private var settings
    
    @State private var fromCity = Cities.all.first ?? ""
    @State private var toCity = Cities.all.dropFirst().first ?? ""
    @State private var cargoType: CargoType = .general
    @State private var weight = ""
    @State private var lengthCm = ""
    @State private var widthCm = ""
    @State private var heightCm = ""
    @State private var price = ""
    @State private var pickupDate = Date()
    @State private var showSuccess = false
    @State private var errorMessage = ""
    
    var t: L { L(settings) }
    
    var body: some View {
        NavigationStack {
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
                
                Section(t.s("order.cargoDetails")) {
                    Picker(t.s("order.type"), selection: $cargoType) {
                        ForEach(CargoType.allCases, id: \.self) { type in
                            Text(t.s(type.localizationKey)).tag(type)
                        }
                    }
                    TextField(t.s("order.weight"), text: $weight)
                        .keyboardType(.decimalPad)
                    TextField(t.s("order.length"), text: $lengthCm)
                        .keyboardType(.decimalPad)
                    TextField(t.s("order.width"), text: $widthCm)
                        .keyboardType(.decimalPad)
                    TextField(t.s("order.height"), text: $heightCm)
                        .keyboardType(.decimalPad)
                }
                
                Section(t.s("order.pickupPrice")) {
                    DatePicker(t.s("order.pickupDate"),
                               selection: $pickupDate,
                               displayedComponents: .date)
                    TextField(t.s("order.proposedPrice"), text: $price)
                        .keyboardType(.decimalPad)
                }
                
                if !errorMessage.isEmpty {
                    Section { Text(errorMessage).foregroundStyle(.red) }
                }
                
                Section {
                    Button(t.s("order.postOrder")) { createOrder() }
                        .frame(maxWidth: .infinity)
                }
            }
            .navigationTitle(t.s("tab.newOrder"))
            .appBackground()
            .alert(t.s("order.posted"), isPresented: $showSuccess) {
                Button(t.s("admin.ok")) { resetForm() }
            } message: {
                Text(t.s("order.postedMessage"))
            }
        }
    }
    
    private func createOrder() {
        // Validate cities are different
        guard fromCity != toCity else {
            errorMessage = t.s("order.sameCityError")
            return
        }
        
        // Validate numeric fields
        guard let weightVal = Double(weight), weightVal > 0,
              let lengthVal = Double(lengthCm), lengthVal > 0,
              let widthVal = Double(widthCm), widthVal > 0,
              let heightVal = Double(heightCm), heightVal > 0,
              let priceVal = Double(price), priceVal > 0,
              let email = session.currentUserEmail else {
            errorMessage = t.s("order.fillCorrectly")
            return
        }
        
        let order = Order(
            customerEmail: email,
            fromCity: fromCity,
            toCity: toCity,
            cargoType: cargoType,
            weight: weightVal,
            lengthCm: lengthVal,
            widthCm: widthVal,
            heightCm: heightVal,
            price: priceVal,
            pickupDate: pickupDate
        )
        context.insert(order)
        try? context.save()
        
        errorMessage = ""
        showSuccess = true
    }
    
    private func resetForm() {
        fromCity = Cities.all.first ?? ""
        toCity = Cities.all.dropFirst().first ?? ""
        weight = ""; lengthCm = ""; widthCm = ""; heightCm = ""; price = ""
        cargoType = .general
        pickupDate = Date()
    }
}
