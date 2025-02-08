import 'package:kraken/config.dart';
import 'package:kraken/modules/recorder/bloc/speech_manager.dart';
import 'package:kraken/utils/dimensions.dart';

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
    print("Hellow");
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
                        shape: CircleBorder(),
                        backgroundColor: context.colorScheme.tertiaryContainer,
                        elevation: 0,
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
    );
  }
}
