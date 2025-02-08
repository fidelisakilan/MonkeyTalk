import 'package:kraken/modules/journal/model/journal_model.dart';
import 'package:rxdart/rxdart.dart';

class JournalBloc {
  final BehaviorSubject<List<JournalModel>> _journalSubject =
      BehaviorSubject<List<JournalModel>>();

  Stream<List<JournalModel>> get journalStream => _journalSubject.stream;

  void loadData() {
    _journalSubject.sink.add([
      JournalModel(
        emote: "🎯",
        title: "Started Exam Prep",
        content: "",
        date: DateTime(2025, 2, 5),
      ),
      JournalModel(
        emote: "😩",
        title: "Feeling Sick",
        content: "",
        date: DateTime(2025, 2, 6),
      ),
      JournalModel(
        emote: "😡",
        title: "Feeling Bad Again",
        content: "",
        date: DateTime(2025, 2, 7),
      ),
      JournalModel(
        emote: "😁",
        title: "Met new friends at Hackathon",
        content: """
Hey, today was a **mess**. I barely managed to wake up on time and rushed to class with just **coffee** in my system.  
Advanced Machine Learning was **tough**—ensemble learning went right over my head. I really need to go over my notes,  
but I doubt I’ll have the time.

I tried working on my **research project** after class, but my **dataset is a disaster**. Spent ages debugging  
and still didn’t make much progress. I should have gone to **office hours**, but, of course, I got distracted scrolling on my phone.

### **Small Wins & Distractions**
- Lunch was fun! Caught up with **friends** at the cafeteria, and someone mentioned a **hackathon** next month.  
  Sounds cool, but I barely have time for coursework, let alone extra projects.  
- Back home, I cooked something quick—**rice and lentils**. Honestly, it made me **miss home**.  
  My mom’s cooking is on a whole other level.  
- Checked my **emails** while eating, and, guess what? **Another internship rejection**.  
  I should apply to more, but I just feel so drained.  

### **Catching Up & Feeling Overwhelmed**
Called my **parents** before bed. They worry about me a lot, and I wish I could tell them I have everything under control.  
But I **don’t**. Maybe tomorrow will be better.
        """,
        date: DateTime(2025, 2, 8),
      ),
    ]);
  }

  void dispose() {
    _journalSubject.close();
  }
}
