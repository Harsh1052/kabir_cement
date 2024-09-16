import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kabir_stock/models/line_model.dart';

import 'models/column.dart';
import 'models/sell_model.dart';


class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<List<ColumnData>> getColumnData(int columnType) async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot =
      await _db.collection('column').where("type",isEqualTo: columnType).get();

      return snapshot.docs.map((doc) => ColumnData.fromFirestore(doc.data())).toList();
    } catch (e) {
      print('Error getting documents: $e');
      return [];
    }
  }

  Future<List<LineData>> getLineData() async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot =
      await _db.collection('line').get();

      return snapshot.docs.map((doc) => LineData.fromFirestore(doc.data())).toList();
    } catch (e) {
      print('Error getting documents: $e');
      return [];
    }
  }

  Future<List<SellData>> getSellData() async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot =
      await _db.collection('sell').get();

      return snapshot.docs.map((doc) => SellData.fromFirestore(doc.data())).toList();

    } catch (e) {
      print('Error getting document: $e');
      return [];
    }
  }


   // Add line data to Firestor
  Future<void> addLineData(LineData lineData) {
    return _db.collection('line').doc(lineData.docId).set(lineData.toFirestore());
  }

  // Add column data to Firestore
  Future<void> addColumnData(ColumnData columnData) {
    return _db.collection('column').doc(columnData.docId).set(columnData.toFirestore());
  }

  // Add sell data to Firestore
  Future<void> addSellData(SellData sellData) {
    return _db.collection('sell').doc(sellData.docId??DateTime.timestamp().millisecondsSinceEpoch.toString()).set(sellData.toFirestore());
  }
}