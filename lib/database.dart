import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static const String baseUrl = 'http://10.0.2.2:3000'; // Emulator host mapping

  DatabaseHelper._init();

  Future<List<Map<String, dynamic>>> getOfficials() async {
    try {
      print('Starting request to $baseUrl/officials');
      // Use compute to run the HTTP request off the main thread
      final response = await compute(_fetchOfficials, baseUrl);
      print('Request completed with status: ${response.statusCode}');

      if (response.statusCode == 200) {
        return List<Map<String, dynamic>>.from(json.decode(response.body))
            .map((o) => {
                  'id': o['id'],
                  'name': '${o['first_name']} ${o['last_name']}',
                  'sports': o['sports']?.split(',') ?? [],
                  'levels': o['levels']?.split(',') ?? [],
                  'zipCode': o['zip_code'],
                  'ihsaRegistered': o['ihsa_credential'] == 'IHSA Registered' ||
                      o['ihsa_credential'] == 'IHSA Recognized' ||
                      o['ihsa_credential'] == 'IHSA Certified',
                  'ihsaRecognized': o['ihsa_credential'] == 'IHSA Recognized' ||
                      o['ihsa_credential'] == 'IHSA Certified',
                  'ihsaCertified': o['ihsa_credential'] == 'IHSA Certified',
                  'yearsExperience': o['years_experience'],
                  'distance': 0,
                  'cityState': 'Unknown, ST',
                })
            .toList();
      } else {
        throw Exception(
            'Failed to load officials: Status code ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching officials: $e');
      rethrow;
    }
  }
}

// Isolate function to perform HTTP request
Future<http.Response> _fetchOfficials(String baseUrl) async {
  return await Future.any([
    http.get(Uri.parse('$baseUrl/officials')),
    Future.delayed(Duration(seconds: 10))
        .then((_) => throw Exception('Request timed out after 10 seconds')),
  ]);
}
