import Combine
import Foundation
import SwiftData
import SwiftUI

@MainActor
class ExpenseViewModel: ObservableObject {
    private var modelContext: ModelContext
    @Published var transactions: [Transaction] = []

    // Filtering State
    @Published var selectedCategory: TransactionCategory? = nil {
        didSet { fetchTransactions() }
    }
    @Published var selectedType: TransactionType? = nil {
        didSet { fetchTransactions() }
    }

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        fetchTransactions()
    }

    func fetchTransactions() {
        var predicate: Predicate<Transaction>? = nil

        let catStr = selectedCategory?.rawValue ?? ""
        let typeStr = selectedType?.rawValue ?? ""

        if let category = selectedCategory, let type = selectedType {
            predicate = #Predicate<Transaction> {
                $0.categoryString == catStr && $0.typeString == typeStr
            }
        } else if let category = selectedCategory {
            predicate = #Predicate<Transaction> { $0.categoryString == catStr }
        } else if let type = selectedType {
            predicate = #Predicate<Transaction> { $0.typeString == typeStr }
        }

        let descriptor = FetchDescriptor<Transaction>(
            predicate: predicate,
            sortBy: [SortDescriptor(\.date, order: .reverse)]
        )

        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
            self.transactions = (try? modelContext.fetch(descriptor)) ?? []
        }
    }

    func addTransaction(
        title: String, amount: Double, category: TransactionCategory, date: Date,
        type: TransactionType
    ) {
        let newTransaction = Transaction(
            title: title, amount: amount, category: category, date: date, type: type)
        modelContext.insert(newTransaction)
        save()
        fetchTransactions()
    }

    func deleteTransactions(at offsets: IndexSet) {
        offsets.forEach { modelContext.delete(transactions[$0]) }
        save()
        fetchTransactions()
    }

    var totalIncome: Double {
        let allDescriptor = FetchDescriptor<Transaction>()
        let all = (try? modelContext.fetch(allDescriptor)) ?? []
        return all.filter { $0.type == .income }.reduce(0) { $0 + $1.amount }
    }

    var totalExpenses: Double {
        let allDescriptor = FetchDescriptor<Transaction>()
        let all = (try? modelContext.fetch(allDescriptor)) ?? []
        return all.filter { $0.type == .expense }.reduce(0) { $0 + $1.amount }
    }

    var totalBalance: Double {
        totalIncome - totalExpenses
    }

    // Insights Logic
    var categoryBreakdown: (expenses: [CategoryStat], income: [CategoryStat]) {
        let allDescriptor = FetchDescriptor<Transaction>()
        let all = (try? modelContext.fetch(allDescriptor)) ?? []

        let expenses = all.filter { $0.type == .expense }
        let income = all.filter { $0.type == .income }

        return (
            expenses: calculateStats(for: expenses),
            income: calculateStats(for: income)
        )
    }

    private func calculateStats(for items: [Transaction]) -> [CategoryStat] {
        let total = items.reduce(0) { $0 + $1.amount }
        guard total > 0 else { return [] }

        var breakdown: [TransactionCategory: Double] = [:]
        for item in items {
            breakdown[item.category, default: 0] += item.amount
        }

        return breakdown.map { (category, value) in
            CategoryStat(category: category, total: value, percentage: value / total)
        }.sorted { $0.total > $1.total }
    }

    private func save() {
        try? modelContext.save()
    }
}
