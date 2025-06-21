import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:EcoEats/utils/dialog_utils.dart';

class ApiService {
  static Future<http.Response?> sendPostRequest(
      BuildContext context, Uri uri, Map<String, dynamic> payload) async {
    try {
      DialogUtils.showLoadingDialog(context);
      final response = await http.post(
        uri,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(payload),
      );
      Navigator.of(context).pop(); // Close loading dialog
      return response;
    } catch (e) {
      Navigator.of(context).pop();
      DialogUtils.showErrorDialog(context, "Failed to send request: $e");
      return null;
    }
  }
}
