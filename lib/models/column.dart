import 'package:cloud_firestore/cloud_firestore.dart';

class ColumnData {
  final DateTime date;
  final String labourName;
  final int stock;
  final int type;

  ColumnData({
    required this.date,
    required this.labourName,
    required this.stock,
    required this.type,
  });

  // Factory constructor to create an instance from Firestore document snapshot
  factory ColumnData.fromFirestore(Map<String, dynamic> data) {
    return ColumnData(
      date: (data['date'] as Timestamp).toDate(),
      labourName: data['labour_name'] ?? '',
      stock: data['stock'] ?? 0,
      type: data['type'] ?? 0,
    );
  }

  // Method to convert an instance to a Firestore document format
  Map<String, dynamic> toFirestore() {
    return {
      'date': date,
      'labour_name': labourName,
      'stock': stock,
      'type': type,
    };
  }
}