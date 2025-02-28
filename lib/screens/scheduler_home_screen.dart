import 'package:flutter/material.dart';

class SchedulerHomeScreen extends StatelessWidget {
  const SchedulerHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF2196F3), // Blue color from PDF
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text('Menu tapped')));
          },
        ),
        actions: [
          Stack(
            alignment: Alignment.topRight,
            children: [
              IconButton(
                icon: const Icon(Icons.monetization_on),
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
      body: Stack(
        children: [
          const Center(
            child: Text(
              'Press the "+" icon to schedule your first game.',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          Positioned(
            bottom: 80,
            right: 16,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey),
              ),
              child: const Text(
                'Click the ➕ icon to get started!',
                style: TextStyle(fontSize: 14),
              ),
            ),
          ),
          Positioned(
            bottom: 70,
            right: 50,
            child: CustomPaint(
              painter: ArrowPainter(),
              size: const Size(20, 20),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF2196F3), // Blue color from PDF
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CreateGameScreen()),
          );
        },
        child: const Icon(
          Icons.add,
          color: Colors.white, // White "+" icon
        ),
      ),
    );
  }
}

class ArrowPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = Colors.grey
          ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(size.width / 2, 0);
    path.lineTo(0, size.height);
    path.lineTo(size.width, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class CreateGameScreen extends StatefulWidget {
  const CreateGameScreen({super.key});

  @override
  State<CreateGameScreen> createState() => _CreateGameScreenState();
}

class _CreateGameScreenState extends State<CreateGameScreen> {
  String? _selectedSport;
  bool _isDefaultChoice = false;

  final List<String> _sports = [
    'Baseball',
    'Basketball',
    'Football',
    'Softball',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select Sport')),
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
                  'Select Sport',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                DropdownButton<String>(
                  value: _selectedSport,
                  hint: const Text('Select Sport'),
                  isExpanded: true,
                  items:
                      _sports.map((sport) {
                        return DropdownMenuItem<String>(
                          value: sport,
                          child: Text(sport),
                        );
                      }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedSport = value;
                    });
                  },
                ),
                const SizedBox(height: 20),
                CheckboxListTile(
                  title: const Text('Make this my default choice'),
                  value: _isDefaultChoice,
                  onChanged: (value) {
                    setState(() {
                      _isDefaultChoice = value ?? false;
                    });
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed:
                      _selectedSport == null
                          ? null
                          : () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Sport: $_selectedSport\nDefault: $_isDefaultChoice',
                                ),
                              ),
                            );
                          },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
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
