import SwiftUI
import UIKit

struct InsightsView: View {
    @ObservedObject var viewModel: ExpenseViewModel
    @State private var selectedInsightType: TransactionType = .expense

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Premium Custom Selector
                    PremiumInsightSelector(selectedType: $selectedInsightType)
                        .padding(.top)

                    let stats =
                        selectedInsightType == .expense
                        ? viewModel.categoryBreakdown.expenses : viewModel.categoryBreakdown.income

                    if stats.isEmpty {
                        VStack(spacing: 12) {
                            Image(systemName: "chart.pie.fill")
                                .font(.system(size: 60))
                                .foregroundColor(.gray.opacity(0.2))
                            Text("No data for \(selectedInsightType.rawValue.lowercased())")
                                .foregroundColor(.secondary)
                        }
                        .padding(.top, 100)
                    } else {
                        ForEach(stats, id: \.category) { item in
                            CategoryStatRow(stat: item)
                        }
                    }
                }
                .padding(.vertical)
            }
            .background {
                ZStack {
                    Color(UIColor.systemGroupedBackground)
                    Circle()
                        .fill(Color.purple.opacity(0.1))
                        .blur(radius: 80)
                        .offset(x: -100, y: -150)
                    Circle()
                        .fill(Color.blue.opacity(0.1))
                        .blur(radius: 80)
                        .offset(x: 100, y: 200)
                }
                .ignoresSafeArea()
            }
            .navigationTitle("Insights")
        }
    }
}

struct CategoryStatRow: View {
    let stat: CategoryStat

    var body: some View {
        HStack(spacing: 16) {
            // Icon with soft background
            ZStack {
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(stat.category.color.opacity(0.15))
                    .frame(width: 50, height: 50)

                Image(systemName: stat.category.icon)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(stat.category.color)
            }

            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(stat.category.rawValue)
                        .font(.subheadline.bold())
                    Spacer()
                    Text("$\(stat.total, specifier: "%.2f")")
                        .font(.subheadline.bold())
                }

                // Styled Progress Bar
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        Capsule()
                            .fill(Color.primary.opacity(0.05))
                            .frame(height: 7)

                        LinearGradient(
                            colors: [stat.category.color, stat.category.color.opacity(0.7)],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                        .frame(width: geometry.size.width * CGFloat(stat.percentage), height: 7)
                        .clipShape(Capsule())
                    }
                }
                .frame(height: 7)

                HStack {
                    Text("\(Int(stat.percentage * 100))% of total")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                    Spacer()
                }
            }
        }
        .padding(16)
        .background(.thinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .stroke(.white.opacity(0.15), lineWidth: 1)
        )
        .padding(.horizontal)
    }
}
