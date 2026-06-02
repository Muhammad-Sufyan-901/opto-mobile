import 'package:flutter/material.dart';

import '../widgets/dashboard_bottom_tab_bar.dart';
import '../widgets/dashboard_header.dart';
import '../widgets/recovery_progress_card.dart';

class LansiaDashboardScreen extends StatefulWidget {
  const LansiaDashboardScreen({super.key});

  @override
  State<LansiaDashboardScreen> createState() => _LansiaDashboardScreenState();
}

class _LansiaDashboardScreenState extends State<LansiaDashboardScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true, 
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Stack(
        children: [
          const DashboardHeaderBackground(),
          
          SafeArea(
            bottom: false,
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 120),
              child: Column(
                children: [
                  const DashboardHeaderContent(), 
                  const SizedBox(height: 32),
                  
                  if (_currentIndex == 0) ...[
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24.0),
                      child: RecoveryProgressCard(),
                    ),
                    const SizedBox(height: 24),
                  ],
                  if (_currentIndex == 2) ...[
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 40),
                      child: Center(child: Text("Profile Page")),
                    ),
                  ]
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: DashboardBottomTabBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          if (index == 1) {
            // Placeholder for exercise button action
             ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Buka Menu Latihan')),
            );
          } else {
            setState(() => _currentIndex = index);
          }
        },
      ),
    );
  }
}
