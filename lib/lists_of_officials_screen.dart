import 'dart:convert'; // Added for jsonDecode
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // Added for http
import 'database.dart';

class ListsOfOfficialsScreen extends StatefulWidget {
  const ListsOfOfficialsScreen({super.key});

  @override
  State<ListsOfOfficialsScreen> createState() => _ListsOfOfficialsScreenState();
}

class _ListsOfOfficialsScreenState extends State<ListsOfOfficialsScreen> {
  String? selectedList;
  List<String> lists = ['No saved lists', '+ Create new list'];
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
          if (fetchedLists.isNotEmpty) {
            lists = fetchedLists.map((list) => list['name'] as String).toList();
            lists.add('+ Create new list');
          } // If empty, keep 'No saved lists' as default
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load lists: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching lists: $e');
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading lists: $e')),
      );
    }
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
                                  arguments: lists,
                                ).then((result) {
                                  if (result != null) {
                                    setState(() {
                                      if (lists.contains('No saved lists')) {
                                        lists.remove('No saved lists');
                                      }
                                      lists.add(result as String);
                                      selectedList = result;
                                    });
                                  }
                                });
                              }
                            });
                          },
                          items: lists.map((value) {
                            return DropdownMenuItem(
                              value: value,
                              child: Text(
                                value,
                                style: value == 'No saved lists'
                                    ? const TextStyle(color: Colors.red)
                                    : const TextStyle(color: Colors.black),
                              ),
                            );
                          }).toList(),
                        ),
                  const SizedBox(height: 60),
                  ElevatedButton(
                    onPressed: () {
                      if (selectedList != null &&
                          selectedList != '+ Create new list' &&
                          selectedList != 'No saved lists') {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content:
                                  Text('Editing $selectedList coming soon')),
                        );
                      } else if (selectedList == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text(
                                  'Please select or create a valid list!')),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2196F3),
                      side: const BorderSide(color: Colors.black, width: 2),
                      minimumSize: const Size(250, 70),
                    ),
                    child: const Text(
                      'Continue',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
