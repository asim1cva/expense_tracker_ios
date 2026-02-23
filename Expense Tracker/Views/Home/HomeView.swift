import SwiftUI
import UIKit

struct HomeView: View {
    @ObservedObject var viewModel: ExpenseViewModel
    @State private var showingAddTransaction = false
    @State private var searchText = ""

    var body: some View {
        NavigationStack {
            List {
                // Header Group (Summary + Filters)
                Group {
                    SummaryCard(
                        income: viewModel.totalIncome,
                        expense: viewModel.totalExpenses,
                        balance: viewModel.totalBalance
                    )
                    .padding(.top, 8)

                    VStack(spacing: 16) {
                        TransactionTypeFilter(selectedType: $viewModel.selectedType)

                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 18) {
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
                    .padding(.top, 8)
                }
                .padding(.horizontal)
                .listRowSeparator(.hidden)
                .listRowInsets(EdgeInsets())
                .listRowBackground(Color.clear)

                // Transactions List
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
                                    EdgeInsets(top: 6, leading: 16, bottom: 6, trailing: 16)
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
                    Text("Recent Activity")
                        .font(.subheadline.bold())
                        .foregroundColor(.secondary)
                        .textCase(nil)
                        .padding(.horizontal)
                        .padding(.top, 16)
                        .padding(.bottom, 8)
                }
                .listRowInsets(EdgeInsets())
                .listRowBackground(Color.clear)
            }
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
//            .searchable(text: $searchText, prompt: "Search transactions...")
            .background {
                ZStack {
                    Color(UIColor.systemGroupedBackground)
                    Circle()
                        .fill(Color.blue.opacity(0.12))
                        .blur(radius: 80)
                        .offset(x: -120, y: -200)
                    Circle()
                        .fill(Color.purple.opacity(0.1))
                        .blur(radius: 80)
                        .offset(x: 120, y: 200)
                }
                .ignoresSafeArea()
            }
            .navigationTitle("Finances")
            .toolbar {
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
