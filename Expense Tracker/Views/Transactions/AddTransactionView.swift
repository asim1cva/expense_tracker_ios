import SwiftUI
import UIKit

struct AddTransactionView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: ExpenseViewModel

    @State private var title = ""
    @State private var amount = ""
    @State private var category: TransactionCategory = .food
    @State private var type: TransactionType = .expense
    @State private var date = Date()

    private let columns = [
        GridItem(.adaptive(minimum: 70))
    ]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Type Selection Header
                    HStack(spacing: 16) {
                        TypeSelectionCard(
                            type: .expense,
                            isSelected: type == .expense,
                            color: .red
                        ) { type = .expense }

                        TypeSelectionCard(
                            type: .income,
                            isSelected: type == .income,
                            color: .green
                        ) { type = .income }
                    }
                    .padding(.horizontal)
                    .padding(.top)

                    // Input Fields
                    VStack(spacing: 16) {
                        InputFieldRow(
                            icon: "pencil.and.outline",
                            placeholder: "What was this for?",
                            text: $title
                        )

                        InputFieldRow(
                            icon: "dollarsign.circle.fill",
                            placeholder: "0.00",
                            text: $amount,
                            isDecimal: true
                        )

                        DatePickerRow(
                            icon: "calendar",
                            date: $date
                        )
                    }
                    .padding()
                    .background(.thinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
                    .padding(.horizontal)

                    // Category Grid
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Select Category")
                            .font(.headline)
                            .padding(.horizontal)

                        LazyVGrid(columns: columns, spacing: 15) {
                            ForEach(TransactionCategory.allCases) { cat in
                                CategoryGridItem(
                                    category: cat,
                                    isSelected: category == cat
                                ) {
                                    category = cat
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                .padding(.bottom, 24)
            }
            .background(Color(UIColor.systemGroupedBackground).ignoresSafeArea())
            .navigationTitle("New Transaction")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") { dismiss() }
                        .foregroundColor(.secondary)
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Process") {
                        if let val = Double(amount), !title.isEmpty {
                            viewModel.addTransaction(
                                title: title, amount: val, category: category, date: date,
                                type: type)
                            dismiss()
                        }
                    }
                    .fontWeight(.bold)
                    .disabled(title.isEmpty || amount.isEmpty)
                }
            }
        }
    }
}

// MARK: - Subviews

struct TypeSelectionCard: View {
    let type: TransactionType
    let isSelected: Bool
    let color: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(
                    systemName: type == .expense
                        ? "arrow.up.right.circle.fill" : "arrow.down.left.circle.fill"
                )
                .font(.title2)
                Text(type.rawValue)
                    .font(.subheadline.bold())
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(isSelected ? color : Color.gray.opacity(0.1))
            .foregroundColor(isSelected ? .white : .primary)
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .stroke(color.opacity(isSelected ? 0 : 0.2), lineWidth: 1)
            )
        }
        .animation(.spring(), value: isSelected)
    }
}

struct CategoryGridItem: View {
    let category: TransactionCategory
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                ZStack {
                    Circle()
                        .fill(isSelected ? category.color : category.color.opacity(0.1))
                        .frame(width: 54, height: 54)

                    Image(systemName: category.icon)
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(isSelected ? .white : category.color)
                }
                Text(category.rawValue)
                    .font(.caption2.bold())
                    .foregroundColor(isSelected ? .primary : .secondary)
            }
        }
        .animation(.spring(), value: isSelected)
    }
}

struct InputFieldRow: View {
    let icon: String
    let placeholder: String
    @Binding var text: String
    var isDecimal: Bool = false

    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: icon)
                .foregroundColor(.blue)
                .frame(width: 24)
            TextField(placeholder, text: $text)
                .font(.body.bold())
                #if os(iOS)
                    .keyboardType(isDecimal ? .decimalPad : .default)
                #endif
        }
        .padding()
        .background(Color.primary.opacity(0.03))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

struct DatePickerRow: View {
    let icon: String
    @Binding var date: Date

    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: icon)
                .foregroundColor(.blue)
                .frame(width: 24)
            DatePicker("Date", selection: $date, displayedComponents: .date)
                .labelsHidden()
            Spacer()
        }
        .padding()
        .background(Color.primary.opacity(0.03))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}
