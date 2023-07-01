import "package:flutter/material.dart";

import "package:expense_tracker/model/expense_model.dart";
import "package:expense_tracker/widget/expenses-list/expense_items.dart";

class ExpenseList extends StatelessWidget {
  const ExpenseList(
      {super.key, required this.expense, required this.onRemoveExpense});
  final List<Expense> expense;
  final void Function(Expense expense) onRemoveExpense;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: expense.length,
      itemBuilder: ((context, index) => Dismissible(
            key: ValueKey(expense[index]),
            background: Container(
              color: Theme.of(context).colorScheme.error.withOpacity(0.75),
              margin: EdgeInsets.symmetric(horizontal: Theme.of(context).cardTheme.margin!.horizontal),
            ),
            onDismissed: (direction) {
              onRemoveExpense(expense[index]);
            },
            child: ExpenseItems(expense: expense[index]),
          )),
    );
  }
}
