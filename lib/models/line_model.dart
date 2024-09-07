import 'package:cloud_firestore/cloud_firestore.dart';

class LineData {
  final DateTime date;
  final String labourName;
  final int stockOfPatiya;
  final int lineNo;


  LineData({
    required this.date,
    required this.labourName,
    required this.lineNo,
    required this.stockOfPatiya,

  });

  // Factory constructor to create an instance from Firestore document snapshot
  factory LineData.fromFirestore(Map<String, dynamic> data) {
    return LineData(
      date: (data['date'] as Timestamp).toDate(),
      labourName: data['labour_name'] ?? '',
      stockOfPatiya: data['current_stock_patiya'] ?? 0,
      lineNo: data['line'] ?? 0,
    );
  }

  // Method to convert an instance to a Firestore document format
  Map<String, dynamic> toFirestore() {
    return {
      'date': date,
      'labour_name': labourName,
      'current_stock_patiya': stockOfPatiya,
      'line': lineNo,
    };
  }
}