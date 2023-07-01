import "package:flutter/material.dart";
import "package:expense_tracker/model/expense_model.dart";

class ExpenseItems extends StatelessWidget {
  const ExpenseItems({super.key, required this.expense});
  final Expense expense;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(expense.title ,style: Theme.of(context).textTheme.titleLarge,),
            const SizedBox(
              height: 4,
            ),
            Row(
              children: [
                Text("₹ ${expense.amount.toStringAsFixed(2)}"),
                const Spacer(),
                Row(
                  children: [
                    Icon(categoryIcons[expense.category]),
                    const SizedBox(
                      width: 8,
                    ),
                    Text(expense.formattedDate),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
