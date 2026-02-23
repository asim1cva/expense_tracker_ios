import Foundation
import SwiftData
import SwiftUI

enum TransactionType: String, CaseIterable, Codable {
    case expense = "Expense"
    case income = "Income"

    var icon: String {
        switch self {
        case .expense: return "arrow.up.circle.fill"
        case .income: return "arrow.down.circle.fill"
        }
    }

    var color: Color {
        switch self {
        case .expense: return .red
        case .income: return .green
        }
    }
}

enum TransactionCategory: String, CaseIterable, Codable, Identifiable {
    case food = "Food"
    case transport = "Transport"
    case entertainment = "Entertainment"
    case shopping = "Shopping"
    case bills = "Bills"
    case salary = "Salary"
    case investment = "Investment"
    case gift = "Gift"
    case other = "Other"

    var id: String { self.rawValue }

    var icon: String {
        switch self {
        case .food: return "fork.knife"
        case .transport: return "car.fill"
        case .entertainment: return "film.fill"
        case .shopping: return "cart.fill"
        case .bills: return "doc.text.fill"
        case .salary: return "banknote.fill"
        case .investment: return "chart.line.uptrend.xyaxis"
        case .gift: return "gift.fill"
        case .other: return "ellipsis.circle.fill"
        }
    }

    var color: Color {
        switch self {
        case .food: return .orange
        case .transport: return .blue
        case .entertainment: return .purple
        case .shopping: return .pink
        case .bills: return .red
        case .salary: return .green
        case .investment: return .teal
        case .gift: return .yellow
        case .other: return .gray
        }
    }
}

@Model
final class Transaction {
    var id: UUID
    var title: String
    var amount: Double
    var categoryString: String
    var date: Date
    var typeString: String

    var category: TransactionCategory {
        get { TransactionCategory(rawValue: categoryString) ?? .other }
        set { categoryString = newValue.rawValue }
    }

    var type: TransactionType {
        get { TransactionType(rawValue: typeString) ?? .expense }
        set { typeString = newValue.rawValue }
    }

    init(
        title: String, amount: Double, category: TransactionCategory, date: Date,
        type: TransactionType = .expense
    ) {
        self.id = UUID()
        self.title = title
        self.amount = amount
        self.categoryString = category.rawValue
        self.date = date
        self.typeString = type.rawValue
    }
}

struct CategoryStat: Identifiable {
    var id: String { category.rawValue }
    let category: TransactionCategory
    let total: Double
    let percentage: Double
}
