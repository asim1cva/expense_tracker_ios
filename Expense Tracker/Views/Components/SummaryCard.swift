import SwiftUI

struct SummaryCard: View {
    let income: Double
    let expense: Double
    let balance: Double

    var body: some View {
        VStack(spacing: 20) {
            VStack(spacing: 4) {
                Text("Total Balance")
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.8))
                Text("$\(balance, specifier: "%.2f")")
                    .font(.system(size: 36, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
            }

            HStack(spacing: 0) {
                SummaryStatItem(
                    title: "Income", amount: income, icon: "arrow.down.circle.fill", color: .green)
                Divider().background(Color.white.opacity(0.3)).padding(.vertical, 10)
                SummaryStatItem(
                    title: "Expense", amount: expense, icon: "arrow.up.circle.fill", color: .red)
            }
        }
        .padding(24)
        .background(
            RoundedRectangle(cornerRadius: 30, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [.blue, Color(red: 0.1, green: 0.3, blue: 0.8)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
        )
        .shadow(color: .blue.opacity(0.3), radius: 15, x: 0, y: 10)
        .padding(.horizontal)
        .padding(.top, 10)
    }
}

struct SummaryStatItem: View {
    let title: String
    let amount: Double
    let icon: String
    let color: Color

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.7))
                Text("$\(amount, specifier: "%.2f")")
                    .font(.system(.body, design: .rounded).bold())
                    .foregroundColor(.white)
            }
        }
        .frame(maxWidth: .infinity)
    }
}
