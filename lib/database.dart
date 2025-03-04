import 'dart:convert';
import 'package:http/http.dart' as http;

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static const String baseUrl = 'http://10.0.2.2:3000';

  DatabaseHelper._init();

  Future<List<Map<String, dynamic>>> getOfficials() async {
    print('Starting HTTP request to $baseUrl/officials');
    final response = await http.get(Uri.parse('$baseUrl/officials'));
    print('HTTP request completed with status: ${response.statusCode}');

    if (response.statusCode == 200) {
      final List<dynamic> officialsJson = jsonDecode(response.body);
      print('Data received: ${officialsJson.length} officials');

      return officialsJson.map((json) {
        final sports = json['sports'] is String ? json['sports'].split(',') : [];
        final levels = json['levels'] is String ? json['levels'].split(',') : [];
        return {
          'id': json['id'],
          'name': '${json['first_name']} ${json['last_name']}',
          'sports': sports,
          'levels': levels,
          'zipCode': json['zip_code'],
          'ihsaRegistered': json['ihsa_credential'] == 'IHSA Registered' ||
              json['ihsa_credential'] == 'IHSA Recognized' ||
              json['ihsa_credential'] == 'IHSA Certified',
          'ihsaRecognized': json['ihsa_credential'] == 'IHSA Recognized' ||
              json['ihsa_credential'] == 'IHSA Certified',
          'ihsaCertified': json['ihsa_credential'] == 'IHSA Certified',
          'yearsExperience': json['years_experience'],
          'cityState': 'Unknown, ST', // Placeholder since not provided
        };
      }).toList();
    } else {
      throw Exception('Failed to load officials: ${response.statusCode}');
    }
  }

  Future<Map<String, dynamic>> saveList(Map<String, dynamic> listData) async {
    print('Saving list to $baseUrl/lists: $listData');
    final response = await http.post(
      Uri.parse('$baseUrl/lists'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(listData),
    );
    print('HTTP request completed with status: ${response.statusCode}');

    if (response.statusCode == 201 || response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      print('List saved successfully: $responseData');
      return responseData;
    } else {
      throw Exception('Failed to save list: ${response.statusCode}');
    }
  }
}