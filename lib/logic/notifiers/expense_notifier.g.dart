// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expense_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$currentMonthExpensesHash() =>
    r'6b85659443803df286d198eaf197ade0b4642b3e';

/// See also [currentMonthExpenses].
@ProviderFor(currentMonthExpenses)
final currentMonthExpensesProvider =
    AutoDisposeProvider<List<Expense>>.internal(
  currentMonthExpenses,
  name: r'currentMonthExpensesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$currentMonthExpensesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef CurrentMonthExpensesRef = AutoDisposeProviderRef<List<Expense>>;
String _$expenseNotifierHash() => r'7db5917244bc67b7409a0d0a63bbe0e00dfbaea3';

/// See also [ExpenseNotifier].
@ProviderFor(ExpenseNotifier)
final expenseNotifierProvider =
    AutoDisposeNotifierProvider<ExpenseNotifier, List<Expense>>.internal(
  ExpenseNotifier.new,
  name: r'expenseNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$expenseNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ExpenseNotifier = AutoDisposeNotifier<List<Expense>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
