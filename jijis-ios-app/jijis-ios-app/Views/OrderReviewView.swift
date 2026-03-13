//
//  OrderReviewView.swift
//  Jiji's Patisserie
//
//  Created by Manni Amoah on 3/12/26.
//

import SwiftUI

// MARK: - Supporting types

enum TipOption: CaseIterable {
    case none, ten, fifteen, twenty

    var label: String {
        switch self {
        case .none:    return "No Tip"
        case .ten:     return "10%"
        case .fifteen: return "15%"
        case .twenty:  return "20%"
        }
    }

    func amount(for subtotal: Double) -> Double {
        switch self {
        case .none:    return 0
        case .ten:     return subtotal * 0.10
        case .fifteen: return subtotal * 0.15
        case .twenty:  return subtotal * 0.20
        }
    }
}

enum PaymentMethod: CaseIterable {
    case applePay, card

    var label: String {
        switch self {
        case .applePay: return "Apple Pay"
        case .card:     return "Card"
        }
    }

    var apiValue: String {
        switch self {
        case .applePay: return "apple_pay"
        case .card:     return "card"
        }
    }
}

// MARK: - View

struct OrderReviewView: View {
    let slot: PickupSlot
    let dismissSheet: () -> Void

    @EnvironmentObject var cartViewModel: CartViewModel
    @EnvironmentObject var userProfile: UserProfileViewModel
    @EnvironmentObject var services: ServiceContainer

    @StateObject private var orderViewModel = OrderViewModel()

    @State private var selectedTip: TipOption = .none
    @State private var selectedPayment: PaymentMethod = .applePay
    @State private var cardNumber = ""
    @State private var expiration = ""
    @State private var cvv = ""

    private var tipAmount: Double { selectedTip.amount(for: cartViewModel.subtotal) }
    private var total: Double { cartViewModel.subtotal + tipAmount }

    var body: some View {
        List {

            // MARK: - Order items
            Section("Your Order") {
                ForEach(cartViewModel.items) { cartItem in
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text(cartItem.menuItem.name).font(.subheadline)
                            Text("Qty: \(cartItem.quantity)").font(.caption).foregroundStyle(.secondary)
                        }
                        Spacer()
                        Text(String(format: "$%.2f", cartItem.menuItem.price * Double(cartItem.quantity)))
                            .font(.subheadline).fontWeight(.medium)
                    }
                    .padding(.vertical, 2)
                }
            }

            // MARK: - Pickup details
            Section("Pickup Details") {
                LabeledContent("Date", value: slot.date)
                LabeledContent("Window", value: slot.timeWindow)
                // TODO: Future — allow editing pickup selection from here
                // TODO: Future — show map / address for pickup location
            }

            // MARK: - Contact info
            Section("Contact Info") {
                TextField("Full Name", text: $userProfile.name)
                    .textContentType(.name).autocorrectionDisabled()

                TextField("Email", text: $userProfile.email)
                    .textContentType(.emailAddress).keyboardType(.emailAddress)
                    .autocorrectionDisabled().textInputAutocapitalization(.never)

                TextField("Phone Number", text: $userProfile.phone)
                    .textContentType(.telephoneNumber).keyboardType(.phonePad)

                if !userProfile.isComplete {
                    Text("Please fill in all fields to continue to payment.")
                        .font(.caption).foregroundStyle(.secondary)
                }
                // TODO: Future — sync contact info to user account on backend
            }

