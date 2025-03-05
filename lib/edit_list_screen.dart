import 'package:flutter/material.dart';
import 'database.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class EditListScreen extends StatefulWidget {
  const EditListScreen({super.key});

  @override
  State<EditListScreen> createState() => _EditListScreenState();
}

class _EditListScreenState extends State<EditListScreen> {
  String searchQuery = '';
  late List<Map<String, dynamic>> selectedOfficialsList;
  late List<Map<String, dynamic>> filteredOfficials;
  Map<int, bool> selectedOfficials = {};
  bool isInitialized = false;
  String? listName;
  int? listId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!isInitialized) {
      final arguments =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      listName = arguments['listName'] as String;
      listId = arguments['listId'] as int;
      selectedOfficialsList =
          arguments['officials'] as List<Map<String, dynamic>>? ?? [];
      filteredOfficials = List.from(selectedOfficialsList);
      for (var official in selectedOfficialsList) {
        selectedOfficials[official['id'] as int] = true;
      }
      isInitialized = true;
    }
  }

  void filterOfficials(String query) {
    setState(() {
      searchQuery = query;
      filteredOfficials = List.from(selectedOfficialsList);
      if (query.isNotEmpty) {
        filteredOfficials = filteredOfficials
            .where((official) =>
                official['name'].toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  Future<void> _saveList() async {
    final selectedOfficialsData = selectedOfficialsList
        .where((official) => selectedOfficials[official['id'] as int] ?? false)
        .map((official) => {'official_id': official['id']})
        .toList();

    final listData = {
      'name': listName!,
      'sport': 'Football', // Replace with dynamic sport if available
      'official_ids':
          selectedOfficialsData.map((o) => o['official_id']).toList(),
    };

    try {
      final response = await http.put(
        Uri.parse('${DatabaseHelper.baseUrl}/lists/$listId'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(listData),
      );
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('List updated!'), duration: Duration(seconds: 2)),
        );
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) {
            Navigator.of(context)
                .pushNamedAndRemoveUntil('/home', (route) => false);
          }
        });
      } else {
        throw Exception('Failed to update list: ${response.statusCode}');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving list: $e')),
      );
    }
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
          'Edit List',
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
                            'No officials in this list.',
                            style: TextStyle(fontSize: 18, color: Colors.grey),
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
                                const Text('Select all',
                                    style: TextStyle(fontSize: 18)),
                              ],
                            ),
                            Expanded(
                              child: ListView.builder(
                                itemCount: filteredOfficials.length,
                                itemBuilder: (context, index) {
                                  final official = filteredOfficials[index];
                                  final officialId = official['id'] as int;
                                  return ListTile(
                                    key: ValueKey(officialId),
                                    leading: IconButton(
                                      icon: Icon(
                                        selectedOfficials[officialId] ?? false
                                            ? Icons.check_circle
                                            : Icons.add_circle,
                                        color: selectedOfficials[officialId] ??
                                                false
                                            ? Colors.green
                                            : const Color(0xFF2196F3),
                                        size: 36,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          selectedOfficials[officialId] =
                                              !(selectedOfficials[officialId] ??
                                                  false);
                                          if (selectedOfficials[officialId] ==
                                              false) {
                                            selectedOfficials
                                                .remove(officialId);
                                          }
                                        });
                                      },
                                    ),
                                    title: Text(
                                        '${official['name']} (${official['cityState'] ?? 'Unknown'})'),
                                    subtitle: Text(
                                      'Distance: ${official['distance'] != null ? (official['distance'] as num).toStringAsFixed(1) : '0.0'} mi, Experience: ${official['yearsExperience'] ?? 0} yrs',
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
      ),
      bottomNavigationBar: Padding(
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
                Navigator.pushNamed(
                  context,
                  '/populate_roster',
                  arguments: {
                    'sport': 'Football',
                    'listName': listName,
                    'listId': listId,
                    'selectedOfficials': selectedOfficialsList
                        .where((official) =>
                            selectedOfficials[official['id'] as int] ?? false)
                        .toList(),
                  },
                ).then((result) {
                  if (result != null) {
                    setState(() {
                      selectedOfficialsList =
                          result as List<Map<String, dynamic>>;
                      filteredOfficials = List.from(selectedOfficialsList);
                      selectedOfficials.clear();
                      for (var official in selectedOfficialsList) {
                        selectedOfficials[official['id'] as int] = true;
                      }
                    });
                  }
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2196F3),
                side: const BorderSide(color: Colors.black, width: 2),
                minimumSize: const Size(250, 50),
                textStyle:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              child: const Text('Add Official(s)'),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: selectedCount > 0 ? _saveList : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2196F3),
                side: const BorderSide(color: Colors.black, width: 2),
                minimumSize: const Size(250, 50),
                textStyle:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              child: const Text('Save List'),
            ),
          ],
        ),
      ),
    );
  }
}
