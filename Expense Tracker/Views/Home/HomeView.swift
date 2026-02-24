import SwiftUI
import UIKit

struct HomeView: View {
    @ObservedObject var viewModel: ExpenseViewModel
    @State private var showingAddTransaction = false
    @State private var searchText = ""

    var body: some View {
        NavigationStack {
            List {
                // Pro Header & Greeting
                Group {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Welcome Back,")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.secondary)
                        Text("Your Portfolio")
                            .font(.system(size: 28, weight: .bold))
                    }
                    .padding(.top, 12)

                    SummaryCard(
                        income: viewModel.totalIncome,
                        expense: viewModel.totalExpenses,
                        balance: viewModel.totalBalance
                    )
                    .padding(.top, 10)

                    VStack(spacing: 20) {
                        TransactionTypeFilter(selectedType: $viewModel.selectedType)

                        VStack(alignment: .leading, spacing: 12) {
                            Text("Categories")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(.secondary)
                                .textCase(.uppercase)
                                .padding(.horizontal, 4)

                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 20) {
                                    CategoryCircleFilter(
                                        title: "All",
                                        icon: "slider.horizontal.3",
                                        color: .blue,
                                        isSelected: viewModel.selectedCategory == nil
                                    ) {
                                        viewModel.selectedCategory = nil
                                    }

                                    ForEach(TransactionCategory.allCases) { category in
                                        CategoryCircleFilter(
                                            title: category.rawValue,
                                            icon: category.icon,
                                            color: category.color,
                                            isSelected: viewModel.selectedCategory == category
                                        ) {
                                            viewModel.selectedCategory = category
                                        }
                                    }
                                }
                                .padding(.vertical, 4)
                            }
                        }
                    }
                    .padding(.top, 24)
                }
                .padding(.horizontal)
                .listRowSeparator(.hidden)
                .listRowInsets(EdgeInsets())
                .listRowBackground(Color.clear)

                // Transactions List Section
                Section {
                    let filteredTransactions = viewModel.transactions.filter {
                        searchText.isEmpty || $0.title.localizedCaseInsensitiveContains(searchText)
                    }

                    if filteredTransactions.isEmpty {
                        EmptyStateView()
                            .padding(.top, 60)
                            .listRowBackground(Color.clear)
                    } else {
                        ForEach(filteredTransactions) { transaction in
                            TransactionRow(transaction: transaction)
                                .listRowInsets(
                                    EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16)
                                )
                                .listRowBackground(Color.clear)
                                .listRowSeparator(.hidden)
                        }
                        .onDelete { offsets in
                            offsets.forEach { index in
                                let transaction = filteredTransactions[index]
                                if let actualIndex = viewModel.transactions.firstIndex(where: {
                                    $0.id == transaction.id
                                }) {
                                    viewModel.deleteTransactions(at: IndexSet(integer: actualIndex))
                                }
                            }
                        }
                    }
                } header: {
                    HStack {
                        Text("Transactions")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.primary)
                        Spacer()
                        Button("View All") {
                            // Action for viewing all
                        }
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.blue)
                    }
                    .textCase(nil)
                    .padding(.horizontal)
                    .padding(.top, 32)
                    .padding(.bottom, 12)
                }
                .listRowInsets(EdgeInsets())
                .listRowBackground(Color.clear)
            }
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
            .searchable(text: $searchText, prompt: "Search history...")
            .background {
                ZStack {
                    Color(UIColor.systemGroupedBackground)

                    // Ultra-soft mesh background
                    RadialGradient(
                        colors: [Color.blue.opacity(0.1), .clear], center: .topLeading,
                        startRadius: 0, endRadius: 500
                    )
                    .ignoresSafeArea()

                    RadialGradient(
                        colors: [Color.purple.opacity(0.08), .clear], center: .bottomTrailing,
                        startRadius: 0, endRadius: 600
                    )
                    .ignoresSafeArea()
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Image(systemName: "person.crop.circle.fill")
                        .symbolRenderingMode(.hierarchical)
                        .foregroundColor(.secondary)
                        .font(.title3)
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingAddTransaction = true
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .symbolRenderingMode(.hierarchical)
                            .font(.title2)
                            .foregroundColor(.blue)
                    }
                }
            }
            .sheet(isPresented: $showingAddTransaction) {
                AddTransactionView(viewModel: viewModel)
            }
        }
    }
}
