import 'package:flutter/material.dart';
import 'package:kabir_stock/models/column.dart';
import 'package:kabir_stock/models/line_model.dart';

import 'firebase_services.dart';

class AddStockScreen extends StatefulWidget {
  AddStockScreen({super.key});

  @override
  State<AddStockScreen> createState() => _AddStockScreenState();
}

class _AddStockScreenState extends State<AddStockScreen> {
  final TextEditingController dateController = TextEditingController();

  final TextEditingController labourNameController = TextEditingController();

  final TextEditingController lineController = TextEditingController();
  final TextEditingController columnQuantity = TextEditingController();

  final List<int> lines = [7, 8, 9, 10, 11, 12, 13];

  final ValueNotifier<String> selectedType = ValueNotifier<String>('Line');
  final FirestoreService firebaseService = FirestoreService();
  DateTime? selectedDate;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Add Stock'),
        ),
        // Text Field for Date
        // Text Field for Labour Name
        // Radio Button: Coloum and Line
        // if select line show only Text Field for Line
        // show dropdown using [7,8,9,10,11,12,13],
        // Submit button
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ValueListenableBuilder<String>(
            builder: (context, value, child) {
              return Column(
                children: [
                  TextField(
                    controller: dateController,
                    onTap: () async {
                      final value = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2025),
                      );
                      if (value != null) {
                        dateController.text =
                            '${value.year}- ${value.month.toStringAsFixed(2)} ${value.day.toStringAsFixed(2)}';
                        selectedDate = value;
                      }
                    },
                    decoration: InputDecoration(
                      labelText: 'Date',
                    ),
                  ),
                  TextField(
                    controller: labourNameController,
                    decoration: InputDecoration(
                      labelText: 'Labour Name',
                    ),
                  ),
                  Row(
                    children: [
                      Radio(
                        value: 'Column',
                        groupValue: value,
                        onChanged: (value) {
                          selectedType.value = value!;
                        },
                      ),
                      Text('Column'),
                      Radio(
                        value: 'Line',
                        groupValue: value,
                        onChanged: (value) {
                          selectedType.value = value!;
                        },
                      ),
                      Text('Line'),
                    ],
                  ),
                  if (selectedType.value == 'Column')
                    DropdownButton<int>(
                      hint: const Text('Select Column Size'),
                      isExpanded: true,
                      value: lineController.text.isEmpty
                          ? null
                          : int.parse(lineController.text),
                      items: <DropdownMenuItem<int>>[
                        DropdownMenuItem<int>(
                          value: 7,
                          child: Text('7'),
                        ),
                        DropdownMenuItem<int>(
                          value: 8,
                          child: Text('8'),
                        ),
                        DropdownMenuItem<int>(
                          value: 9,
                          child: Text('9'),
                        ),
                        DropdownMenuItem<int>(
                          value: 10,
                          child: Text('10'),
                        ),
                        DropdownMenuItem<int>(
                          value: 11,
                          child: Text('11'),
                        ),
                        DropdownMenuItem<int>(
                          value: 12,
                          child: Text('12'),
                        ),
                        DropdownMenuItem<int>(
                          value: 13,
                          child: Text('13'),
                        ),
                      ],
                      onChanged: (value) {
                        lineController.text = value.toString();
                        setState(() {});
                      },
                    ),
                  TextField(
                    controller: selectedType.value == 'Column'
                        ? columnQuantity
                        : lineController,
                    decoration: InputDecoration(
                      labelText:
                          selectedType.value == 'Line' ? 'Line' : 'Column',
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.blue),
                      minimumSize: MaterialStateProperty.all<Size>(
                          const Size(double.maxFinite, 50)),
                    ),
                    onPressed: () async {
                      if (selectedDate == null || labourNameController.text.isEmpty || lineController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Please fill all the fields'),
                          ),
                        );
                        return;
                      }
                      isLoading = true;
                      setState(() {

                      });

                      if (selectedType.value == 'Line') {
                        int currentStock = await getLastStockOfPatiya();

                        await firebaseService.addLineData(LineData(
                          docId: DateTime.timestamp().millisecondsSinceEpoch.toString(),
                          date: selectedDate!,
                          labourName: labourNameController.text,
                          lineNo: int.parse(lineController.text),
                          stockOfPatiya: (currentStock +
                              (int.parse(lineController.text)) * 30),
                        ));
                      } else {
                        int lastStock = await getLastStockOfColumn(
                            int.parse(lineController.text));
                        await firebaseService.addColumnData(ColumnData(
                          docId: DateTime.timestamp().millisecondsSinceEpoch.toString(),
                          date: selectedDate!,
                          labourName: labourNameController.text,
                          type: int.parse(lineController.text),
                          stock: lastStock + int.parse(columnQuantity.text),
                        ));
                      }
                      Navigator.pop(context,true);
                    },
                    child: isLoading
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : const Text('Submit'),
                  ),
                ],
              );
            },
            valueListenable: selectedType,
          ),
        ));
  }

  // get last stock of patiya
  Future<int> getLastStockOfPatiya() async {
    final lineData = await firebaseService.getLineData();
    if(lineData.isEmpty){
      return 0;
    }
    final lastStock = lineData.last.stockOfPatiya;
    return lastStock;
  }

// get last stock of column
  Future<int> getLastStockOfColumn(int type) async {
    final columnData = await firebaseService.getColumnData(type);
    if(columnData.isEmpty){
      return 0;
    }
    final lastStock = columnData.last.stock;
    return lastStock;
  }
}
