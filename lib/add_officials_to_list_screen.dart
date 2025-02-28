import 'package:flutter/material.dart';

class AddOfficialsToListScreen extends StatefulWidget {
  const AddOfficialsToListScreen({super.key});

  @override
  _AddOfficialsToListScreenState createState() =>
      _AddOfficialsToListScreenState();
}

class _AddOfficialsToListScreenState extends State<AddOfficialsToListScreen> {
  final List<String> availableOfficials = [
    'Tim Pollard',
    'Randy Evans',
    'Greg Corker',
    'Lanny Miller',
    'Brandon Street',
    'Barry Bohm',
    'Mike Rollins',
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
          'Add Officials to List',
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
                CheckboxListTile(
                  title: const Text(
                    'Select all (73) in results',
                    style: TextStyle(fontSize: 18),
                  ),
                  value: selectedOfficials.every((selected) => selected),
                  onChanged: (bool? value) {
                    setState(() {
                      for (int i = 0; i < selectedOfficials.length; i++) {
                        selectedOfficials[i] = value ?? false;
                      }
                      print('Select all changed to: $value');
                    });
                  },
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: availableOfficials.length,
                    itemBuilder: (context, index) {
                      return CheckboxListTile(
                        title: Text(
                          availableOfficials[index],
                          style: const TextStyle(fontSize: 18),
                        ),
                        value: selectedOfficials[index],
                        onChanged: (bool? value) {
                          setState(() {
                            selectedOfficials[index] = value ?? false;
                            print(
                              'Selected official: ${availableOfficials[index]} - $value',
                            );
                          });
                        },
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      '(${selectedOfficials.where((selected) => selected).length}) Selected',
                      style: const TextStyle(fontSize: 18),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        final selected =
                            availableOfficials
                                .asMap()
                                .entries
                                .where((entry) => selectedOfficials[entry.key])
                                .map((entry) => entry.value)
                                .toList();
                        print(
                          'Continuing with selected officials for schedule: $scheduleName - $selected',
                        );
                        Navigator.pop(context, selected);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2196F3),
                        side: const BorderSide(color: Colors.black, width: 2),
                        minimumSize: const Size(250, 50),
                      ),
                      child: const Text(
                        'Continue',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
