import 'package:event_bus/event_bus.dart';

class EventBusManager {
  static late final EventBusManager instance = EventBusManager._internal();

  factory EventBusManager() => instance;

  late EventBus eventBus;

  EventBusManager._internal() {
    eventBus = EventBus();
  }

}
