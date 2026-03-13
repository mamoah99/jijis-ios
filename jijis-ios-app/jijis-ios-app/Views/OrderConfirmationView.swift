//
//  OrderConfirmationView.swift
//  Jiji's Patisserie
//
//  Created by Manni Amoah on 3/12/26.
//

import SwiftUI

struct OrderConfirmationView: View {
    let confirmation: OrderConfirmation
    let dismissSheet: () -> Void

    var body: some View {
        VStack(spacing: 32) {
            Spacer()

            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 72))
                .foregroundStyle(Color.brandHotPink)

            VStack(spacing: 10) {
                Text("Thank you!")
                    .font(.largeTitle).fontWeight(.bold)
                    .foregroundStyle(Color.brandDarkBrown)

                Text("Your preorder has been placed.\nWe'll have it ready for you!")
                    .font(.body).foregroundStyle(.secondary).multilineTextAlignment(.center)
            }

            // MARK: - Confirmation summary
            VStack(spacing: 8) {
                Text("Order \(confirmation.confirmationId)")
                    .font(.headline)
                    .foregroundStyle(Color.brandDarkBrown)

                Text(confirmation.pickupDate)
                    .font(.subheadline).foregroundStyle(.secondary)

                Text(confirmation.formattedPickupWindow)
                    .font(.subheadline).foregroundStyle(.secondary)

                Text(String(format: "Total: $%.2f", confirmation.total))
                    .font(.subheadline).fontWeight(.semibold).foregroundStyle(Color.brandOrange)
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.brandBlush.opacity(0.4))
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .padding(.horizontal)

            // TODO: Future — send confirmation email triggered from here
            // TODO: Future — schedule push notification reminder before pickup
            // TODO: Future — show order history / order tracking

            Spacer()

            Button {
                dismissSheet()
            } label: {
                Text("Back to Main Menu")
                    .font(.headline).frame(maxWidth: .infinity).padding()
                    .background(Color.brandHotPink).foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .padding(.horizontal)
            }

            Spacer()
        }
        .background(Color.brandWarmWhite.ignoresSafeArea())
        .navigationTitle("Order Confirmed")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    NavigationStack {
        OrderConfirmationView(
            confirmation: OrderConfirmation(
                confirmationId: "JIJI-4321",
                pickupDate: "Friday, March 15",
                pickupWindow: "12:00 PM – 2:00 PM",
                total: 13.50
            ),
            dismissSheet: {}
        )
    }
}
