import 'package:kraken/config.dart';
import 'package:kraken/modules/events/bloc/events_bloc.dart';
import 'package:kraken/modules/events/model/event_model.dart';
import 'package:kraken/modules/journal/bloc/journal_bloc.dart';
import 'package:kraken/modules/journal/view/content_page.dart';
import 'package:kraken/utils/widgets/loading_widget.dart';
import 'package:wave_divider/wave_divider.dart';

class EventsPage extends StatefulWidget {
  const EventsPage({super.key});

  @override
  State<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  final EventBloc _bloc = EventBloc();

  @override
  void initState() {
    super.initState();
    _bloc.loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Reminders"),
        backgroundColor: context.colorScheme.primaryContainer,
      ),
      body: StreamBuilder<List<EventModel>>(
        stream: _bloc.eventStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Column(
              mainAxisSize: MainAxisSize.min,
              children: [LoadingWidget()],
            );
          }
          return ListView.separated(
            itemCount: snapshot.data!.length,
            separatorBuilder: (context, index) {
              return WaveDivider();
            },
            itemBuilder: (context, index) {
              final event = snapshot.data![index];
              return Column(
                children: [
                  ListTile(
                    shape: const Border(),
                    subtitle: Row(
                      children: [
                        Text(
                          "From ${event.date.formattedText}",
                          style: context.textTheme.bodySmall,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                    title: Text(
                      event.content,
                      style: context.textTheme.titleSmall,
                      maxLines: 5,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.open_in_new),
                          onPressed: () {
                            final journal =
                                JournalBloc().searchJournal(event.date);
                            if (journal != null) {
                              context.push(ContentPage(journal: journal));
                            }
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.fiber_smart_record),
                          onPressed: () {
                            context.pop();
                          },
                        ),
                      ],
                    ),
                  ),
                  if (index == snapshot.data!.length - 1) WaveDivider(),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
