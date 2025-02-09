import 'package:collection/collection.dart';
import 'package:kraken/config.dart';
import 'package:kraken/modules/journal/model/journal_model.dart';
import 'package:kraken/utils/network/exception_handler.dart';
import 'package:kraken/utils/network/network_requester.dart';
import 'package:rxdart/rxdart.dart';

class JournalBloc {
  JournalBloc._();

  factory JournalBloc() => _instance ??= JournalBloc._();

  static JournalBloc? _instance;

  final BehaviorSubject<List<JournalModel>> _journalSubject =
      BehaviorSubject<List<JournalModel>>();

  Stream<List<JournalModel>> get journalStream => _journalSubject.stream;

  final NetworkRequester _networkRequester = NetworkRequester.instance;

  List<JournalModel> _journalList = [];

  Future<void> loadData() async {
    final result = await hitJournalApi();
    if (result != null) {
      _journalList = result;
    } else {
      _journalList = [];
      for (Map<String, dynamic> e in mockJournalData) {
        _journalList.add(JournalModel.fromJson(e));
      }
    }
    _journalList.sortBy((element) => element.date);
    _journalSubject.sink.add(_journalList.reversed.toList());
  }

  Future<List<JournalModel>?> hitJournalApi() async {
    var response = await _networkRequester.post(path: "/journal", data: {});
    if (response is! APIException) {
      List<JournalModel> journals = [];
      for (Map<String, dynamic> e in (response.data as List)) {
        journals.add(JournalModel.fromJson(e));
      }
      return journals;
    }
    return null;
  }

  Future<bool> hitRecordingContentApi(String content) async {
    var response = await _networkRequester.post(
      path: "/send-content",
      data: {
        "date": DateTime.now().toString(),
        "content": content,
      },
    );
    return response is! Exception;
  }

  JournalModel? searchJournal(DateTime date) {
    for (var element in _journalList) {
      if (element.date.formattedText == date.formattedText) {
        return element;
      }
    }
    return null;
  }
}

