import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:saveflow/logic/notifiers/settings_notifier.dart';
import 'package:saveflow/presentation/screens/dashboard/dashboard_screen.dart';

class SetupScreen extends ConsumerStatefulWidget {
  const SetupScreen({super.key});

  @override
  ConsumerState<SetupScreen> createState() => _SetupScreenState();
}

class _SetupScreenState extends ConsumerState<SetupScreen> {
  final TextEditingController _budgetController = TextEditingController(text: '1000');
  int _selectedDay = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(Icons.savings_outlined, size: 80, color: Color(0xFF00796B)),
              const Gap(24),
              Text(
                'Welcome to SaveFlow',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                textAlign: TextAlign.center,
              ),
              const Gap(16),
              Text(
                'Let\'s set up your monthly budget to get started.',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.black54,
                    ),
                textAlign: TextAlign.center,
              ),
              const Gap(40),
              TextField(
                controller: _budgetController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Monthly Budget',
                  prefixText: '₹ ',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const Gap(24),
              Text(
                'Month Start Day',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const Gap(8),
              DropdownButtonFormField<int>(
                value: _selectedDay,
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                items: List.generate(28, (index) => index + 1)
                    .map((day) => DropdownMenuItem(
                          value: day,
                          child: Text('Day $day'),
                        ))
                    .toList(),
                onChanged: (val) {
                  setState(() {
                    _selectedDay = val!;
                  });
                },
              ),
              const Spacer(),
              FilledButton(
                onPressed: _onStart,
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Start Tracking', style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _onStart() async {
    final budget = double.tryParse(_budgetController.text) ?? 1000.0;
    
    // Update settings
    final notifier = ref.read(settingsNotifierProvider.notifier);
    await notifier.updateBudget(budget);
    await notifier.updateMonthStartDay(_selectedDay);
    
    // Initialize lastOpenedMonth to NOW to mark setup as complete
    final now = DateTime.now();
    await notifier.updateLastOpenedMonth(DateFormat('yyyy-MM').format(now));

    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const DashboardScreen()),
      );
    }
  }
}
