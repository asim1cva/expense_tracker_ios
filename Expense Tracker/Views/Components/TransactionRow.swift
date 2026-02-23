import SwiftUI

struct TransactionRow: View {
    let transaction: Transaction

    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(transaction.category.color.opacity(0.12))
                    .frame(width: 48, height: 48)
                Image(systemName: transaction.category.icon)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(transaction.category.color)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(transaction.title)
                    .font(.headline)
                    .foregroundColor(.primary)
                Text(transaction.date.formatted(date: .abbreviated, time: .omitted))
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 4) {
                Text(
                    "\(transaction.type == .income ? "+" : "-")$\(transaction.amount, specifier: "%.2f")"
                )
                .font(.system(.body, design: .rounded).bold())
                .foregroundColor(transaction.type == .income ? .green : .primary)

                Text(transaction.type.rawValue)
                    .font(.system(size: 10, weight: .bold))
                    .padding(.horizontal, 8)
                    .padding(.vertical, 2)
                    .background(transaction.type.color.opacity(0.1))
                    .foregroundColor(transaction.type.color)
                    .clipShape(Capsule())
            }
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 16)
        .background(.thinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .stroke(.white.opacity(0.12), lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.02), radius: 5, x: 0, y: 2)
    }
}
