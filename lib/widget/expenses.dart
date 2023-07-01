import "package:flutter/material.dart";

import "package:expense_tracker/model/expense_model.dart";
import 'package:expense_tracker/widget/expenses-list/expenses_list.dart';
import "package:expense_tracker/widget/new_expense.dart";
import "package:expense_tracker/widget/chart/chart.dart";

class Expenses extends StatefulWidget {
  const Expenses({super.key});
  @override
  State<Expenses> createState() {
    return _ExpensesState();
  }
}

class _ExpensesState extends State<Expenses> {
  final List<Expense> _registeredExpense = [
    Expense(
        title: "Flutter Course",
        amount: 19.99,
        date: DateTime.now(),
        category: Category.work),
    Expense(
        title: "Cinema",
        amount: 15,
        date: DateTime.now(),
        category: Category.leisure),
  ];

  void _addNewExpense(Expense expense) {
    setState(() {
      _registeredExpense.add(expense);
    });
  }

  void _removeExpense(Expense expense) {
    final expenseIndex = _registeredExpense.indexOf(expense);
    setState(() {
      _registeredExpense.remove(expense);
    });

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      duration: const Duration(seconds: 5),
      content: const Text("Expense deleted"),
      action: SnackBarAction(
          label: "Undo",
          onPressed: () {
            setState(() {
              _registeredExpense.insert(expenseIndex, expense);
            });
          }),
    ));
  }

  void _openAddExpenseOverlay() {
    showModalBottomSheet(
      useSafeArea: true,
      isScrollControlled: true,
      context: context,
      builder: (ctx) => Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: NewExpense(onAddExpense: _addNewExpense),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    Widget mainContent = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Center(child: Text("No expense found . Start adding some")),
        const SizedBox(height: 4),
        Center(
          child: IconButton(
              onPressed: _openAddExpenseOverlay, icon: const Icon(Icons.add)),
        )
      ],
    );
    if (_registeredExpense.isNotEmpty) {
      mainContent = ExpenseList(
          expense: _registeredExpense, onRemoveExpense: _removeExpense);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Flutter Expense Tracker"),
        actions: [
          IconButton(
            onPressed: _openAddExpenseOverlay,
            icon: const Icon(Icons.add),
          )
        ],
      ),
      body: width < 600
          ? Column(
              children: [
                Chart(expenses: _registeredExpense),
                Expanded(child: mainContent),
              ],
            )
          : Row(
              children: [
                Expanded(child: Chart(expenses: _registeredExpense)),
                Expanded(child: mainContent),
              ],
            ),
    );
  }
}
