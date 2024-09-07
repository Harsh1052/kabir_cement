import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kabir_stock/models/line_model.dart';

import 'models/column.dart';
import 'models/sell_model.dart';


class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<List<ColumnData>> getColumnData() async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot =
      await _db.collection('column').get();

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

  Future<SellData?> getSellData(String documentId) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> doc =
      await _db.collection('your_collection_name').doc(documentId).get();

      if (doc.exists) {
        return SellData.fromFirestore(doc.data()!);
      } else {
        return null;
      }
    } catch (e) {
      print('Error getting document: $e');
      return null;
    }
  }


   // Add line data to Firestore
  Future<void> addLineData(LineData lineData) {
    return _db.collection('line').doc(DateTime.timestamp().millisecondsSinceEpoch.toString()).set(lineData.toFirestore());
  }

  // Add column data to Firestore
  Future<void> addColumnData(ColumnData columnData) {
    return _db.collection('column').doc(DateTime.timestamp().millisecondsSinceEpoch.toString()).set(columnData.toFirestore());
  }

  // Add sell data to Firestore
  Future<void> addSellData(SellData sellData) {
    return _db.collection('sell').add(sellData.toFirestore());
  }
}