import 'package:flutter/material.dart';

class SelectOfficialsListScreen extends StatefulWidget {
  final String scheduleName;
  const SelectOfficialsListScreen({super.key, required this.scheduleName});
  @override
  State<SelectOfficialsListScreen> createState() =>
      _SelectOfficialsListScreenState();
}

class _SelectOfficialsListScreenState extends State<SelectOfficialsListScreen> {
  String? selectedList;
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
          'Select Officials List',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Stack(
            alignment: Alignment.topRight,
            children: [
              IconButton(
                icon: const Icon(
                  Icons.monetization_on,
                  size: 36,
                  color: Colors.white,
                ),
                onPressed: () {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(const SnackBar(content: Text('Tokens: 1')));
                },
              ),
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 16,
                    minHeight: 16,
                  ),
                  child: const Text(
                    '1',
                    style: TextStyle(color: Colors.white, fontSize: 10),
                    textAlign: TextAlign.center,
                  ),
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
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Select a list of officials to edit or create a new list.',
                  style: TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 20),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue, width: 2.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue, width: 2.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue, width: 2.0),
                    ),
                    hintText: 'Select a list',
                  ),
                  value: selectedList,
                  onChanged:
                      (String? newValue) =>
                          setState(() => selectedList = newValue),
                  items:
                      ['Underclass Football (Rookies)']
                          .map(
                            (value) => DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value,
                                style: const TextStyle(fontSize: 18),
                              ),
                            ),
                          )
                          .toList(),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    print(
                      'Navigating to AddOfficialsScreen with schedule: ${widget.scheduleName}',
                    );
                    Navigator.pushNamed(
                      context,
                      '/add_officials',
                      arguments: widget.scheduleName,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(250, 50),
                  ),
                  child: const Text('Create new list'),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (selectedList != null) {
                      print(
                        'Continuing with selected list: $selectedList for schedule: ${widget.scheduleName}',
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Selected List: $selectedList')),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Please select a list or create a new one!',
                          ),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(250, 50),
                  ),
                  child: const Text('Continue'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
