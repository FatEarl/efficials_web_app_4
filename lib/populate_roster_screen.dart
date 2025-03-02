import 'package:flutter/material.dart';

class PopulateRosterScreen extends StatefulWidget {
  const PopulateRosterScreen({super.key});

  @override
  State<PopulateRosterScreen> createState() => _PopulateRosterScreenState();
}

class _PopulateRosterScreenState extends State<PopulateRosterScreen> {
  String searchQuery = '';
  List<Map<String, dynamic>> officials = [];
  List<Map<String, dynamic>> filteredOfficials = [];

  final List<Map<String, dynamic>> mockOfficials = [
    {
      'name': 'Mike Johnson',
      'sports': ['Football'],
      'levels': ['Underclass', 'JV'],
      'zipCode': '10001',
      'distance': 0,
      'ihsaRegistered': true,
      'ihsaRecognized': false,
      'ihsaCertified': true,
      'yearsExperience': 5,
    },
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      populateOfficials();
    });
  }

  void populateOfficials() {
    final arguments = ModalRoute.of(context)!.settings.arguments;

    setState(() {
      if (arguments == null) {
        officials = [];
        filteredOfficials = [];
        return;
      }

      if (arguments is String) {
        officials = [];
        filteredOfficials = [];
        return;
      }

      final settings = arguments as Map<String, dynamic>;
      final sport = settings['listName'] as String;
      final ihsaRegistered = settings['ihsaRegistered'] as bool? ?? false;
      final ihsaRecognized = settings['ihsaRecognized'] as bool? ?? false;
      final ihsaCertified = settings['ihsaCertified'] as bool? ?? false;
      final minYears = settings['minYears'] as int? ?? 0;
      final levels = settings['levels'] as List<String>;
      final schedulerZipCode = settings['zipCode'] as String;
      final radius = settings['radius'] as int;

      final Map<String, double> zipDistances = {
        '10001': schedulerZipCode == '10001' ? 0.0 : 2500.0,
      };

      officials = mockOfficials.where((official) {
        final matchesSport = official['sports'].contains(sport);
        final matchesLevel =
            official['levels'].any((level) => levels.contains(level));
        final matchesIhsaRegistered =
            ihsaRegistered ? official['ihsaRegistered'] as bool : true;
        final matchesIhsaRecognized =
            ihsaRecognized ? official['ihsaRecognized'] as bool : true;
        final matchesIhsaCertified =
            ihsaCertified ? official['ihsaCertified'] as bool : true;
        final matchesExperience =
            (official['yearsExperience'] as int) >= minYears;
        final distance = zipDistances[official['zipCode']] ?? double.infinity;
        official['distance'] = distance;
        final withinDistance = distance <= radius;

        return matchesSport &&
            matchesLevel &&
            matchesIhsaRegistered &&
            matchesIhsaRecognized &&
            matchesIhsaCertified &&
            matchesExperience &&
            withinDistance;
      }).toList();

      filteredOfficials = List.from(officials);
    });
  }

  void filterOfficials(String query) {
    setState(() {
      searchQuery = query;
      if (query.isEmpty) {
        filteredOfficials = List.from(officials);
      } else {
        filteredOfficials = officials
            .where((official) =>
                official['name'].toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF2196F3),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, size: 36, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Populate Roster',
          style: TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        actions: [
          Stack(
            alignment: Alignment.topRight,
            children: [
              IconButton(
                icon: const Icon(Icons.monetization_on,
                    size: 36, color: Colors.white),
                onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Tokens: 1')),
                ),
              ),
              const Positioned(
                right: 8,
                top: 8,
                child: CircleAvatar(
                  radius: 8,
                  backgroundColor: Colors.red,
                  child: Text('1',
                      style: TextStyle(color: Colors.white, fontSize: 10)),
                ),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: TextField(
                decoration: const InputDecoration(
                  labelText: 'Search Officials',
                  labelStyle: TextStyle(color: Colors.black),
                  hintText: 'Enter official name...',
                  hintStyle: TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF2196F3), width: 2),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF2196F3), width: 2),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF2196F3), width: 2),
                  ),
                  prefixIcon: Icon(Icons.search, color: Colors.black),
                ),
                textAlign: TextAlign.left,
                style: const TextStyle(fontSize: 18),
                onChanged: (value) {
                  filterOfficials(value);
                },
              ),
            ),
          ),
          if (filteredOfficials.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Text(
                'No officials found.',
                style: TextStyle(fontSize: 18, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ),
          Expanded(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 600),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if (filteredOfficials.isNotEmpty)
                        Expanded(
                          child: ListView.builder(
                            itemCount: filteredOfficials.length,
                            itemBuilder: (context, index) {
                              final official = filteredOfficials[index];
                              return ListTile(
                                title: Text(official['name']),
                                subtitle: Text(
                                  'Sport: ${official['sports'].join(', ')} | Levels: ${official['levels'].join(', ')}',
                                ),
                              );
                            },
                          ),
                        ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Spacer(flex: 1),
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  populateOfficials();
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF2196F3),
                                side: const BorderSide(
                                    color: Colors.black, width: 2),
                                minimumSize: const Size(250, 50),
                              ),
                              child: const Text(
                                'Populate Roster',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Wrap(
                              alignment: WrapAlignment.center,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                const Text(
                                  'Before populating the roster of officials, adjust the filter settings by selecting the ',
                                  style: TextStyle(fontSize: 18),
                                  textAlign: TextAlign.center,
                                ),
                                Container(
                                  decoration: const BoxDecoration(
                                    color: Color(0xFF2196F3),
                                    shape: BoxShape.circle,
                                  ),
                                  padding: const EdgeInsets.all(3),
                                  child: const Icon(
                                    Icons.filter_list,
                                    size: 18,
                                    color: Colors.white,
                                  ),
                                ),
                                const Text(
                                  ' icon below.',
                                  style: TextStyle(fontSize: 18),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                            const Spacer(flex: 2),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/filter_settings',
              arguments: ModalRoute.of(context)!.settings.arguments as String);
        },
        backgroundColor: const Color(0xFF2196F3),
        child: const Icon(Icons.filter_list, size: 30, color: Colors.white),
      ),
    );
  }
}
