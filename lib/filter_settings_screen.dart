import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FilterSettingsScreen extends StatefulWidget {
  const FilterSettingsScreen({super.key});

  @override
  State<FilterSettingsScreen> createState() => _FilterSettingsScreenState();
}

class _FilterSettingsScreenState extends State<FilterSettingsScreen> {
  bool ihsaRegistered = false;
  bool ihsaRecognized = false;
  bool ihsaCertified = false;
  final _yearsController = TextEditingController();
  final Map<String, bool> competitionLevels = {
    'Grade School': false,
    'Middle School': false,
    'Underclass': false,
    'JV': false,
    'Varsity': false,
    'College': false,
    'Adult': false,
  };
  final _zipCodeController = TextEditingController();
  final _radiusController = TextEditingController();

  @override
  void dispose() {
    _yearsController.dispose();
    _zipCodeController.dispose();
    _radiusController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final listName = ModalRoute.of(context)!.settings.arguments as String;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF2196F3),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, size: 36, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Filter Settings',
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'IHSA Certifications',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  CheckboxListTile(
                    title: const Text('IHSA - Registered',
                        style: TextStyle(fontSize: 18)),
                    value: ihsaRegistered,
                    onChanged: (value) =>
                        setState(() => ihsaRegistered = value ?? false),
                    controlAffinity: ListTileControlAffinity.leading,
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                    dense: true,
                  ),
                  CheckboxListTile(
                    title: const Text('IHSA - Recognized',
                        style: TextStyle(fontSize: 18)),
                    value: ihsaRecognized,
                    onChanged: (value) =>
                        setState(() => ihsaRecognized = value ?? false),
                    controlAffinity: ListTileControlAffinity.leading,
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                    dense: true,
                  ),
                  CheckboxListTile(
                    title: const Text('IHSA - Certified',
                        style: TextStyle(fontSize: 18)),
                    value: ihsaCertified,
                    onChanged: (value) =>
                        setState(() => ihsaCertified = value ?? false),
                    controlAffinity: ListTileControlAffinity.leading,
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                    dense: true,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Experience',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _yearsController,
                    decoration: const InputDecoration(
                      labelText: 'Minimum years of experience',
                      labelStyle: TextStyle(color: Colors.black),
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
                    ),
                    textAlign: TextAlign.left,
                    style: const TextStyle(fontSize: 18),
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    maxLength: 2,
                    buildCounter: (context,
                            {required currentLength,
                            required maxLength,
                            required isFocused}) =>
                        null,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Competition Levels',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Column(
                    children: competitionLevels.keys.map((level) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: CheckboxListTile(
                          title:
                              Text(level, style: const TextStyle(fontSize: 18)),
                          value: competitionLevels[level],
                          onChanged: (value) {
                            setState(() {
                              competitionLevels[level] = value ?? false;
                            });
                          },
                          controlAffinity: ListTileControlAffinity.leading,
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 0),
                          dense: true,
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Location',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _zipCodeController,
                    decoration: const InputDecoration(
                      labelText: 'Zip Code',
                      labelStyle: TextStyle(color: Colors.black),
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
                    ),
                    textAlign: TextAlign.left,
                    style: const TextStyle(fontSize: 18),
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    maxLength: 5,
                    buildCounter: (context,
                            {required currentLength,
                            required maxLength,
                            required isFocused}) =>
                        null,
                    contextMenuBuilder: (context, editableTextState) =>
                        const SizedBox.shrink(),
                    enableInteractiveSelection: false,
                    enableSuggestions: false,
                    autocorrect: false,
                    showCursor: true,
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _radiusController,
                    decoration: const InputDecoration(
                      labelText: 'Search Radius (miles)',
                      labelStyle: TextStyle(color: Colors.black),
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
                    ),
                    textAlign: TextAlign.left,
                    style: const TextStyle(fontSize: 18),
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.done,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    maxLength: 3,
                    buildCounter: (context,
                            {required currentLength,
                            required maxLength,
                            required isFocused}) =>
                        null,
                  ),
                  const SizedBox(height: 30),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        if (competitionLevels.values
                                .any((selected) => selected) &&
                            _zipCodeController.text.length == 5 &&
                            RegExp(r'^\d{5}$')
                                .hasMatch(_zipCodeController.text) &&
                            _radiusController.text.isNotEmpty) {
                          final selectedLevels = competitionLevels.entries
                              .where((entry) => entry.value)
                              .map((entry) => entry.key)
                              .toList();
                          Navigator.pop(context, {
                            'listName': listName,
                            'ihsaRegistered': ihsaRegistered,
                            'ihsaRecognized': ihsaRecognized,
                            'ihsaCertified': ihsaCertified,
                            'minYears': _yearsController.text.isNotEmpty
                                ? int.parse(_yearsController.text)
                                : 0,
                            'levels': selectedLevels,
                            'zipCode': _zipCodeController.text,
                            'radius': int.parse(_radiusController.text),
                          });
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Please select at least one competition level, enter a valid 5-digit zip code, and specify a search radius!',
                              ),
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2196F3),
                        side: const BorderSide(color: Colors.black, width: 2),
                        minimumSize: const Size(250, 70),
                      ),
                      child: const Text(
                        'Apply Filters',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
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
