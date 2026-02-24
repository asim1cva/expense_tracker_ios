import SwiftUI

struct SummaryCard: View {
    let income: Double
    let expense: Double
    let balance: Double

    var body: some View {
        VStack(spacing: 24) {
            // Card Header
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Current Balance")
                        .font(.system(size: 14, weight: .semibold, design: .rounded))
                        .foregroundColor(.white.opacity(0.8))

                    Text("$\(balance, specifier: "%.2f")")
                        .font(.system(size: 42, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                }
                Spacer()

                // Tech/Glass Icon
                ZStack {
                    Circle()
                        .fill(.white.opacity(0.15))
                        .frame(width: 50, height: 50)
                    Image(systemName: "creditcard.fill")
                        .font(.title3)
                        .foregroundColor(.white)
                }
            }

            // Stats Row
            HStack(spacing: 20) {
                StatPill(
                    title: "Income",
                    amount: income,
                    icon: "arrow.down.left.circle.fill",
                    color: .green
                )

                StatPill(
                    title: "Expenses",
                    amount: expense,
                    icon: "arrow.up.right.circle.fill",
                    color: .red
                )
            }
        }
        .padding(28)
        .background {
            ZStack {
                // Base Gradient
                RoundedRectangle(cornerRadius: 32, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [
                                Color(red: 0.1, green: 0.1, blue: 0.2),
                                Color(red: 0.05, green: 0.05, blue: 0.1),
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )

                // Animated-style Mesh Overlay (Static for performance)
                Circle()
                    .fill(Color.blue.opacity(0.4))
                    .frame(width: 200, height: 200)
                    .blur(radius: 50)
                    .offset(x: -80, y: -60)

                Circle()
                    .fill(Color.purple.opacity(0.3))
                    .frame(width: 150, height: 150)
                    .blur(radius: 40)
                    .offset(x: 100, y: 70)

                // Gloss effect
                RoundedRectangle(cornerRadius: 32, style: .continuous)
                    .stroke(.white.opacity(0.2), lineWidth: 1)
                    .blendMode(.overlay)
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 32, style: .continuous))
        .shadow(color: .black.opacity(0.3), radius: 15, x: 0, y: 12)
    }
}

private struct StatPill: View {
    let title: String
    let amount: Double
    let icon: String
    let color: Color

    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(.white.opacity(0.1))
                    .frame(width: 36, height: 36)
                Image(systemName: icon)
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(color)
            }

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 11, weight: .bold))
                    .foregroundColor(.white.opacity(0.6))
                    .textCase(.uppercase)
                Text("$\(amount, specifier: "%.2f")")
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(14)
        .background(.white.opacity(0.06))
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .stroke(.white.opacity(0.1), lineWidth: 0.5)
        )
    }
}
