import 'package:flutter/material.dart';
import 'package:efficials_web_app_4/select_sport_screen.dart';

class SchedulerHomeScreen extends StatefulWidget {
  const SchedulerHomeScreen({super.key});
  @override
  State<SchedulerHomeScreen> createState() => _SchedulerHomeScreenState();
}

class _SchedulerHomeScreenState extends State<SchedulerHomeScreen> {
  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    final double appBarHeight = kToolbarHeight;
    final double totalBannerHeight = statusBarHeight + appBarHeight;

    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
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
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            Container(
              height: totalBannerHeight,
              decoration: const BoxDecoration(color: Color(0xFF2196F3)),
              child: Padding(
                padding: EdgeInsets.only(
                  top: statusBarHeight + 8.0,
                  bottom: 8.0,
                  left: 16.0,
                  right: 16.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        const CircleAvatar(
                          radius: 24,
                          backgroundColor: Colors.white,
                          child: Icon(
                            Icons.person,
                            size: 28,
                            color: Color(0xFF2196F3),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Jason Unverzagt',
                          style: Theme.of(
                            context,
                          ).textTheme.titleLarge?.copyWith(color: Colors.white),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.edit,
                        color: Colors.white,
                        size: 22,
                      ),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Edit profile clicked')),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.calendar_today, size: 32),
              title: Text(
                'Schedules',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontSize: 20),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.drafts, size: 32),
              title: Text(
                'Unpublished Games',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontSize: 20),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.location_on, size: 32),
              title: Text(
                'Locations',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontSize: 20),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.list, size: 32),
              title: Text(
                'Lists of Officials',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontSize: 20),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.settings, size: 32),
              title: Text(
                'Settings',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontSize: 20),
              ),
            ),
          ],
        ),
      ),
      body: const Center(
        child: Text(
          'Press the "+" icon to schedule your first game.',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SelectSportScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
