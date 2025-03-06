import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'database.dart';

class ListsOfOfficialsScreen extends StatefulWidget {
  const ListsOfOfficialsScreen({super.key});

  @override
  State<ListsOfOfficialsScreen> createState() => _ListsOfOfficialsScreenState();
}

class _ListsOfOfficialsScreenState extends State<ListsOfOfficialsScreen> {
  String? selectedList;
  List<Map<String, dynamic>> lists = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchLists();
  }

  Future<void> _fetchLists() async {
    try {
      final response =
          await http.get(Uri.parse('${DatabaseHelper.baseUrl}/lists'));
      if (response.statusCode == 200) {
        final List<dynamic> fetchedLists = jsonDecode(response.body);
        setState(() {
          lists =
              fetchedLists.map((list) => list as Map<String, dynamic>).toList();
          if (lists.isEmpty) {
            lists.add({'name': 'No saved lists', 'id': -1});
          }
          lists.add({'name': '+ Create new list', 'id': 0});
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load lists: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching lists: $e');
      setState(() {
        isLoading = false;
        lists = [
          {'name': 'No saved lists', 'id': -1},
          {'name': '+ Create new list', 'id': 0}
        ];
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading lists: $e')),
      );
    }
  }

  Future<List<Map<String, dynamic>>> _fetchListOfficials(int listId) async {
    try {
      final response = await http
          .get(Uri.parse('${DatabaseHelper.baseUrl}/lists/$listId/officials'));
      if (response.statusCode == 200) {
        return List<Map<String, dynamic>>.from(jsonDecode(response.body));
      } else {
        throw Exception('Failed to load officials: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching officials: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading officials: $e')),
      );
      return [];
    }
  }

  Future<void> _deleteList(int listId) async {
    try {
      final response = await http
          .delete(Uri.parse('${DatabaseHelper.baseUrl}/lists/$listId'));
      if (response.statusCode == 204) {
        // Successfully deleted
        setState(() {
          lists.removeWhere((list) => list['id'] == listId);
          selectedList = null;
          if (lists.isEmpty ||
              (lists.length == 1 && lists[0]['name'] == '+ Create new list')) {
            lists = [
              {'name': 'No saved lists', 'id': -1},
              {'name': '+ Create new list', 'id': 0}
            ];
          }
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('List deleted successfully')),
        );
      } else {
        throw Exception('Failed to delete list: ${response.statusCode}');
      }
    } catch (e) {
      print('Error deleting list: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting list: $e')),
      );
    }
  }

  void _showDeleteConfirmationDialog(String listName, int listId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: Text('Are you sure you want to delete your $listName list?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                _deleteList(listId); // Proceed with deletion
              },
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );
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
          'Lists of Officials',
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
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Select a list of officials to edit or create a new list.',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 60),
                  isLoading
                      ? const CircularProgressIndicator()
                      : DropdownButtonFormField<String>(
                          decoration: const InputDecoration(
                            labelText: 'Official Lists',
                            labelStyle: TextStyle(color: Colors.black),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(0xFF2196F3), width: 2),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(0xFF2196F3), width: 2),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(0xFF2196F3), width: 2),
                            ),
                          ),
                          value: selectedList,
                          onChanged: (newValue) {
                            setState(() {
                              selectedList = newValue;
                              if (newValue == '+ Create new list') {
                                Navigator.pushNamed(
                                  context,
                                  '/create_new_list',
                                  arguments: lists
                                      .map((l) => l['name'] as String)
                                      .toList(),
                                ).then((result) {
                                  if (result != null) {
                                    setState(() {
                                      if (lists.any((l) =>
                                          l['name'] == 'No saved lists')) {
                                        lists.removeWhere((l) =>
                                            l['name'] == 'No saved lists');
                                      }
                                      lists.insert(0, {
                                        'name': result as String,
                                        'id': lists.length + 1
                                      });
                                      selectedList = result;
                                    });
                                  } else {
                                    selectedList = null;
                                  }
                                });
                              }
                            });
                          },
                          items: lists.map((list) {
                            return DropdownMenuItem(
                              value: list['name'] as String,
                              child: Text(
                                list['name'] as String,
                                style: list['name'] == 'No saved lists'
                                    ? const TextStyle(color: Colors.red)
                                    : const TextStyle(color: Colors.black),
                              ),
                            );
                          }).toList(),
                        ),
                  const SizedBox(height: 60),
                  // Show buttons only if an existing list is selected
                  if (selectedList != null &&
                      selectedList != '+ Create new list' &&
                      selectedList != 'No saved lists') ...[
                    ElevatedButton(
                      onPressed: () async {
                        final selected =
                            lists.firstWhere((l) => l['name'] == selectedList);
                        final officials =
                            await _fetchListOfficials(selected['id'] as int);
                        Navigator.pushNamed(
                          context,
                          '/edit_list',
                          arguments: {
                            'listName': selectedList,
                            'listId': selected['id'],
                            'officials': officials,
                          },
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2196F3),
                        side: const BorderSide(color: Colors.black, width: 2),
                        minimumSize: const Size(250, 70),
                      ),
                      child: const Text(
                        'Edit List',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 8), // Space between buttons
                    ElevatedButton(
                      onPressed: () {
                        final selected =
                            lists.firstWhere((l) => l['name'] == selectedList);
                        _showDeleteConfirmationDialog(
                            selectedList!, selected['id'] as int);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        side: const BorderSide(color: Colors.black, width: 2),
                        minimumSize:
                            const Size(125, 35), // Half the size of Edit List
                        foregroundColor: Colors.white,
                      ),
                      child: const Text(
                        'Delete List',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
