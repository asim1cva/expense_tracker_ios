import SwiftUI

struct TransactionTypeFilter: View {
    @Binding var selectedType: TransactionType?
    @Namespace private var animation

    var body: some View {
        HStack(spacing: 0) {
            FilterItem(
                title: "All",
                icon: "square.grid.2x2.fill",
                isSelected: selectedType == nil,
                animation: animation
            ) {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                    selectedType = nil
                }
            }

            ForEach(TransactionType.allCases, id: \.self) { type in
                FilterItem(
                    title: type.rawValue,
                    icon: type.icon,
                    isSelected: selectedType == type,
                    animation: animation,
                    activeColor: type.color
                ) {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        selectedType = type
                    }
                }
            }
        }
        .padding(4)
        .background(Color.primary.opacity(0.05))
        .background(.ultraThinMaterial)
        .clipShape(Capsule())
        .overlay(
            Capsule()
                .stroke(.white.opacity(0.1), lineWidth: 1)
        )
    }
}

private struct FilterItem: View {
    let title: String
    let icon: String
    let isSelected: Bool
    var animation: Namespace.ID
    var activeColor: Color = .blue
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.system(size: 14, weight: .bold))
                Text(title)
                    .font(.subheadline.bold())
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .contentShape(Rectangle())
            .foregroundColor(isSelected ? .white : .primary.opacity(0.5))
            .background {
                if isSelected {
                    Capsule()
                        .fill(activeColor)
                        .matchedGeometryEffect(id: "ACTIVETAB", in: animation)
                        .shadow(color: activeColor.opacity(0.3), radius: 8, x: 0, y: 4)
                }
            }
        }
        .buttonStyle(.plain)
    }
}

struct PremiumInsightSelector: View {
    @Binding var selectedType: TransactionType
    @Namespace private var animation

    var body: some View {
        HStack(spacing: 12) {
            ForEach(TransactionType.allCases, id: \.self) { type in
                Button {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        selectedType = type
                    }
                } label: {
                    VStack(spacing: 8) {
                        Text(type.rawValue + "s")
                            .font(.subheadline.bold())

                        if selectedType == type {
                            Capsule()
                                .fill(type.color)
                                .frame(height: 3)
                                .matchedGeometryEffect(id: "UNDERLINE", in: animation)
                        } else {
                            Capsule()
                                .fill(Color.clear)
                                .frame(height: 3)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.top, 8)
                    .contentShape(Rectangle())
                    .foregroundColor(selectedType == type ? .primary : .secondary)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal)
    }
}

struct CategoryCircleFilter: View {
    let title: String
    let icon: String
    let color: Color
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 10) {
                ZStack {
                    Circle()
                        .fill(isSelected ? color : color.opacity(0.08))
                        .frame(width: 58, height: 58)

                    Image(systemName: icon)
                        .font(.system(size: 22, weight: .semibold))
                        .foregroundColor(isSelected ? .white : color)
                }
                .overlay(
                    Circle()
                        .stroke(color.opacity(isSelected ? 0.3 : 0), lineWidth: 2)
                        .scaleEffect(isSelected ? 1.1 : 1.0)
                )

                Text(title)
                    .font(.caption.bold())
                    .foregroundColor(isSelected ? .primary : .secondary)
            }
            .contentShape(Circle())
        }
        .buttonStyle(.plain)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
    }
}
