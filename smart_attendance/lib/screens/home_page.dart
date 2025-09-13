import 'package:flutter/material.dart';
import '../widgets/top_header.dart';
import '../widgets/role_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key}); // added const constructor

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TopHeader(),
            const SizedBox(height: 18),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Welcome to',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'SmartAttend',
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge!
                        .copyWith(fontSize: 28), // updated from headline6
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Choose your role to continue',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: GridView.count(
                  crossAxisCount: 1,
                  childAspectRatio: 4,
                  mainAxisSpacing: 16,
                  children: [
                    RoleCard(
                      title: 'Student',
                      subtitle: 'Mark attendance & view your records',
                      icon: Icons.school,
                      cardColor: const Color(0xFFEFF6FF),
                      onTap: () => Navigator.pushNamed(context, '/student'),
                    ),
                    RoleCard(
                      title: 'Teacher',
                      subtitle: 'Start sessions & view class stats',
                      icon: Icons.person_search,
                      cardColor: const Color(0xFFF5F3FF),
                      onTap: () => Navigator.pushNamed(context, '/teacher'),
                    ),
                    RoleCard(
                      title: 'Administrator',
                      subtitle: 'Manage classes & users',
                      icon: Icons.admin_panel_settings,
                      cardColor: const Color(0xFFF0FDF4),
                      onTap: () => Navigator.pushNamed(context, '/admin'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 12),
              child: Text(
                'Version 0.1 • Demo',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
