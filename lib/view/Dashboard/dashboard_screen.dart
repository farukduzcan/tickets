import 'package:flutter/material.dart';
import 'package:tickets/view/Dashboard/components/body.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: DashboardBody(),
    );
  }
}
