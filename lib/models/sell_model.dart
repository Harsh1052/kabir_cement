import 'package:cloud_firestore/cloud_firestore.dart';

class SellItem {
  final int columnType;
  final int quantity;
   final String type;

  SellItem({
    required this.columnType,
    required this.quantity,
    required this.type,
  });

  factory SellItem.fromFirestore(Map<String, dynamic> data) {
    return SellItem(
      columnType: data['column_type'] ?? 0,
      quantity: data['quantity'] ?? 0,
      type: data['type'] ?? '',
    );
  }

  SellItem copyWith({
    int? columnType,
    int? quantity,
    String? type,
  }) {
    return SellItem(
      columnType: columnType ?? this.columnType,
      quantity: quantity ?? this.quantity,
      type: type ?? this.type,
    );
  }



  Map<String, dynamic> toFirestore() {
    return {
      'column_type': columnType,
      'quantity': quantity,
      'type': type,
    };
  }
}

class SellData {
  final DateTime date;
  final List<SellItem> sell;
  final String to;
  final String vehicleNo;

  SellData({
    required this.date,
    required this.sell,
    required this.to,
    required this.vehicleNo,
  });

  factory SellData.fromFirestore(Map<String, dynamic> data) {
    return SellData(
      date: (data['date'] as Timestamp).toDate(),
      sell: (data['sell'] as List)
          .map((item) => SellItem.fromFirestore(item as Map<String, dynamic>))
          .toList(),
      to: data['to'] ?? '',
      vehicleNo: data['vehicle_no'] ?? '',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'date': date,
      'sell': sell.map((item) => item.toFirestore()).toList(),
      'to': to,
      'vehicle_no': vehicleNo,
    };
  }
}