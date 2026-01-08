import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:saveflow/logic/notifiers/settings_notifier.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  late TextEditingController _budgetController;

  @override
  void initState() {
    super.initState();
    final settings = ref.read(settingsNotifierProvider);
    _budgetController = TextEditingController(text: settings.monthlyLimit.toStringAsFixed(0));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Monthly Budget', style: Theme.of(context).textTheme.titleMedium),
            const Gap(8),
            Text(
              'Changes will apply from the next month unless you force an update.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey),
            ),
            const Gap(16),
            TextField(
              controller: _budgetController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                prefixText: '₹ ',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const Gap(24),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () async {
                  final newBudget = double.tryParse(_budgetController.text);
                  if (newBudget != null) {
                    await ref.read(settingsNotifierProvider.notifier).updateBudget(newBudget);
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Budget updated successfully')),
                      );
                      Navigator.pop(context);
                    }
                  }
                },
                child: const Text('Save Changes'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
