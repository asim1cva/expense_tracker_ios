import Charts
import SwiftUI
import UIKit

struct InsightsView: View {
    @ObservedObject var viewModel: ExpenseViewModel
    @State private var selectedInsightType: TransactionType = .expense
    @State private var selectedCategory: TransactionCategory? = nil

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 32) {
                    // Header Area with Time Range Placeholder
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Financial Insights")
                                    .font(.system(size: 28, weight: .bold, design: .rounded))

                                Text("Your spending analysis for this month")
                                    .font(.system(size: 15, weight: .medium))
                                    .foregroundColor(.secondary)
                            }
                            Spacer()

                            Button {
                                // Time range action
                            } label: {
                                Image(systemName: "calendar")
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundColor(.blue)
                                    .padding(12)
                                    .background(Circle().fill(Color.blue.opacity(0.1)))
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 16)

                    // Pro Type Selector
                    PremiumInsightSelector(selectedType: $selectedInsightType)
                        .padding(.horizontal)

                    let stats =
                        selectedInsightType == .expense
                        ? viewModel.categoryBreakdown.expenses : viewModel.categoryBreakdown.income

                    if stats.isEmpty {
                        ProEmptyState(type: selectedInsightType)
                    } else {
                        VStack(spacing: 40) {
                            // Featured Metric Card (Highest Spending Category)
                            if let top = stats.first {
                                TopCategoryHero(stat: top, type: selectedInsightType)
                                    .padding(.horizontal)
                            }

                            // Interactive Donut Chart
                            VStack(spacing: 20) {
                                Text("Composition")
                                    .font(.system(size: 16, weight: .bold))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.horizontal)

                                CategoryChartView(stats: stats)
                                    .padding(.horizontal)
                            }

                            // Category Breakdown List
                            VStack(alignment: .leading, spacing: 20) {
                                Text("Detailed Breakdown")
                                    .font(.system(size: 18, weight: .bold))
                                    .padding(.horizontal)

                                VStack(spacing: 16) {
                                    ForEach(stats, id: \.category) { item in
                                        ProCategoryRow(stat: item)
                                    }
                                }
                            }
                        }
                    }
                }
                .padding(.bottom, 32)
            }
            .background {
                ZStack {
                    Color(UIColor.systemGroupedBackground).ignoresSafeArea()

                    // Complex ambient glows
                    RadialGradient(
                        colors: [Color.blue.opacity(0.05), .clear], center: .topTrailing,
                        startRadius: 0, endRadius: 600)
                    RadialGradient(
                        colors: [Color.purple.opacity(0.05), .clear], center: .bottomLeading,
                        startRadius: 0, endRadius: 600)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

// MARK: - Components

struct TopCategoryHero: View {
    let stat: CategoryStat
    let type: TransactionType

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Most \(type == .expense ? "Expensive" : "Lucrative")")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(.white.opacity(0.7))
                    .textCase(.uppercase)
                Spacer()
                Image(systemName: "sparkles")
                    .foregroundColor(.yellow)
            }

            HStack(spacing: 15) {
                ZStack {
                    Circle()
                        .fill(.white.opacity(0.2))
                        .frame(width: 50, height: 50)
                    Image(systemName: stat.category.icon)
                        .font(.title2)
                        .foregroundColor(.white)
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text(stat.category.rawValue)
                        .font(.title3.bold())
                        .foregroundColor(.white)
                    Text(
                        "Consumes \(Int(stat.percentage * 100))% of total \(type.rawValue.lowercased())"
                    )
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.8))
                }
            }

            Text("$\(stat.total, specifier: "%.2f")")
                .font(.system(size: 34, weight: .bold, design: .rounded))
                .foregroundColor(.white)
        }
        .padding(24)
        .background {
            ZStack {
                RoundedRectangle(cornerRadius: 28, style: .continuous)
                    .fill(stat.category.color.gradient)

                // Texture
                Image(systemName: "waveform.path")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 100)
                    .opacity(0.1)
                    .offset(x: 100, y: 40)
            }
        }
        .shadow(color: stat.category.color.opacity(0.3), radius: 15, x: 0, y: 10)
    }
}

struct ProCategoryRow: View {
    let stat: CategoryStat

