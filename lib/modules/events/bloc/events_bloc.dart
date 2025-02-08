import 'package:kraken/modules/events/model/event_model.dart';
import 'package:rxdart/rxdart.dart';

class EventBloc {
  final BehaviorSubject<List<EventModel>> _eventSubject =
      BehaviorSubject<List<EventModel>>();

  Stream<List<EventModel>> get eventStream => _eventSubject.stream;

  void loadData() {
    _eventSubject.sink.add([
      EventModel(
        content: "Have started your study for OS Exam yet ? ",
        isCompleted: false,
        date: DateTime(2025, 2, 5),
      ),
      EventModel(
        content: "Hey you haven’t called your parents for last 2 days ? ",
        isCompleted: false,
        date: DateTime(2025, 2, 6),
      ),
      EventModel(
        content:
            "Lets keep your new habit going, its been 3 days since you did you guitar lessons.",
        isCompleted: false,
        date: DateTime(2025, 2, 7),
      ),
      EventModel(
        content: "You need to reconsider your workout schedule",
        isCompleted: false,
        date: DateTime(2025, 2, 8),
      ),
    ]);
  }

  void dispose() {
    _eventSubject.close();
  }
}
