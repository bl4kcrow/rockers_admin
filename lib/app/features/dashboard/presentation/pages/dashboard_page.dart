import 'package:flutter/material.dart';

import 'package:rockers_admin/app/core/theme/theme.dart';
import 'package:rockers_admin/app/features/dashboard/dashboard.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          const Sidebar(),
          const VerticalDivider(width: 0.0),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Dashboard',
                    style: heading2Style,
                  ),
                  const SizedBox(height: 30.0),
                  Expanded(
                    child: child,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
