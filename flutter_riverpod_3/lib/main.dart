import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CounterNotifier extends StateNotifier<AsyncValue<int>> {
  CounterNotifier() : super(const AsyncData(0));

  void increment(int value) async {
    state = const AsyncLoading();
    await Future.delayed(const Duration(seconds: 2));
    state = AsyncData(value + 1);
  }

  void decrement(int value) async {
    state = const AsyncLoading();
    await Future.delayed(const Duration(seconds: 2));
    state = AsyncData(value - 1);
  }

  //void decrement() => state--;
}

final counterProvider = StateNotifierProvider<CounterNotifier, AsyncValue<int>>(
    (ref) => CounterNotifier());
main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends ConsumerWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AsyncValue<int> _counter = ref.watch(counterProvider);
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _counter.when(
              data: (data) => Text(
                _counter.value.toString(),
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              loading: () => const CircularProgressIndicator(),
              error: (error, stack) => const Text('Error'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
                onPressed: () {
                  ref.read(counterProvider.notifier).increment(_counter.value!);
                },
                child: const Text('+')),
            ElevatedButton(
                onPressed: () {
                  ref.read(counterProvider.notifier).decrement(_counter.value!);
                },
                child: const Text('_')),
          ],
        ),
      ),
    );
  }
}
