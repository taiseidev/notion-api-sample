import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final storeKey = 'counter';

final textProvider =
    Provider<String>((ref) => 'You have pushed the button this many times');
final titleProvider = Provider<String>((ref) => 'Riverpod sample');
final countProvider = StateProvider<int>((ref) => 0);

final countStateNotifier = StateNotifierProvider((ref) => CounterNotifier());

class CounterNotifier extends StateNotifier<int> {
  CounterNotifier() : super(0);

  void incrementCount() {
    state++;
  }
}

final futureProvider = FutureProvider<int>((ref) async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getInt(storeKey) ?? 0;
});
