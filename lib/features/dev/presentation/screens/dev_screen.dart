import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ids_elder_rehab_app/core/constants/app_routes.dart';

// ==========================================
// 1. DEV SCREEN (Widget Testing Purpose Only. Should Not Be Used In Production)
// ==========================================
class DevScreen extends StatefulWidget {
  const DevScreen({super.key});

  @override
  State<DevScreen> createState() => _DevScreenState();
}

class _DevScreenState extends State<DevScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Widget Testing Screen\n(Developer Only)'),
        actions: [
          IconButton(
            icon: const Icon(Icons.arrow_forward),
            onPressed: () => context.go(AppRoutes.onboarding.path),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Center(
              child: Text(
                'This screen is only for developer to test their widgets. Do any testing here, edit this screen as you wish but please do not use this screen in production.',
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
