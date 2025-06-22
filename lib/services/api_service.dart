import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:EcoEats/utils/dialog_utils.dart';

import '../providers/alternatives_provider.dart';

class ApiService {
  static Future<http.Response?> sendPostRequest(
      BuildContext context, Uri uri, Map<String, dynamic> payload) async {
    try {
      final response = await http.post(
        uri,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(payload),
      );// Close loading dialog
      return response;
    } catch (e) {
      DialogUtils.showErrorDialog(context, "Failed to send request: $e");
      return null;
    }
  }

  static Future<Map<String, List<Alternative>>?> fetchAlternatives(
      BuildContext context, List<String> items) async {
    try {
      final response = await sendPostRequest(
        context,
        Uri.parse('http://localhost:5001/suggest_alternatives'),
        {'foods': items, 'llm_guided': true},
      );

      if (response == null || response.statusCode != 200) return null;

      final data = jsonDecode(response.body) as Map<String, dynamic>;

      print(data);

      return data.map((food, alts) {
        return MapEntry(food, (alts as List).map((a) => Alternative(
          name: a['Name'],
          justification: a['Justification'],
          co2: (a['CO2'] as num).toDouble(),
          category: a['Category'],
        )).toList());
      });
    } catch (e) {
      print('Error fetching alternatives: $e');
      return null;
    }
  }

}
