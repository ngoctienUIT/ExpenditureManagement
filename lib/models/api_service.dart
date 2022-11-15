import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class APIService {
  //baseUrl = "https://api.exchangerate.host/latest";
  //https://exchangerate.host/#/

  static Map<String, dynamic> parseExchangeRate(String responseBody) {
    var data = json.decode(responseBody) as Map<String, dynamic>;
    return data["rates"];
  }

  Future<Map<String, dynamic>> getExchangeRate() async {
    try {
      var url = Uri.https('api.exchangerate.host', '/latest', {'q': '{https}'});
      final response = await http.get(url);
      if (response.statusCode == 200) {
        return compute(parseExchangeRate, response.body);
      } else {
        throw Exception('Failed to load json data');
      }
    } catch (_) {}
    return {};
  }

  static List<Map<String, dynamic>> parseCountry(String responseBody) {
    var data = json.decode(responseBody) as Map<String, dynamic>;
    List<Map<String, dynamic>> list =
        (data["countries"]["country"] as List<dynamic>)
            .map((e) => e as Map<String, dynamic>)
            .toList();
    return list;
  }

  Future<List<Map<String, dynamic>>> getCountry() async {
    try {
      var url = Uri.https(
        'gist.githubusercontent.com',
        '/ngoctienUIT/e81b1119d12c6dadfa3b7902a80e0928/raw/f621703926fc13be4f618fb4a058d0454177cceb/countries.json',
        {'q': '{https}'},
      );
      final response = await http.get(url);
      if (response.statusCode == 200) {
        return compute(parseCountry, response.body);
      } else {
        throw Exception('Failed to load json data');
      }
    } catch (_) {}
    return [];
  }
}