List<Map<String, dynamic>> mockJournalData = [
  {
    "title": "The Weekend Study Struggle",
    "date": "2025-02-02 00:00:00",
    "emote": "😩",
    "content":
        "Woke up exhausted after another late night. I keep telling myself I'll sleep early, but it never happens. Quick breakfast—coffee and a granola bar, my usual. While walking to class, I realized I haven't worked out all week. Kept telling myself I'd go tomorrow, but let's be real. OS lecture was overwhelming, and I barely processed half of it. My break time was supposed to be for studying, but I ended up scrolling my phone instead.\n\nLunch was chill, but my friends were talking about FIFA night. I realized I haven’t played in forever. Library session was meant to be productive, but distractions won. Group project meeting reminded me of how much work we still have left. Got another email about my missed guitar lesson—should I just cancel at this point?\n\nEvening was another struggle. I planned to hit the gym, but I convinced myself I was too tired. Instead, I made instant noodles for dinner, tried studying, and ended up watching random YouTube videos. Finally, I caved and joined FIFA night. It was fun, but now I regret the time lost. The cycle continues."
  },
  {
    "title": "Skipped Gym Again",
    "date": "2025-02-03 00:00:00",
    "emote": "😔",
    "content":
        "Woke up late—again. At this point, my sleep schedule is beyond saving. Grabbed coffee and a bagel and sat down to study OS, but my brain wasn’t in the mood. By mid-morning, I took a break and *thought* about going to the gym. Didn’t happen. Instead, I wasted time on social media.\n\nLunch was another simple dorm meal—sandwich and chips. I had a group project check-in, and everyone is just as stressed as me, which made me feel slightly better. The rest of the afternoon was mostly filled with studying, though I wasn’t as productive as I wanted to be. My parents texted me, and I ignored it for a bit. Not intentionally, I just didn't have the energy to talk. \n\nBy the evening, I ordered food with my roommate because I was too lazy to cook. That gave me a second wind, and I finally managed to get some studying done. The guilt from wasting time earlier in the day hit hard, but at least I ended on a somewhat productive note."
  },
  {
    "title": "Study Guilt Kicking In",
    "date": "2025-02-04 00:00:00",
    "emote": "📚",
    "content":
        "Another late wake-up. I told myself I’d start early, but I just couldn't get out of bed. First thing I did was grab coffee and start reviewing my OS notes. The exam is getting closer, and I still don’t feel ready. \n\nTook a break around noon and *considered* a quick workout. Didn't happen. Instead, I stayed in my room, had a basic lunch, and kept working on OS problems. Group project meeting took up part of the afternoon—nothing new, just more reminders of how much we still have to do. Finally replied to my parents, just a simple 'Busy with school.'\n\nEvening was more studying, but I hit a wall. Ordered food again because I wasn’t in the mood to cook. After dinner, I tried studying one last time, but my focus was completely gone. Ended up wasting time on my phone instead. I have way too much to do, and I feel like I wasted another day."
  },
  {
    "title": "Productivity at an All-Time Low",
    "date": "2025-02-05 00:00:00",
    "emote": "🤯",
    "content":
        "Woke up groggy, snoozed my alarm too many times. Barely had time for breakfast before running to class. OS lecture hit me hard—surprise quiz, and I was *not* ready. My break was supposed to be for studying, but I ended up scrolling my phone instead.\n\nLunch was fun, but my classmates were talking about FIFA night later this week, and I already feel like I won’t have time for it. Library session was meant to be productive, but distractions won again. Group project meeting added more stress. Skipped the gym *again* because I convinced myself I was too busy. \n\nBy evening, I microwaved some mac & cheese, struggled through debugging a CS assignment, and half-heartedly tried to study. Finally called my parents after putting it off for a while—they could hear the exhaustion in my voice. Ended the night watching a couple of episodes of a show with my roommate. Probably not the best use of time, but I needed a break."
  },
  {
    "title": "Too Much To Do, Too Little Time",
    "date": "2025-02-06 00:00:00",
    "emote": "⏳",
    "content":
        "Started the day feeling behind. OS exam stress is kicking in. Grabbed a quick breakfast while checking my emails—another reminder about the exam. Class was a blur, and I barely retained anything. Planned to review notes during my break, but my phone won again.\n\nLunch was mostly listening to friends talk about their weekend plans while I internally panicked about my workload. Library session started okay, but I got distracted halfway through. Group project meeting was chaotic, and now we have more work than before.\n\nEvening was filled with OS revision. My parents texted me again—I haven’t called in a while. I need to stop ignoring them. Skipped FIFA night even though I wanted to go. Feeling a little burnt out."
  },
  {
    "title": "FIFA Night Regrets",
    "date": "2025-02-07 00:00:00",
    "emote": "🎮",
    "content":
        "Woke up exhausted. Definitely feeling the weight of the week now. OS lecture was full of exam prep, and I realized just how *not* ready I am. Tried studying in the library, but focus wasn’t there. \n\nGot another email about my missed guitar lesson. At this point, I might as well just stop pretending I’m attending. By evening, I was supposed to study, but my friends convinced me to play FIFA instead. I caved, and it was fun… but now I’m behind. Again."
  },
  {
    "title": "Exam Stress is Real",
    "date": "2025-02-08 00:00:00",
    "emote": "😵‍💫",
    "content":
        "Only a few days left before the OS exam, and my stress levels are at an all-time high. Woke up tired, skipped a proper breakfast, and barely survived through my morning classes. Spent most of my breaks trying to study, but my brain wasn’t absorbing anything.\n\nAnother missed guitar lesson. I don’t even know why I’m still enrolled at this point. By evening, I was *supposed* to go to the gym, but I had zero motivation. Instead, I stared at my notes for a few hours, hoping information would magically stick.\n\nThe day ended with another OS study session, which wasn’t as productive as I needed it to be. Feeling the burnout creeping in hard."
  }
];
