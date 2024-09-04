import 'package:flutter/material.dart';

class AddStockScreen extends StatefulWidget {
   AddStockScreen({super.key});

  @override
  State<AddStockScreen> createState() => _AddStockScreenState();
}

class _AddStockScreenState extends State<AddStockScreen> {
  final TextEditingController dateController = TextEditingController();

  final TextEditingController labourNameController = TextEditingController();

  final TextEditingController lineController = TextEditingController();

  final List<int> lines = [7, 8, 9, 10, 11, 12, 13];

   final ValueNotifier<String> selectedType = ValueNotifier<String>('Line');

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
                  onTap: () async{
                    final value = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2025),
                    );
                    if(value !=null){
                      dateController.text = '${value.year}-${value.month}-${value.day}';
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
                if(selectedType.value=='Line')
                  TextField(
                  decoration: InputDecoration(
                    labelText: 'Line',
                  ),
                )else
                DropdownButton<int>(
                  hint: const Text('Select Column Size'),
                  isExpanded: true,
                  value: lineController.text.isEmpty ? null : int.parse(lineController.text),
                  items:  <DropdownMenuItem<int>>[
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
                    setState(() {

                    });
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
            minimumSize: MaterialStateProperty.all<Size>(const Size(double.maxFinite, 50)
            ),),
                  onPressed: () {},
                  child: const Text('Submit'),
                ),
              ],
            );
          }, valueListenable: selectedType,
        ),
      )
    );
  }
}
