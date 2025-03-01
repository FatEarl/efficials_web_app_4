import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'game_info.dart';

class AdditionalGameInfoScreen extends StatefulWidget {
  const AdditionalGameInfoScreen({super.key});

  @override
  State<AdditionalGameInfoScreen> createState() =>
      _AdditionalGameInfoScreenState();
}

class _AdditionalGameInfoScreenState extends State<AdditionalGameInfoScreen> {
  String? selectedLevel;
  String? selectedGender;
  final _officialsController = TextEditingController();
  final _feeController = TextEditingController();
  bool isFirstComeFirstServed = false;
  final levels = [
    'Grade School',
    'Middle School',
    'Underclass',
    'JV',
    'Varsity',
    'College',
    'Adult',
  ];
  final genders = ['Male', 'Female', 'Co-ed'];

  @override
  void dispose() {
    _officialsController.dispose();
    _feeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final gameInfo = ModalRoute.of(context)!.settings.arguments as GameInfo;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF2196F3),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, size: 36, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Additional Game Info',
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
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'Level of Competition',
                      labelStyle: TextStyle(color: Colors.black),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xFF2196F3),
                          width: 2,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xFF2196F3),
                          width: 2,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xFF2196F3),
                          width: 2,
                        ),
                      ),
                    ),
                    value: selectedLevel,
                    onChanged:
                        (newValue) => setState(() => selectedLevel = newValue),
                    items:
                        levels
                            .map(
                              (value) => DropdownMenuItem(
                                value: value,
                                child: Text(value),
                              ),
                            )
                            .toList(),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'Gender',
                      labelStyle: TextStyle(color: Colors.black),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xFF2196F3),
                          width: 2,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xFF2196F3),
                          width: 2,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xFF2196F3),
                          width: 2,
                        ),
                      ),
                    ),
                    value: selectedGender,
                    onChanged:
                        (newValue) => setState(() => selectedGender = newValue),
                    items:
                        genders
                            .map(
                              (value) => DropdownMenuItem(
                                value: value,
                                child: Text(value),
                              ),
                            )
                            .toList(),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _officialsController,
                    decoration: const InputDecoration(
                      labelText: 'Number of Officials Required',
                      labelStyle: TextStyle(color: Colors.black),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xFF2196F3),
                          width: 2,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xFF2196F3),
                          width: 2,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xFF2196F3),
                          width: 2,
                        ),
                      ),
                      hintText: 'Enter a number',
                    ),
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    onChanged: (value) {
                      if (value.isNotEmpty && int.tryParse(value) == null) {
                        _officialsController.text = value.replaceAll(
                          RegExp(r'[^0-9]'),
                          '',
                        );
                        _officialsController
                            .selection = TextSelection.fromPosition(
                          TextPosition(
                            offset: _officialsController.text.length,
                          ),
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _feeController,
                    decoration: const InputDecoration(
                      labelText: 'Game Fee Per Official',
                      labelStyle: TextStyle(color: Colors.black),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xFF2196F3),
                          width: 2,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xFF2196F3),
                          width: 2,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xFF2196F3),
                          width: 2,
                        ),
                      ),
                      hintText: 'Enter a number (e.g., 50)',
                    ),
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.done,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    onChanged: (value) {
                      if (value.isNotEmpty && int.tryParse(value) == null) {
                        _feeController.text = value.replaceAll(
                          RegExp(r'[^0-9]'),
                          '',
                        );
                        _feeController.selection = TextSelection.fromPosition(
                          TextPosition(offset: _feeController.text.length),
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Checkbox(
                        value: isFirstComeFirstServed,
                        onChanged:
                            (value) => setState(
                              () => isFirstComeFirstServed = value ?? false,
                            ),
                      ),
                      const Text(
                        'First come, first served',
                        style: TextStyle(fontSize: 18),
                      ),
                      IconButton(
                        icon: const Icon(Icons.help_outline, size: 24),
                        onPressed:
                            () => showDialog(
                              context: context,
                              builder:
                                  (context) => AlertDialog(
                                    title: const Text(
                                      'First Come, First Served vs. Wait and See',
                                      textAlign: TextAlign.center,
                                    ),
                                    content: const Text(
                                      'If "First Come, First Served" is checked, the first official(s) to indicate their availability will be hired immediately. The alternative is a "Wait and See" approach where the Scheduler will be given the opportunity to choose desired officials from a list of officials who have indicated they are available to work the game. A final confirmation is required from the selected officials before they are hired.',
                                      textAlign: TextAlign.justify,
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: const Text(
                                          'OK',
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      ),
                                    ],
                                  ),
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      if (selectedLevel != null &&
                          selectedGender != null &&
                          _officialsController.text.isNotEmpty &&
                          _feeController.text.isNotEmpty) {
                        final updatedGameInfo = GameInfo(
                          sport: gameInfo.sport,
                          scheduleName: gameInfo.scheduleName,
                          date: gameInfo.date,
                          time: gameInfo.time,
                          location: gameInfo.location,
                          officials: gameInfo.officials,
                          level: selectedLevel!,
                          gender: selectedGender!,
                          officialsRequired: int.parse(
                            _officialsController.text,
                          ),
                          feePerOfficial: int.parse(_feeController.text),
                          isFirstComeFirstServed: isFirstComeFirstServed,
                        );
                        Navigator.pushNamed(
                          context,
                          '/select_officials_list',
                          arguments: updatedGameInfo,
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Please fill in all fields!'),
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
                      'Continue',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
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
