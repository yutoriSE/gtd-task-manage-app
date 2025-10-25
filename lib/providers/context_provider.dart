import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../models/context.dart';
import '../services/storage_service.dart';

class ContextNotifier extends StateNotifier<List<GTDContext>> {
  ContextNotifier() : super([]) {
    loadContexts();
  }

  void loadContexts() {
    state = StorageService.getAllContexts();
  }

  Future<void> addContext(GTDContext context) async {
    await StorageService.saveContext(context);
    state = [...state, context];
  }

  Future<void> updateContext(GTDContext context) async {
    await StorageService.saveContext(context);
    state = [
      for (final c in state)
        if (c.id == context.id) context else c,
    ];
  }

  Future<void> deleteContext(String contextId) async {
    await StorageService.deleteContext(contextId);
    state = state.where((context) => context.id != contextId).toList();
  }

  Future<void> createContext(String name, {String? icon, String? color}) async {
    final context = GTDContext(
      id: const Uuid().v4(),
      name: name,
      icon: icon,
      color: color,
    );
    await addContext(context);
  }
}

final contextProvider = StateNotifierProvider<ContextNotifier, List<GTDContext>>((ref) {
  return ContextNotifier();
});
