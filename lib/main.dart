import 'package:flutter/material.dart';

import 'add_stock_screen.dart';

void main() {
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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
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

final List<DataColumn> columns = const <DataColumn>[
    DataColumn(label: Text('Date')),
    DataColumn(label: Text('L. Name')),
    DataColumn(label: Text('No. Lines')),

    DataColumn(label: Text('Stock')),
  ];


final List<DataRow> rows = const <DataRow>[
    DataRow(cells: <DataCell>[
      DataCell(Text('2022-01-01')),
      DataCell(Text('John Doe')),
      DataCell(Text('10')),

      DataCell(Text('10')),
    ]),
    DataRow(cells: <DataCell>[
      DataCell(Text('2022-01-02')),
      DataCell(Text('Jane Doe')),
      DataCell(Text('15')),

      DataCell(Text('20')),
    ]),
    DataRow(cells: <DataCell>[
      DataCell(Text('2022-01-03')),
      DataCell(Text('John Smith')),
      DataCell(Text('20')),

      DataCell(Text('30')),
    ]),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        actions:  [
          PopupMenuButton(itemBuilder: (BuildContext context) {
            return <PopupMenuEntry>[
              PopupMenuItem(
                child: Text('Line'),
              ),
              PopupMenuItem(
                child: Text('Column'),
              ),
              PopupMenuItem(
                child: Text('Sell'),
              ),
            ];
          })
        ],
      ),
      body: Expanded(child: DataTable(


          columns: columns, rows: rows)),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (_)=>AddStockScreen()));
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
