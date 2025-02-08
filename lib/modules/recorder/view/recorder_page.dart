import 'package:kraken/config.dart';
import 'package:kraken/modules/events/view/events_page.dart';
import 'package:kraken/modules/journal/view/journal_page.dart';
import 'package:kraken/modules/recorder/bloc/speech_manager.dart';

class RecorderPage extends StatefulWidget {
  const RecorderPage({super.key});

  @override
  State<RecorderPage> createState() => _RecorderScreenState();
}

class _RecorderScreenState extends State<RecorderPage> {
  final speechManager = SpeechToTextManager();

  @override
  void dispose() {
    super.dispose();
    speechManager.dispose();
  }

  void startService() {
    speechManager.run(
      onResult: (String content) {
        print('content $content');
      },
      onFailure: (error) {
        print(error);
      },
      onComplete: () {},
    );
  }

  void stopService() {
    speechManager.stop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Recorder"),
        centerTitle: true,
        backgroundColor: context.colorScheme.primaryContainer,
      ),
      body: ValueListenableBuilder<bool>(
        valueListenable: speechManager.speechState,
        builder: (context, value, child) {
          return Stack(
            children: [
              Column(
                children: [
                  LinearProgressIndicator(
                    backgroundColor: Colors.transparent,
                    value: !value ? 0 : null,
                  ),
                  Expanded(
                    child: Center(
                      child: FloatingActionButton.large(
                        heroTag: 'voice',
                        backgroundColor: context.colorScheme.tertiaryContainer,
                        onPressed: !value ? startService : stopService,
                        child: Icon(
                          !value ? Icons.circle_outlined : Icons.pause,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ],
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FloatingActionButton.large(
            heroTag: 'events',
            onPressed: () {
              context.push(EventsPage());
            },
            child: const Icon(Icons.notifications),
          ),
          const GapBox(gap: Gap.s),
          FloatingActionButton.large(
            onPressed: () {
              context.push(JournalPage());
            },
            heroTag: 'journal',
            child: const Icon(Icons.book),
          ),
        ],
      ),
    );
  }
}
