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
  String filterSummary = '';
  bool filtersApplied = false;
  bool isLoading = true;
  Map<int, bool> selectedOfficials = {};
  Map<String, dynamic>? filterSettings;

  @override
  void initState() {
    super.initState();
    _loadOfficials();
  }

  Future<void> _loadOfficials() async {
    setState(() {
      isLoading = true;
    });
    try {
      final dbOfficials = await DatabaseHelper.instance.getOfficials();
      setState(() {
        officials = dbOfficials;
        filteredOfficials = [];
        filterSummary = 'No filters applied';
        selectedOfficials.clear();
        if (filterSettings != null) {
          _applyFiltersWithSettings(filterSettings!);
        }
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading officials: $e')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _applyFilters() {
    final arguments = ModalRoute.of(context)!.settings.arguments;

    if (arguments == null || arguments is String) {
      setState(() {
        filteredOfficials = [];
        filterSummary = 'No filters applied';
        filtersApplied = false;
        selectedOfficials.clear();
      });
      return;
    }

    _applyFiltersWithSettings(arguments as Map<String, dynamic>);
  }

  void _applyFiltersWithSettings(Map<String, dynamic> settings) {
    setState(() {
      filterSettings = settings;
      filtersApplied = true;
      final sport = settings['listName'] as String;
      final ihsaRegistered = settings['ihsaRegistered'] as bool? ?? false;
      final ihsaRecognized = settings['ihsaRecognized'] as bool? ?? false;
      final ihsaCertified = settings['ihsaCertified'] as bool? ?? false;
      final minYears = settings['minYears'] as int? ?? 0;
      final levels = settings['levels'] as List<String>;
      final schedulerZipCode = settings['zipCode'] as String;
      final radius = settings['radius'] as int;

      filteredOfficials = officials.where((official) {
        final matchesSport = (official['sports'] as List).contains(sport);
        final matchesLevel = levels.isEmpty ||
            (official['levels'] as List).any((level) => levels.contains(level));
        final matchesIhsaRegistered =
            ihsaRegistered ? official['ihsaRegistered'] as bool : true;
        final matchesIhsaRecognized =
            ihsaRecognized ? official['ihsaRecognized'] as bool : true;
        final matchesIhsaCertified =
            ihsaCertified ? official['ihsaCertified'] as bool : true;
        final matchesExperience =
            (official['yearsExperience'] as int) >= minYears;
        final distance = official['zipCode'] == schedulerZipCode
            ? 0
            : 10; // Reduced default distance
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

      if (searchQuery.isNotEmpty) {
        filteredOfficials = filteredOfficials
            .where((official) => official['name']
                .toLowerCase()
                .contains(searchQuery.toLowerCase()))
            .toList();
      }

      filterSummary = 'Filters: Sport: $sport, '
          'Levels: ${levels.join(', ')}, '
          'IHSA: ${ihsaRegistered ? "Reg " : ""}${ihsaRecognized ? "Rec " : ""}${ihsaCertified ? "Cert" : ""}, '
          'Exp: $minYears+, '
          'Radius: $radius mi';

      selectedOfficials.clear();
    });
  }

  void filterOfficials(String query) {
    setState(() {
      searchQuery = query;
      if (filtersApplied && filterSettings != null) {
        _applyFiltersWithSettings(filterSettings!);
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
                                        filteredOfficials.every((official) {
                                          final index =
                                              officials.indexOf(official);
                                          return selectedOfficials[index] ??
                                              false;
                                        }),
                                    onChanged: (bool? value) {
                                      setState(() {
                                        if (value == true) {
                                          for (int i = 0;
                                              i < filteredOfficials.length;
                                              i++) {
                                            final index = officials
                                                .indexOf(filteredOfficials[i]);
                                            selectedOfficials[index] = true;
                                          }
                                        } else {
                                          selectedOfficials.clear();
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
                                    final officialIndex =
                                        officials.indexOf(official);
                                    return ListTile(
                                      leading: IconButton(
                                        icon: Icon(
                                          selectedOfficials[officialIndex] ??
                                                  false
                                              ? Icons.check_circle
                                              : Icons.add_circle,
                                          color: selectedOfficials[
                                                      officialIndex] ??
                                                  false
                                              ? Colors.green
                                              : const Color(0xFF2196F3),
                                          size: 36,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            selectedOfficials[officialIndex] =
                                                !(selectedOfficials[
                                                        officialIndex] ??
                                                    false);
                                          });
                                        },
                                      ),
                                      title: Text(
                                          '${official['name']} (${official['cityState']})'),
                                      subtitle: Text(
                                        'Experience: ${official['yearsExperience']} yrs',
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
                _applyFiltersWithSettings(result as Map<String, dynamic>);
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
                      // Handle continue action
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
