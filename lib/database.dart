import 'package:http/http.dart' as http;
import 'dart:convert';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static const String baseUrl =
      'http://192.168.1.117:3000'; // Updated with your IP

  DatabaseHelper._init();

  Future<List<Map<String, dynamic>>> getOfficials() async {
    final response = await http.get(Uri.parse('$baseUrl/officials'));
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
                'distance': 0, // Placeholder until distance logic is added
                'cityState': 'Unknown, ST', // Placeholder
              })
          .toList();
    } else {
      throw Exception('Failed to load officials: ${response.statusCode}');
    }
  }
}
