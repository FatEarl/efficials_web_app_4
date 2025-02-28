import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'game_info.dart';

class AdditionalGameInfoScreen extends StatelessWidget {
  const AdditionalGameInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final gameInfo = ModalRoute.of(context)!.settings.arguments as GameInfo;
    final formattedDate = DateFormat('EEEE, MMM d, yyyy').format(gameInfo.date);
    final formattedTime = gameInfo.time.format(context);

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
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '$formattedDate\n$formattedTime - ${gameInfo.scheduleName}\n${gameInfo.officials.length}/${gameInfo.officials.length} Official(s)',
                  style: const TextStyle(fontSize: 18),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed:
                      () => ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Next step TBD')),
                      ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2196F3),
                    side: const BorderSide(color: Colors.black, width: 2),
                    minimumSize: const Size(250, 70),
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
