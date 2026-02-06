import 'package:csv/csv.dart';
import 'package:flutter/services.dart' show rootBundle;

class FoodRepository {
  List<List<dynamic>> _data = [];

  Future<void> loadCsv() async {
    final raw = await rootBundle.loadString("assets/daily_food_nutrition_dataset.csv");
    _data = const CsvToListConverter().convert(raw, eol: "\n");
  }

  Map<String, dynamic>? findFood(String label) {
    // Matches ML Kit label to CSV data
    final query = label.toLowerCase();
    for (var row in _data.skip(1)) {
      if (row[0].toString().toLowerCase().contains(query)) {
        return {
          "name": row[0],
          "cal": row[2],
          "fat": row[5],
          "sodium": row[8],
          "chol": row[9]
        };
      }
    }
    return null;
  }
}