import 'package:flutter/material.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key});

  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  String? selectedLocation;
  final List<String> savedLocations = [];

  @override
  Widget build(BuildContext context) {
    final String scheduleName =
        ModalRoute.of(context)!.settings.arguments as String;

    List<DropdownMenuItem<String>> dropdownItems = [];
    if (savedLocations.isEmpty) {
      dropdownItems.add(
        const DropdownMenuItem(
          value: 'no_locations',
          enabled: false,
          child: Text(
            'No saved locations',
            style: TextStyle(color: Colors.red),
          ),
        ),
      );
    } else {
      dropdownItems.addAll(
        savedLocations.map(
          (location) => DropdownMenuItem<String>(
            value: location,
            child: Text(location, style: const TextStyle(fontSize: 18)),
          ),
        ),
      );
    }
    dropdownItems.add(
      const DropdownMenuItem(
        value: 'add_location',
        child: Text('+ Add new location', style: TextStyle(fontSize: 18)),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF2196F3),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, size: 36, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Location',
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
              children: [
                const Text(
                  'Where will the game be played?',
                  style: TextStyle(fontSize: 18),
                  textAlign: TextAlign.center,
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
                    hintText: 'Select Location',
                    hintStyle: TextStyle(color: Colors.grey),
                  ),
                  value: selectedLocation,
                  onChanged: (String? newValue) async {
                    print('Selected location: $newValue');
                    if (newValue == 'add_location') {
                      final result = await Navigator.pushNamed(
                        context,
                        '/add_new_location',
                        arguments: scheduleName,
                      );
                      if (result != null && result is String) {
                        setState(() {
                          savedLocations.add(result);
                          selectedLocation = result;
                        });
                      }
                    } else {
                      setState(() => selectedLocation = newValue);
                    }
                  },
                  items: dropdownItems,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    print(
                      'Continue pressed with location: $selectedLocation for schedule: $scheduleName',
                    );
                    if (selectedLocation != null &&
                        selectedLocation != 'no_locations' &&
                        selectedLocation != 'add_location') {
                      // TODO: Navigate to next screen (e.g., DateTime) when implemented
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Next screen not implemented yet'),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please select a valid location'),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2196F3),
                    side: const BorderSide(color: Colors.black, width: 2),
                    minimumSize: const Size(250, 50),
                  ),
                  child: const Text(
                    'Continue',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
