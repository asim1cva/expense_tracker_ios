import Combine
import SwiftData
import SwiftUI

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @StateObject private var viewModel: ViewModelProxy = ViewModelProxy()

    var body: some View {
        Group {
            if let vm = viewModel.instance {
                TabView {
                    HomeView(viewModel: vm)
                        .tabItem {
                            Label("History", systemImage: "list.bullet.rectangle.fill")
                        }

                    InsightsView(viewModel: vm)
                        .tabItem {
                            Label("Insights", systemImage: "chart.pie.fill")
                        }
                }
            } else {
                ProgressView("Initializing...")
                    .onAppear {
                        if viewModel.instance == nil {
                            viewModel.instance = ExpenseViewModel(modelContext: modelContext)
                        }
                    }
            }
        }
    }
}

// MARK: - Proxy Helper
class ViewModelProxy: ObservableObject {
    @Published var instance: ExpenseViewModel?
    init() { self.instance = nil }
}
