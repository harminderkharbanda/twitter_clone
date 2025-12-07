import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

final normalProvider = Provider<String>((ref) {
  return "I am a normal provider";
});

final messageProvider = FutureProvider<String>((ref) async {
  return Future.delayed(const Duration(seconds: 5), () {
    return "Message from future";
  });
});

final counterProvider = StateNotifierProvider<CounterNotifier, int>((ref) {
    return CounterNotifier();
});

class CounterNotifier extends StateNotifier<int> {
  CounterNotifier() : super(0);

  void add() {
    state = state + 1;
  }

}
