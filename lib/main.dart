import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kabir_stock/models/column.dart';
import 'package:kabir_stock/models/line_model.dart';
import 'package:kabir_stock/models/sell_model.dart';
import 'package:kabir_stock/sell_form.dart';

import 'add_stock_screen.dart';
import 'firebase_services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: FirebaseOptions(
          apiKey: 'AIzaSyAAniUiAlna8vx0UBtSz8QKntLoQZQq2Pg',
          appId: '1:890134903342:web:169e199301bf876356fdbf',
          messagingSenderId: '890134903342',
          projectId: 'kabir-cement'));

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        //colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String currentView = 'Line';
  int currentColumn = 7;
  final List<DataColumn> lineColumns = const <DataColumn>[
    DataColumn(label: Text('Date')),
    DataColumn(label: Text('L. Name')),
    DataColumn(label: Text('No. Lines')),
    DataColumn(label: Text('Stock Of Patiya')),
  ];
  final List<DataColumn> columnColomn = const <DataColumn>[
    DataColumn(label: Text('Date')),
    DataColumn(label: Text('L. Name')),
    DataColumn(label: Text('Column Type')),
    DataColumn(label: Text('Stock Of Column')),
  ];
  final List<DataColumn> sellColumn = const <DataColumn>[
    DataColumn(label: Text('Date')),
    DataColumn(label: Text('To')),
    DataColumn(label: Text('Vehicle No')),
    DataColumn(label: Text('Quantity')),
    DataColumn(label: Text('Type')),
  ];

  final List<LineData> lineData = [];
  final List<ColumnData> columnData = [];
  final List<SellData> sellData = [];
  final firebaseService = FirestoreService();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    firebaseService.getLineData().then((value) {
      setState(() {
        lineData.clear();
        lineData.addAll(value);
        rows = lineData.reversed.toList().map((e) {
          return DataRow(cells: [
            DataCell(Text(DateFormat("MMMM dd, yyyy").format(e.date))),
            DataCell(Text(e.labourName)),
            DataCell(Text(e.lineNo.toString())),
            DataCell(Text(e.stockOfPatiya.toString())),
          ]);
        }).toList();
        isLoading = false;
      });
    });
  }

  List<DataRow> rows = [];
  List<int> columnType = [7, 8, 9, 10, 11, 12, 13, 14];
  @override
  Widget build(BuildContext context) {
    debugPrint("Current Column: $currentColumn");
    debugPrint("Current Column: $currentView");
    debugPrint("Current Column: $columnType");
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        actions: [
          if (currentView == 'Column')
            DropdownButton<int>(
                value: currentColumn,
                items: columnType
                    .map((e) =>
                        DropdownMenuItem(value: e, child: Text(e.toString())))
                    .toList(),
                onChanged: (value) {
                  if (value == null || value == currentColumn) return;
                  currentColumn = value;
                  changeView(currentView);
                }),
          PopupMenuButton(onSelected: (value) {
            changeView(value);
          }, itemBuilder: (BuildContext context) {
            return <PopupMenuEntry>[
              PopupMenuItem(
                value: 'Line',
                child: Text('Line'),
              ),
              PopupMenuItem(
                value: 'Column',
                child: Text('Column'),
              ),
              PopupMenuItem(
                value: 'Sell',
                child: Text('Sell'),
              ),
            ];
          })
        ],
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: DataTable(
                    headingTextStyle: const TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black),
                    border: TableBorder.all(),
                    columns: currentView == 'Line'
                        ? lineColumns
                        : currentView == 'Column'
                            ? columnColomn
                            : sellColumn,
                    rows: rows),
              ),
            ),
          ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            onPressed: () {
              Navigator.push(context,
                      MaterialPageRoute(builder: (_) => AddStockScreen()))
                  .then((value) {
                changeView(currentView);
              });
            },
            child: const Icon(Icons.add),
          ),
          SizedBox(
            height: 20,
          ),
          FloatingActionButton(
            heroTag: UniqueKey(),
            onPressed: () {
              Navigator.push(context,
                      MaterialPageRoute(builder: (_) => AddSellDataScreen()))
                  .then((value) {
                changeView(currentView);
              });
            },
            tooltip: 'Sell',
            child: const Icon(Icons.sell),
          )
        ],
      ),
    );
  }

  void changeView(String view) {
    currentView = view;
    isLoading = true;
    setState(() {});

    if (currentView == 'Column') {
      firebaseService.getColumnData(currentColumn).then((value) {
        setState(() {
          columnData.clear();
          columnData.addAll(value);
          rows = columnData.reversed.toList().map((e) {
            return DataRow(
                color: e.isSelling?MaterialStateProperty.all(Colors.red):null,
                cells: [
              DataCell(Text(DateFormat("MMMM dd, yyyy").format(e.date))),
              DataCell(Text(e.labourName)),
              DataCell(Text(e.type.toString())),
              DataCell(Text(e.stock.toString())),
            ]);
          }).toList();
          isLoading = false;
        });
      });
    } else if (currentView == 'Line') {
      firebaseService.getLineData().then((value) {
        setState(() {
          lineData.clear();
          lineData.addAll(value);
          rows = lineData.reversed.toList().map((e) {
            return DataRow(
                color: e.isSelling ? MaterialStateProperty.all(Colors.red) : null,
                cells: [
              DataCell(Text(DateFormat("MMMM dd, yyyy").format(e.date))),
              DataCell(Text(e.labourName)),
              DataCell(Text(e.lineNo.toString())),
              DataCell(Text(e.stockOfPatiya.toString())),
            ]);
          }).toList();
          isLoading = false;
        });
      });
    } else {
      firebaseService.getSellData().then((value) {
        setState(() {
          sellData.clear();
          sellData.addAll(value);
          rows = sellData.reversed.toList().map((e) {
            return DataRow(

                cells: [
              DataCell(Text(DateFormat("MMMM dd, yyyy").format(e.date))),
              DataCell(Text(e.to)),
              DataCell(Text(e.vehicleNo.toString())),
              DataCell(Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: e.sell
                    .map((e) => RichText(text: TextSpan(children: [
                  TextSpan(
                      text: e.quantity.toString(),
                      style: const TextStyle(
                          color: Colors.black, fontSize: 16)),
                  TextSpan(
                      text: ' ${e.type} ',
                      style: const TextStyle(
                          color: Colors.black, fontSize: 16)),
                  TextSpan(
                      text: '${e.columnType!=0?e.columnType:''}',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.red, fontSize: 16)),
                ])))
                    .toList(),
              )),
              DataCell(Text(e.sell
                  .map((e) => e.type.toString())
                  .reduce((value, element) => '$value $element'))),

            ]);
          }).toList();
          isLoading = false;
        });
      });
    }
  }
}