            // MARK: - Tip selection
            Section("Add a Tip") {
                HStack(spacing: 8) {
                    ForEach(TipOption.allCases, id: \.label) { option in
                        Button {
                            selectedTip = option
                        } label: {
                            Text(option.label)
                                .font(.subheadline).fontWeight(.medium)
                                .frame(maxWidth: .infinity).padding(.vertical, 8)
                                .background(selectedTip == option ? Color.brandHotPink : Color(.systemGray5))
                                .foregroundStyle(selectedTip == option ? .white : .primary)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.vertical, 4)
                // TODO: Future — add custom tip amount input
            }

            // MARK: - Payment method
            // TODO: Future — integrate real Stripe SDK for card payments
            // TODO: Future — integrate real Apple Pay via PassKit / PKPaymentButton
            // TODO: Future — support saved payment methods
            Section("Payment") {
                if !userProfile.isComplete {
                    Text("Complete your contact info above to choose a payment method.")
                        .font(.subheadline).foregroundStyle(.secondary).padding(.vertical, 4)
                } else {
                    HStack(spacing: 12) {
                        ForEach(PaymentMethod.allCases, id: \.label) { method in
                            Button {
                                selectedPayment = method
                            } label: {
                                HStack {
                                    Image(systemName: method == .applePay ? "apple.logo" : "creditcard")
                                    Text(method.label).font(.subheadline).fontWeight(.medium)
                                }
                                .frame(maxWidth: .infinity).padding(.vertical, 10)
                                .background(selectedPayment == method ? Color.brandHotPink : Color(.systemGray5))
                                .foregroundStyle(selectedPayment == method ? .white : .primary)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.vertical, 4)

                    if selectedPayment == .card {
                        VStack(spacing: 12) {
                            TextField("Card Number", text: $cardNumber)
                                .keyboardType(.numberPad).textContentType(.creditCardNumber)
                                .padding(10).background(Color(.systemGray6))
                                .clipShape(RoundedRectangle(cornerRadius: 8))

                            HStack(spacing: 12) {
                                TextField("MM / YY", text: $expiration)
                                    .keyboardType(.numberPad).padding(10)
                                    .background(Color(.systemGray6)).clipShape(RoundedRectangle(cornerRadius: 8))

                                TextField("CVV", text: $cvv)
                                    .keyboardType(.numberPad).padding(10)
                                    .background(Color(.systemGray6)).clipShape(RoundedRectangle(cornerRadius: 8))
                            }
                        }
                        .padding(.vertical, 4)
                    }

                    if selectedPayment == .applePay {
                        HStack {
                            Image(systemName: "apple.logo")
                            Text("Pay").fontWeight(.semibold)
                        }
                        .frame(maxWidth: .infinity).padding()
                        .background(Color.black).foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 8)).padding(.vertical, 4)
                    }
                }
            }

            // MARK: - Totals
            // TODO: Future — add tax calculation
            // TODO: Future — add loyalty rewards discount line
            Section {
                HStack {
                    Text("Subtotal").foregroundStyle(.secondary)
                    Spacer()
                    Text(String(format: "$%.2f", cartViewModel.subtotal)).foregroundStyle(.secondary)
                }
                if tipAmount > 0 {
                    HStack {
                        Text("Tip (\(selectedTip.label))").foregroundStyle(.secondary)
                        Spacer()
                        Text(String(format: "$%.2f", tipAmount)).foregroundStyle(.secondary)
                    }
                }
                HStack {
                    Text("Total").font(.headline)
                    Spacer()
                    Text(String(format: "$%.2f", total)).font(.headline).foregroundStyle(Color.brandOrange)
                }
            }

            // Error message
            if let error = orderViewModel.errorMessage {
                Section {
                    Text(error)
                        .font(.subheadline)
                        .foregroundStyle(.red)
                }
            }
        }
        .scrollContentBackground(.hidden)
        .background(Color.brandWarmWhite)
        .navigationTitle("Review Order")
        .navigationBarTitleDisplayMode(.large)
        // Navigate to confirmation as soon as confirmation is set
        .navigationDestination(item: $orderViewModel.confirmation) { confirmation in
            OrderConfirmationView(confirmation: confirmation, dismissSheet: dismissSheet)
        }
        .overlay {
            if orderViewModel.isSubmitting {
                ZStack {
                    Color.black.opacity(0.3).ignoresSafeArea()
                    VStack(spacing: 16) {
                        ProgressView()
                            .progressViewStyle(.circular)
                            .tint(.white)
                        Text("Placing your order…")
                            .foregroundStyle(.white)
                            .font(.subheadline)
                    }
                    .padding(32)
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                }
            }
        }
        .safeAreaInset(edge: .bottom) {
            Button {
                Task {
                    let request = OrderRequest(
                        customer: CustomerInfo(
                            name: userProfile.name,
                            email: userProfile.email,
                            phone: userProfile.phone
                        ),
                        items: cartViewModel.items.map { OrderItem(from: $0) },
                        pickupSlot: slot,
                        subtotal: cartViewModel.subtotal,
                        tipAmount: tipAmount,
                        total: total,
                        paymentMethod: selectedPayment.apiValue
                    )
                    await orderViewModel.submit(request, using: services.order)
                    if orderViewModel.confirmation != nil {
                        cartViewModel.clearCart()
                    }
                }
            } label: {
                Text("Place Preorder — \(String(format: "$%.2f", total))")
                    .font(.headline).frame(maxWidth: .infinity).padding()
                    .background(userProfile.isComplete ? Color.brandHotPink : Color.gray)
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .padding(.horizontal).padding(.bottom, 8)
            }
            .disabled(!userProfile.isComplete || orderViewModel.isSubmitting)
            .background(.ultraThinMaterial)
            // TODO: Future — replace with real Stripe / Apple Pay payment confirmation
            // TODO: Future — persist order to backend before navigating to confirmation
        }
    }
}

#Preview {
    NavigationStack {
        OrderReviewView(
            slot: PickupSlot(id: UUID().uuidString, date: "Friday, March 15", timeWindow: "12:00 PM – 2:00 PM"),
            dismissSheet: {}
        )
        .environmentObject(CartViewModel())
        .environmentObject(UserProfileViewModel())
        .environmentObject(ServiceContainer.mock)
    }
}
