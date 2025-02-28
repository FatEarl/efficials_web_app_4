import 'package:flutter/material.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key});

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  String? selectedLocation;
  final List<String> savedLocations = [];

  @override
  Widget build(BuildContext context) {
    final scheduleName = ModalRoute.of(context)!.settings.arguments as String;

    var dropdownItems =
        savedLocations.isEmpty
            ? [
              const DropdownMenuItem(
                value: 'no_locations',
                enabled: false,
                child: Text(
                  'No saved locations',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ]
            : savedLocations
                .map(
                  (location) => DropdownMenuItem<String>(
                    value: location,
                    child: Text(location, style: const TextStyle(fontSize: 18)),
                  ),
                )
                .toList();
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
                onPressed:
                    () => ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(const SnackBar(content: Text('Tokens: 1'))),
              ),
              const Positioned(
                right: 8,
                top: 8,
                child: CircleAvatar(
                  radius: 8,
                  backgroundColor: Colors.red,
                  child: Text(
                    '1',
                    style: TextStyle(color: Colors.white, fontSize: 10),
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
            padding: const EdgeInsets.all(16),
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
                      borderSide: BorderSide(color: Colors.blue, width: 2),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue, width: 2),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue, width: 2),
                    ),
                    hintText: 'Select Location',
                    hintStyle: TextStyle(color: Colors.grey),
                  ),
                  value: selectedLocation,
                  onChanged: (newValue) async {
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
                      Navigator.pushNamed(
                        context,
                        '/date_time',
                        arguments: scheduleName,
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
