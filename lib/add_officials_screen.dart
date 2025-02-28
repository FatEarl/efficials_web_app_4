import 'package:flutter/material.dart';

class AddOfficialsScreen extends StatefulWidget {
  const AddOfficialsScreen({super.key});

  @override
  _AddOfficialsScreenState createState() => _AddOfficialsScreenState();
}

class _AddOfficialsScreenState extends State<AddOfficialsScreen> {
  final List<String> officials = [
    'Chris Bunt',
    'Nathan Gray',
    'Steve Henry',
    'Jeremy Jones',
    'Tim Levinson',
    'Paul Opel',
    'Don Randolph',
  ];
  final List<bool> selectedOfficials = List<bool>.filled(7, false);

  @override
  Widget build(BuildContext context) {
    final String scheduleName =
        ModalRoute.of(context)!.settings.arguments as String;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF2196F3),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, size: 36, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Add Officials',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white, size: 36),
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
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: officials.length,
                    itemBuilder: (context, index) {
                      return CheckboxListTile(
                        title: Text(
                          officials[index],
                          style: const TextStyle(fontSize: 18),
                        ),
                        value: selectedOfficials[index],
                        onChanged: (bool? value) {
                          setState(() {
                            selectedOfficials[index] = value ?? false;
                            print(
                              'Selected official: ${officials[index]} - $value',
                            );
                          });
                        },
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    print(
                      'Navigating to AddOfficialsToListScreen for schedule: $scheduleName',
                    );
                    final result = await Navigator.pushNamed(
                      context,
                      '/add_officials_to_list',
                      arguments: scheduleName,
                    );
                    if (result != null && result is List<String>) {
                      setState(() {
                        officials.addAll(result);
                        selectedOfficials.addAll(
                          List<bool>.filled(result.length, true),
                        );
                        print('Added officials: $result');
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2196F3),
                    side: const BorderSide(color: Colors.black, width: 2),
                    minimumSize: const Size(250, 50),
                  ),
                  child: const Text(
                    'Add Officials',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    final selected =
                        officials
                            .asMap()
                            .entries
                            .where((entry) => selectedOfficials[entry.key])
                            .map((entry) => entry.value)
                            .toList();
                    print(
                      'Saving list for schedule: $scheduleName - Selected officials: $selected',
                    );
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2196F3),
                    side: const BorderSide(color: Colors.black, width: 2),
                    minimumSize: const Size(250, 50),
                  ),
                  child: const Text(
                    'Save List',
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
