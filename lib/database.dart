import 'package:http/http.dart' as http;
import 'dart:convert';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static const String baseUrl = 'http://10.0.2.2:3000'; // Emulator host mapping

  DatabaseHelper._init();

  Future<List<Map<String, dynamic>>> getOfficials() async {
    print('Starting HTTP request to $baseUrl/officials');
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/officials'))
          .timeout(Duration(seconds: 5), onTimeout: () {
        print('HTTP request timed out after 5 seconds');
        throw Exception('Request timed out after 5 seconds');
      });

      print('HTTP request completed with status: ${response.statusCode}');
      print('Response body: ${response.body}');
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('Data received: ${data.length} officials');
        if (data.isEmpty) {
          print('Warning: No officials returned from backend');
        }
        return List<Map<String, dynamic>>.from(data).map((o) => {
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
              'yearsExperience': o['years_experience'] ?? 0, // Default to 0 if null
              'distance': 0,
              'cityState': 'Unknown, ST',
            }).toList();
      } else {
        print('HTTP request failed with status: ${response.statusCode}');
        throw Exception(
            'Failed to load officials: Status code ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching officials: $e');
      rethrow;
    }
  }
}