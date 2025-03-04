import 'package:flutter/material.dart';
import 'database.dart';

class PopulateRosterScreen extends StatefulWidget {
  const PopulateRosterScreen({super.key});

  @override
  State<PopulateRosterScreen> createState() => _PopulateRosterScreenState();
}

class _PopulateRosterScreenState extends State<PopulateRosterScreen> {
  String searchQuery = '';
  List<Map<String, dynamic>> officials = [];
  List<Map<String, dynamic>> filteredOfficials = [];
  List<Map<String, dynamic>> filteredOfficialsWithoutSearch = [];
  String filterSummary = '';
  bool filtersApplied = false;
  bool isLoading = false;
  Map<int, bool> selectedOfficials = {};
  Map<String, dynamic>? filterSettings;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _loadOfficials() async {
    setState(() {
      isLoading = true;
    });
    try {
      final dbOfficials = await DatabaseHelper.instance.getOfficials();
      setState(() {
        officials = dbOfficials;
        print('Loaded ${officials.length} officials');
        if (officials.isNotEmpty) {
          print('First official: ${officials[0]}');
        }
        filteredOfficials = [];
        filteredOfficialsWithoutSearch = [];
        filterSummary = 'No filters applied';
        if (filterSettings != null) {
          _applyFiltersWithSettings(filterSettings!);
        }
      });
    } catch (e) {
      print('Error in _loadOfficials: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading officials: $e')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _applyFilters(Map<String, dynamic> settings) {
    _applyFiltersWithSettings(settings);
  }

  void _applyFiltersWithSettings(Map<String, dynamic> settings) {
    print('Applying filters with settings: $settings');
    _loadOfficials().then((_) {
      setState(() {
        filterSettings = settings;
        filtersApplied = true;
        final sport = settings['listName'] as String;
        final ihsaRegistered = settings['ihsaRegistered'] as bool? ?? false;
        final ihsaRecognized = settings['ihsaRecognized'] as bool? ?? false;
        final ihsaCertified = settings['ihsaCertified'] as bool? ?? false;
        final minYears = settings['minYears'] as int? ?? 0;
        final levels = settings['levels'] as List<String>;
        final schedulerZip = settings['zipCode'] as String;
        final radius = settings['radius'] as int;

        filteredOfficials = officials.where((official) {
          final matchesSport = (official['sports'] as List)
              .map((s) => s.toLowerCase())
              .contains(sport.toLowerCase());
          final matchesLevel = levels.isEmpty ||
              (official['levels'] as List)
                  .any((level) => levels.contains(level));
          final matchesIhsaRegistered =
              ihsaRegistered ? official['ihsaRegistered'] as bool : true;
          final matchesIhsaRecognized =
              ihsaRecognized ? official['ihsaRecognized'] as bool : true;
          final matchesIhsaCertified =
              ihsaCertified ? official['ihsaCertified'] as bool : true;
          final matchesExperience =
              (official['yearsExperience'] as int? ?? 0) >= minYears;
          final distance = official['zipCode'] == schedulerZip ? 0 : 10;
          official['distance'] = distance;
          final withinDistance = distance <= radius;

          print(
              'Official: ${official['name']}, Sport: $sport, Matches Sport: $matchesSport, '
              'Levels: $levels, Matches Level: $matchesLevel, '
              'Distance: $distance, Within Distance: $withinDistance, '
              'Matches Experience: $matchesExperience');

          return matchesSport &&
              matchesLevel &&
              matchesIhsaRegistered &&
              matchesIhsaRecognized &&
              matchesIhsaCertified &&
              matchesExperience &&
              withinDistance;
        }).toList();

        filteredOfficialsWithoutSearch = List.from(filteredOfficials);

        if (searchQuery.isNotEmpty) {
          filteredOfficials = filteredOfficials
              .where((official) => official['name']
                  .toLowerCase()
                  .contains(searchQuery.toLowerCase()))
              .toList();
        }

        print('Filtered officials: ${filteredOfficials.length}');
        if (filteredOfficials.isNotEmpty) {
          print('First filtered official: ${filteredOfficials[0]}');
        }

        filterSummary = 'Filters: Sport: $sport, '
            'Levels: ${levels.join(', ')}, '
            'IHSA: ${ihsaRegistered ? "Reg " : ""}${ihsaRecognized ? "Rec " : ""}${ihsaCertified ? "Cert" : ""}, '
            'Exp: $minYears+, '
            'Radius: $radius mi';
      });
    });
  }

  void filterOfficials(String query) {
    setState(() {
      print('Before filterOfficials - Selected officials: $selectedOfficials');
      searchQuery = query;
      if (filtersApplied) {
        filteredOfficials = List.from(filteredOfficialsWithoutSearch);

        if (query.isNotEmpty) {
          filteredOfficials = filteredOfficials
              .where((official) =>
                  official['name'].toLowerCase().contains(query.toLowerCase()))
              .toList();
        }

        print('Filtered officials after search: ${filteredOfficials.length}');
        print('After filterOfficials - Selected officials: $selectedOfficials');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final int selectedCount =
        selectedOfficials.values.where((selected) => selected).length;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF2196F3),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, size: 36, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Find Officials',
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
          if (isLoading) ...[
            const Expanded(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          ] else if (!filtersApplied) ...[
            const Expanded(
              child: Center(
                child: Text(
                  'The roster will populate after\nfilters have been applied.',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ] else ...[
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: TextField(
                  decoration: const InputDecoration(
                    labelText: 'Search Officials',
                    border: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color(0xFF2196F3), width: 2),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color(0xFF2196F3), width: 2),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color(0xFF2196F3), width: 2),
                    ),
                    prefixIcon: Icon(Icons.search, color: Colors.black),
                  ),
                  style: const TextStyle(fontSize: 18),
                  onChanged: (value) => filterOfficials(value),
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 600),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: filteredOfficials.isEmpty
                        ? const Center(
                            child: Text(
                              'No officials found. Try adjusting your filters.',
                              style:
                                  TextStyle(fontSize: 18, color: Colors.grey),
                              textAlign: TextAlign.center,
                            ),
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Checkbox(
                                    value: filteredOfficials.isNotEmpty &&
                                        filteredOfficials.every((official) =>
                                            selectedOfficials[official['id']] ??
                                            false),
                                    onChanged: (bool? value) {
                                      setState(() {
                                        if (value == true) {
                                          for (final official
                                              in filteredOfficials) {
                                            selectedOfficials[official['id']] =
                                                true;
                                          }
                                        } else {
                                          for (final official
                                              in filteredOfficials) {
                                            selectedOfficials
                                                .remove(official['id']);
                                          }
                                        }
                                      });
                                    },
                                  ),
                                  const Text(
                                    'Select all',
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ],
                              ),
                              Expanded(
                                child: ListView.builder(
                                  itemCount: filteredOfficials.length,
                                  itemBuilder: (context, index) {
                                    final official = filteredOfficials[index];
                                    final officialId = official['id'] as int;
                                    print(
                                        'Rendering official ID: $officialId, Selected: ${selectedOfficials[officialId] ?? false}');
                                    return ListTile(
                                      key: ValueKey(officialId),
                                      leading: IconButton(
                                        icon: Icon(
                                          selectedOfficials[officialId] ?? false
                                              ? Icons.check_circle
                                              : Icons.add_circle,
                                          color:
                                              selectedOfficials[officialId] ??
                                                      false
                                                  ? Colors.green
                                                  : const Color(0xFF2196F3),
                                          size: 36,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            selectedOfficials[officialId] =
                                                !(selectedOfficials[
                                                        officialId] ??
                                                    false);
                                            if (selectedOfficials[officialId] ==
                                                false) {
                                              selectedOfficials
                                                  .remove(officialId);
                                            }
                                            print(
                                                'After selection change - Selected officials: $selectedOfficials');
                                          });
                                        },
                                      ),
                                      title: Text(
                                          '${official['name']} (${official['cityState']})'),
                                      subtitle: Text(
                                        'Distance: ${official['distance'].toStringAsFixed(1)} mi, Experience: ${official['yearsExperience']} yrs',
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
      floatingActionButton: Padding(
        padding: filtersApplied
            ? const EdgeInsets.only(bottom: 0)
            : const EdgeInsets.only(bottom: 106),
        child: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(
              context,
              '/filter_settings',
              arguments: ModalRoute.of(context)!.settings.arguments as String,
            ).then((result) {
              if (result != null) {
                _applyFilters(result as Map<String, dynamic>);
              }
            });
          },
          elevation: 0,
          backgroundColor: const Color(0xFF2196F3),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            side: const BorderSide(color: Colors.black, width: 2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.filter_list, size: 30, color: Colors.white),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: filtersApplied
          ? Padding(
              padding: const EdgeInsets.only(bottom: 32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '($selectedCount) Selected',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {
                      if (selectedCount > 0) {
                        final selected = officials
                            .where((o) => selectedOfficials[o['id']] ?? false)
                            .toList();
                        Navigator.pushNamed(
                          context,
                          '/review_list',
                          arguments: {
                            'sport': filterSettings!['listName'] as String,
                            'officials': selected,
                          },
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Select at least one official!')),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2196F3),
                      foregroundColor: Colors.white,
                      side: const BorderSide(color: Colors.black, width: 2),
                      minimumSize: const Size(250, 50),
                      textStyle: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    child: const Text('Continue'),
                  ),
                ],
              ),
            )
          : null,
    );
  }
}
