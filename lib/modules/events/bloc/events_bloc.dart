import 'package:collection/collection.dart';
import 'package:kraken/modules/events/model/event_model.dart';
import 'package:kraken/utils/network/exception_handler.dart';
import 'package:kraken/utils/network/network_requester.dart';
import 'package:rxdart/rxdart.dart';

class EventBloc {
  // EventBloc._() {
  //   loadData();
  // }
  //
  // factory EventBloc() => _instance ??= EventBloc._();
  //
  // static EventBloc? _instance;

  final BehaviorSubject<List<EventModel>> _eventSubject =
      BehaviorSubject<List<EventModel>>();

  Stream<List<EventModel>> get eventStream => _eventSubject.stream;

  final NetworkRequester _networkRequester = NetworkRequester.instance;

  List<EventModel> _eventList = [];

  Future<void> loadData() async {
    final result = await hitApi();
    if (result != null) {
      _eventList = result;
    } else {
      _eventList = [];
      for (Map<String, dynamic> e in mockEventData) {
        _eventList.add(EventModel.fromJson(e));
      }
    }
    _eventList.sortBy((element) => element.date);
    _eventSubject.sink.add(_eventList.reversed.toList());
  }

  Future<List<EventModel>?> hitApi() async {
    var response = await _networkRequester.post(path: "/events", data: {
      "current_timestamp": "2025-02-02 00:00:00",
    });
    if (response is! APIException) {
      List<EventModel> events = [];
      for (Map<String, dynamic> e in (response.data as List)) {
        events.add(EventModel.fromJson(e));
      }
      return events;
    }
    return null;
  }
}

List<Map<String, dynamic>> mockEventData = [
  {
    "date": "2025-02-02 00:00:00",
    "content": "You need to start focusing on your OS exam prep."
  },
  {
    "date": "2025-02-03 00:00:00",
    "content":
        "Another missed guitar lesson notification. Are you still attending?"
  },
  {
    "date": "2025-02-04 00:00:00",
    "content":
        "You skipped the gym again today. Consider a short workout tomorrow."
  },
  {
    "date": "2025-02-05 00:00:00",
    "content":
        "Your project deadline is getting closer. Time to finalize things."
  },
  {
    "date": "2025-02-06 00:00:00",
    "content":
        "You haven’t called your parents in a while. Maybe check in with them?"
  },
  {
    "date": "2025-02-07 00:00:00",
    "content":
        "FIFA night was fun, but now you’re falling behind on your studies."
  },
  {
    "date": "2025-02-08 00:00:00",
    "content": "Only a few days left before the OS exam. Time to focus!"
  },
];
