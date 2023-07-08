import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

class ControllerNotifier extends AsyncNotifier<List<String>> {
  @override
  FutureOr<List<String>> build() async {
    return [for (int i = 1; i <= 10; i++) i.toString()];
  }

  void addData({required int currentPage}) async {
    state = const AsyncLoading();
    await Future.delayed(const Duration(seconds: 2));
    for (int i = int.parse(state.value!.last) + 1; i <= currentPage * 10; i++) {
      state.value!.add(i.toString());
    }
    state = AsyncData(state.value!);
  }
}

final controllerProvider =
    AsyncNotifierProvider<ControllerNotifier, List<String>>(
        ControllerNotifier.new);
