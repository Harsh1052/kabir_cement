import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'firebase_services.dart';
import 'models/sell_model.dart';

class AddSellDataScreen extends StatefulWidget {
  @override
  _AddSellDataScreenState createState() => _AddSellDataScreenState();
}

class _AddSellDataScreenState extends State<AddSellDataScreen> {
  final TextEditingController _toController = TextEditingController();
  final TextEditingController _vehicleNoController = TextEditingController();
  final List<SellItem> _sellItems = [];
  bool isLoading = false;

  DateTime _selectedDate = DateTime.now();

  // Function to add new SellItem to the list
  void _addSellItem() {
    setState(() {
      _sellItems.add(SellItem(columnType: 0, quantity: 0, type: ''));
    });
  }

  // Function to select date
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  // Function to save data to Firebase
  Future<void> _saveSellData() async {
    setState(() {
      isLoading = true;
    });
    final sellData = SellData(
      date: _selectedDate,
      sell: _sellItems,
      to: _toController.text,
      vehicleNo: _vehicleNoController.text,
    );

    if (sellData.to.isEmpty || sellData.vehicleNo.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      isLoading = false;
      setState(() {});
      return;
    }
    if (sellData.sell.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add at least one item')),
      );
      isLoading = false;
      setState(() {});
      return;
    }

    if (sellData.sell.any((element) => element.quantity == 0) ||
        sellData.sell.any((element) => element.type.isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields in sell items')),
      );
      isLoading = false;
      setState(() {});
      return;
    }

    FirestoreService()
        .addSellData(sellData)
        .then((value) => Navigator.pop(context));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Sell Data')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Date Picker
            ListTile(
              title: Text(
                  'Date: ${DateFormat('yyyy-MM-dd').format(_selectedDate)}'),
              trailing: const Icon(Icons.calendar_today),
              onTap: () => _selectDate(context),
            ),

            // Input for 'to'
            TextField(
              controller: _toController,
              decoration: const InputDecoration(labelText: 'To'),
            ),

            // Input for 'vehicleNo'
            TextField(
              controller: _vehicleNoController,
              decoration: const InputDecoration(labelText: 'Vehicle Number'),
            ),

            // List of Sell Items
            Expanded(
              child: ListView.builder(
                itemCount: _sellItems.length,
                itemBuilder: (context, index) {
                  return SellItemForm(
                    item: _sellItems[index],
                    onUpdate: (updatedItem) {
                      setState(() {
                        _sellItems[index] =
                            updatedItem; // Update the item in the list
                      });
                    },
                  );
                },
              ),
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                minimumSize: Size(double.infinity, 40),
              ),
              onPressed: _addSellItem,
              child: Text('Add Sell Item'),
            ),
            SizedBox(
              height: 15,
            ),
            // Button to save data
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                minimumSize: Size(double.infinity, 40),
              ),
              onPressed: _saveSellData,
              child: isLoading?const Center(
                child: CircularProgressIndicator(),
              ):const Text('Save Data'),
            ),
          ],
        ),
      ),
    );
  }
}

class SellItemForm extends StatefulWidget {
  final SellItem item;
  final Function(SellItem) onUpdate;

  SellItemForm({required this.item, required this.onUpdate});

  @override
  _SellItemFormState createState() => _SellItemFormState();
}

class _SellItemFormState extends State<SellItemForm> {
  late int _columnType;
  late String _type;

  @override
  void initState() {
    super.initState();
    _columnType = widget.item.columnType;
    _type = widget.item.type;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Dropdown for Column Type
            if (_type == 'Column') // Conditionally show dropdown based on type
              DropdownButton<int>(
                value: _columnType == 0 ? null : _columnType,
                items: [7, 8, 9, 10, 11, 12, 13].map((int value) {
                  return DropdownMenuItem<int>(
                    value: value,
                    child: Text(value.toString()),
                  );
                }).toList(),
                onChanged: (int? newValue) {
                  setState(() {
                    _columnType = newValue!;
                    widget.onUpdate(
                        widget.item.copyWith(columnType: _columnType));
                  });
                },
                hint: Text('Select Column Type'),
              ),

            // Quantity input
            TextField(
              decoration: InputDecoration(labelText: 'Quantity'),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                int quantity = int.parse(value);
                widget.onUpdate(widget.item.copyWith(quantity: quantity));
              },
            ),

            // Radio Buttons for Type Selection (Column or Line)
            Row(
              children: [
                Expanded(
                  child: RadioListTile<String>(
                    title: const Text('Column'),
                    value: 'Column',
                    groupValue: _type,
                    onChanged: (String? value) {
                      setState(() {
                        _type = value!;
                        widget.onUpdate(widget.item.copyWith(type: _type));
                      });
                    },
                  ),
                ),
                Expanded(
                  child: RadioListTile<String>(
                    title: const Text('Line'),
                    value: 'Line',
                    groupValue: _type,
                    onChanged: (String? value) {
                      setState(() {
                        _type = value!;
                        widget.onUpdate(widget.item.copyWith(type: _type));
                      });
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
