import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notion_api_sample/providers/providers.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(
    const ProviderScope(
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final text = ref.watch(textProvider);
    final title = ref.watch(titleProvider);
    final count = ref.watch(countProvider);
    final state = ref.watch(countStateNotifier);
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(text),
            ref.watch(futureProvider).when(
                  data: (data) => Text(data.toString()),
                  error: (error, stack) => Text(error.toString()),
                  loading: () => const CircularProgressIndicator(),
                )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final prefs = await SharedPreferences.getInstance();
          int currentCounter = prefs.getInt('counter') ?? 0;
          prefs.setInt('counter', currentCounter + 1);
          ref.refresh(futureProvider);
        },
      ),
    );
  }
}