    var body: some View {
        HStack(spacing: 16) {
            // High-def icon
            ZStack {
                Circle()
                    .fill(stat.category.color.opacity(0.1))
                    .frame(width: 48, height: 48)

                Image(systemName: stat.category.icon)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(stat.category.color)
            }

            VStack(alignment: .leading, spacing: 6) {
                Text(stat.category.rawValue)
                    .font(.system(size: 16, weight: .bold))

                // Sleek progress indicator
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(Color.primary.opacity(0.04))
                        .frame(height: 6)

                    Capsule()
                        .fill(stat.category.color.gradient)
                        .frame(width: 120 * CGFloat(stat.percentage), height: 6)  // Scale based on container width later
                        .shadow(color: stat.category.color.opacity(0.2), radius: 3)
                }
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 4) {
                Text("$\(stat.total, specifier: "%.2f")")
                    .font(.system(size: 16, weight: .bold, design: .rounded))

                Text("\(Int(stat.percentage * 100))%")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.secondary)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 2)
                    .background(Color.secondary.opacity(0.08))
                    .clipShape(Capsule())
            }
        }
        .padding(14)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .padding(.horizontal)
    }
}

struct CategoryChartView: View {
    let stats: [CategoryStat]

    var body: some View {
        VStack(spacing: 24) {
            // Visual Peak Indicator
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Distribution")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.secondary)
                        .textCase(.uppercase)

                    Text("Volume by Category")
                        .font(.system(size: 20, weight: .bold))
                }
                Spacer()

                // Total Badge
                VStack(alignment: .trailing, spacing: 2) {
                    Text("Total")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(.secondary)
                    Text("$\(stats.reduce(0) { $0 + $1.total }, specifier: "%.2f")")
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                        .foregroundColor(.blue)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(Color.blue.opacity(0.08))
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            }

            // Pro Horizontal Comparison Chart
            Chart {
                ForEach(stats) { item in
                    BarMark(
                        x: .value("Amount", item.total),
                        y: .value("Category", item.category.rawValue),
                        width: .fixed(12)
                    )
                    .foregroundStyle(item.category.color.gradient)
                    .cornerRadius(6)

                    .annotation(position: .trailing, alignment: .trailing) {
                        Text("\(Int(item.percentage * 100))%")
                            .font(.system(size: 10, weight: .bold, design: .rounded))
                            .foregroundColor(.secondary)
                            .padding(.leading, 8)
                    }
                }
            }
            .frame(height: CGFloat(stats.count * 45))  // Dynamic height based on categories
            .chartXAxis {
                AxisMarks(values: .automatic) { _ in
                    AxisGridLine(stroke: StrokeStyle(lineWidth: 0.5, dash: [2, 4]))
                        .foregroundStyle(.secondary.opacity(0.2))
                    AxisValueLabel()
                        .font(.system(size: 10))
                        .foregroundStyle(.secondary)
                }
            }
            .chartYAxis {
                AxisMarks(values: .automatic) { value in
                    AxisValueLabel {
                        if let category = value.as(String.self) {
                            Text(category)
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundColor(.primary.opacity(0.8))
                        }
                    }
                }
            }
        }
        .padding(26)
        .background {
            ZStack {
                RoundedRectangle(cornerRadius: 32, style: .continuous)
                    .fill(Color(.secondarySystemGroupedBackground))

                // Technical Grid Pattern
                GeometryReader { geo in
                    Path { path in
                        let step: CGFloat = 30
                        for x in stride(from: 0, to: geo.size.width, by: step) {
                            path.move(to: CGPoint(x: x, y: 0))
                            path.addLine(to: CGPoint(x: x, y: geo.size.height))
                        }
                    }
                    .stroke(Color.primary.opacity(0.02), lineWidth: 1)
                }
            }
        }
        .overlay(
            RoundedRectangle(cornerRadius: 32, style: .continuous)
                .stroke(.white.opacity(0.15), lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.04), radius: 20, x: 0, y: 10)
    }
}

struct ProEmptyState: View {
    let type: TransactionType

    var body: some View {
        VStack(spacing: 24) {
            ZStack {
                Circle()
                    .fill(.blue.opacity(0.05))
                    .frame(width: 120, height: 120)
                Image(systemName: "chart.pie.fill")
                    .font(.system(size: 50))
                    .foregroundStyle(.blue.gradient)
            }

            VStack(spacing: 8) {
                Text("No data to visualize")
                    .font(.title3.bold())
                Text(
                    "Start adding \(type.rawValue.lowercased()) items to see your financial patterns."
                )
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            }
            .padding(.horizontal, 40)
        }
        .padding(.top, 100)
    }
}
