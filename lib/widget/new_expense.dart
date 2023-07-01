import "package:flutter/material.dart";
import "package:expense_tracker/model/expense_model.dart";

class NewExpense extends StatefulWidget {
  const NewExpense({super.key, required this.onAddExpense});

  final void Function(Expense expense) onAddExpense;
  @override
  State<NewExpense> createState() {
    return _NewExpenseState();
  }
}

class _NewExpenseState extends State<NewExpense> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime? _selectedDate;
  Category _selectcategory = Category.leisure;

  void _presentDatePicker() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 1, now.month, now.day);
    final pickeDate = await showDatePicker(
        context: context,
        initialDate: now,
        firstDate: firstDate,
        lastDate: now);

    setState(() {
      _selectedDate = pickeDate;
    });
  }

  void _submmitExpenseData() {
    final enteredAmount = double.tryParse(_amountController.text);
    final amountIsInvalid = enteredAmount == null || enteredAmount <= 0;
    if (_titleController.text.trim().isEmpty ||
        amountIsInvalid ||
        _selectedDate == null) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text("Invalid input!!!"),
          content: const Text(
              "Please make sure a valid title,amount,date and category was entered"),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(ctx);
                },
                child: const Text("Ok")),
          ],
        ),
      );
      return;
    }
    widget.onAddExpense(
      Expense(
          title: _titleController.text,
          amount: enteredAmount,
          date: _selectedDate!,
          category: _selectcategory),
    );

    Navigator.pop(context);
  }

  Widget _titleBuilder() {
    return TextField(
      controller: _titleController,
      maxLength: 50,
      decoration: const InputDecoration(
        label: Text("Title"),
      ),
    );
  }

  Widget _amountBuilder() {
    return Expanded(
      child: TextField(
        controller: _amountController,
        keyboardType: TextInputType.number,
        decoration: const InputDecoration(
          label: Text("Amount"),
          prefix: Text("₹"),
        ),
      ),
    );
  }

  Widget _datePickerBuilder() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(_selectedDate == null
            ? "No date is Selected"
            : formatter.format(_selectedDate!)),
        IconButton(
            onPressed: _presentDatePicker,
            icon: const Icon(Icons.calendar_month_outlined))
      ],
    );
  }

  Widget _dropDownBuilder() {
    return DropdownButton(
        value: _selectcategory,
        items: Category.values
            .map(
              (category) => DropdownMenuItem(
                value: category,
                child: Text(category.name.toUpperCase()),
              ),
            )
            .toList(),
        onChanged: (value) {
          if (value == null) {
            return;
          }
          setState(() {
            _selectcategory = value;
            // print(_selectcategory);
          });
        });
  }

   Widget _showModalSheetBuilder( double width){
    final softKeyboard = MediaQuery.of(context).viewInsets.bottom;

    return SingleChildScrollView(
            child: Padding(
              padding:  EdgeInsets.fromLTRB(16, 16+softKeyboard, 16, 16),
              child: Column(
                children: [
                  width < 600
                      ? _titleBuilder()
                      : Row(
                          children: [
                            Expanded(child: _titleBuilder()),
                            const SizedBox(
                              width: 15,
                            ),
                            _amountBuilder(),
                          ],
                        ),
                  Row(
                    children: [
                      width < 600
                          ? _amountBuilder()
                          : Row(
                              children: [
                                _dropDownBuilder(),
                                const SizedBox(width: 60,),
                                _datePickerBuilder(),
                              ],
                            ),
                      const SizedBox(
                        width: 24,
                      ),
                      width < 600 ? _datePickerBuilder() : const SizedBox(),
                    ],
                  ),
                  const SizedBox(height: 20),
                  width < 600
                      ? Row(
                          children: [
                            _dropDownBuilder(),
                            const Spacer(),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text("Cancel"),
                            ),
                            ElevatedButton(
                              onPressed: _submmitExpenseData,
                              child: const Text("Save Expense"),
                            ),
                          ],
                        )
                      :  SizedBox(
                       width: 500,
                        child: Row(
                          
                            children: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text("Cancel"),
                              ),
                              ElevatedButton(
                                onPressed: _submmitExpenseData,
                                child: const Text("Save Expense"),
                              ),
                            ],
                          ),
                      )
                ],
              ),
            ),
          );
     
   }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        return width <600 ? SizedBox(
          height: 320,
          child: _showModalSheetBuilder(width),
        ) : SizedBox(
          height: 500,
         width: 800,
          child:_showModalSheetBuilder(width) ,
        );
      },
    );
  }
}
