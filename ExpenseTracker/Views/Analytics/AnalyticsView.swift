//
//  AnalyticsView.swift
//  ExpenseTracker
//

import SwiftUI
import SwiftData
import Charts

struct AnalyticsView: View {

    @Query(sort: \Expense.date, order: .reverse)
    private var expenses: [Expense]

    @Query
    private var familyMembers: [FamilyMember]

    // MARK: - State
    @State private var selectedPeriod: AnalyticsPeriod = .weekly
    @State private var selectedMember: FamilyMember? = nil // nil = entire family

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {

                // Period Picker
                Picker("Period", selection: $selectedPeriod) {
                    ForEach(AnalyticsPeriod.allCases, id: \.self) {
                        Text($0.rawValue).tag($0)
                    }
                }
                .pickerStyle(.segmented)

                // Member Picker
                memberPicker

                // Summary Cards
                summaryGrid

                // Bar Chart — Spending by Category
                barChartSection

                // Line Chart — Spending Over Time
                lineChartSection

                // Pie Chart — Category Breakdown
                pieChartSection

                Spacer(minLength: 40)
            }
            .padding()
        }
        .navigationTitle("Analytics")
    }

    // MARK: - Filtered Expenses

    var filteredExpenses: [Expense] {
        let calendar = Calendar.current
        let now = Date()

        // Filter by period
        let byPeriod: [Expense] = expenses.filter {
            switch selectedPeriod {
            case .weekly:
                return calendar.isDate($0.date, equalTo: now, toGranularity: .weekOfYear)
            case .monthly:
                return calendar.isDate($0.date, equalTo: now, toGranularity: .month)
            case .yearly:
                return calendar.isDate($0.date, equalTo: now, toGranularity: .year)
            }
        }

        // Filter by member (nil = whole family)
        if let member = selectedMember {
            return byPeriod.filter { $0.member.id == member.id }
        }
        return byPeriod
    }

    // MARK: - Summary Cards

    var totalSpent: Double { filteredExpenses.reduce(0) { $0 + $1.amount } }

    var averageExpense: Double {
        guard !filteredExpenses.isEmpty else { return 0 }
        return totalSpent / Double(filteredExpenses.count)
    }

    var topCategory: String {
        let grouped = Dictionary(grouping: filteredExpenses, by: { $0.category })
        let totals = grouped.mapValues { $0.reduce(0) { $0 + $1.amount } }
        return totals.max(by: { $0.value < $1.value })?.key.rawValue.capitalized ?? "N/A"
    }

    var highestExpense: Double {
        filteredExpenses.map { $0.amount }.max() ?? 0
    }

    var summaryGrid: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
            summaryCard(title: "Total Spent",    value: "$\(String(format: "%.2f", totalSpent))",      icon: "dollarsign.circle.fill", color: .blue)
            summaryCard(title: "# Expenses",     value: "\(filteredExpenses.count)",                    icon: "list.bullet.rectangle", color: .purple)
            summaryCard(title: "Average",        value: "$\(String(format: "%.2f", averageExpense))",   icon: "chart.bar.fill",        color: .orange)
            summaryCard(title: "Top Category",   value: topCategory,                                    icon: "star.fill",             color: .green)
        }
    }

    func summaryCard(title: String, value: String, icon: String, color: Color) -> some View {
        VStack(spacing: 6) {
            Image(systemName: icon)
                .foregroundColor(color)
                .font(.title2)
            Text(value)
                .font(.headline)
                .bold()
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(14)
    }

    // MARK: - Member Picker

    var memberPicker: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {

                // "All" chip
                Button {
                    selectedMember = nil
                } label: {
                    Text("👨‍👩‍👦 All")
                        .font(.subheadline)
                        .padding(.vertical, 8)
                        .padding(.horizontal, 14)
                        .background(selectedMember == nil ? Color.blue : Color(.systemGray5))
                        .foregroundColor(selectedMember == nil ? .white : .primary)
                        .cornerRadius(20)
                }

                ForEach(familyMembers) { member in
                    Button {
                        selectedMember = member
                    } label: {
                        Text("\(member.avatar) \(member.name)")
                            .font(.subheadline)
                            .padding(.vertical, 8)
                            .padding(.horizontal, 14)
                            .background(selectedMember?.id == member.id ? Color.blue : Color(.systemGray5))
                            .foregroundColor(selectedMember?.id == member.id ? .white : .primary)
                            .cornerRadius(20)
                    }
                }
            }
        }
    }

    // MARK: - Bar Chart (Spending by Category)

    var categoryTotals: [(category: String, amount: Double)] {
        let grouped = Dictionary(grouping: filteredExpenses, by: { $0.category.rawValue })
        return grouped
            .map { (category: $0.key.capitalized, amount: $0.value.reduce(0) { $0 + $1.amount }) }
            .sorted { $0.amount > $1.amount }
    }

    var barChartSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Spending by Category")
                .font(.headline)

            if categoryTotals.isEmpty {
                emptyState
            } else {
                Chart {
                    ForEach(categoryTotals, id: \.category) { item in
                        BarMark(
                            x: .value("Category", item.category),
                            y: .value("Amount", item.amount)
                        )
                        .foregroundStyle(Color.blue.gradient)
                        .cornerRadius(6)
                    }
                }
                .frame(height: 220)
                .chartXAxis {
                    AxisMarks(values: .automatic) { _ in
                        AxisValueLabel(orientation: .vertical)
                    }
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(16)
    }

    // MARK: - Line Chart (Spending Over Time)

    var spendingOverTime: [(date: Date, amount: Double)] {
        let calendar = Calendar.current
        let grouped = Dictionary(grouping: filteredExpenses) { expense -> Date in
            switch selectedPeriod {
            case .weekly:
                return calendar.startOfDay(for: expense.date)
            case .monthly:
                let comps = calendar.dateComponents([.year, .month, .weekOfMonth], from: expense.date)
                return calendar.date(from: comps) ?? expense.date
            case .yearly:
                let comps = calendar.dateComponents([.year, .month], from: expense.date)
                return calendar.date(from: comps) ?? expense.date
            }
        }
        return grouped
            .map { (date: $0.key, amount: $0.value.reduce(0) { $0 + $1.amount }) }
            .sorted { $0.date < $1.date }
    }

    var lineChartSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Spending Over Time")
                .font(.headline)

            if spendingOverTime.isEmpty {
                emptyState
            } else {
                Chart {
                    ForEach(spendingOverTime, id: \.date) { item in
                        LineMark(
                            x: .value("Date", item.date),
                            y: .value("Amount", item.amount)
                        )
                        .foregroundStyle(Color.green.gradient)
                        .interpolationMethod(.catmullRom)

                        AreaMark(
                            x: .value("Date", item.date),
                            y: .value("Amount", item.amount)
                        )
                        .foregroundStyle(Color.green.opacity(0.15).gradient)
                        .interpolationMethod(.catmullRom)
                    }
                }
                .frame(height: 200)
                .chartXAxis {
                    AxisMarks(values: .automatic(desiredCount: 5)) { value in
                        AxisValueLabel(format: selectedPeriod == .yearly ? .dateTime.month(.abbreviated) : .dateTime.day())
                    }
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(16)
    }

    // MARK: - Pie Chart (Category Breakdown)

    var pieChartSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Category Breakdown")
                .font(.headline)

            if categoryTotals.isEmpty {
                emptyState
            } else {
                Chart {
                    ForEach(categoryTotals, id: \.category) { item in
                        SectorMark(
                            angle: .value("Amount", item.amount),
                            innerRadius: .ratio(0.5),
                            angularInset: 2
                        )
                        .foregroundStyle(by: .value("Category", item.category))
                        .cornerRadius(4)
                    }
                }
                .frame(height: 260)
                .chartLegend(position: .bottom, alignment: .center, spacing: 12)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(16)
    }

    // MARK: - Empty State

    var emptyState: some View {
        VStack(spacing: 8) {
            Image(systemName: "chart.bar.xaxis")
                .font(.largeTitle)
                .foregroundColor(.secondary)
            Text("No expenses for this period")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 30)
    }
}

// MARK: - Period Enum

enum AnalyticsPeriod: String, CaseIterable {
    case weekly  = "Weekly"
    case monthly = "Monthly"
    case yearly  = "Yearly"
}

#Preview {
    NavigationView {
        AnalyticsView()
    }
    .modelContainer(for: [Expense.self, FamilyMember.self], inMemory: true)
}
