import 'package:kraken/config.dart';
import 'package:kraken/modules/journal/bloc/journal_bloc.dart';
import 'package:kraken/modules/journal/model/journal_model.dart';
import 'package:kraken/modules/journal/view/content_page.dart';
import 'package:kraken/utils/widgets/loading_widget.dart';

class JournalPage extends StatefulWidget {
  const JournalPage({super.key});

  @override
  State<JournalPage> createState() => _JournalPageState();
}

class _JournalPageState extends State<JournalPage> {
  final JournalBloc _bloc = JournalBloc();

  @override
  void initState() {
    super.initState();
    _bloc.loadData();
  }

  @override
  void dispose() {
    super.dispose();
    _bloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Journal"),
        backgroundColor: context.colorScheme.primaryContainer,
      ),
      body: StreamBuilder<List<JournalModel>>(
        stream: _bloc.journalStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Column(
              mainAxisSize: MainAxisSize.min,
              children: [LoadingWidget()],
            );
          }
          return GridView.builder(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            itemCount: snapshot.data!.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1,
              crossAxisSpacing: 5,
              mainAxisSpacing: 5,
            ),
            itemBuilder: (context, index) {
              final journal = snapshot.data![index];
              return GestureDetector(
                onTap: () {
                  context.push(ContentPage(journal: journal));
                },
                child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: context.colorScheme.surfaceContainer,
                  ),
                  child: Stack(
                    alignment: Alignment.topRight,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            journal.date.formattedText,
                            style: context.textTheme.bodySmall!
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                          Expanded(
                            child: Align(
                              alignment: Alignment.bottomLeft,
                              child: Text(
                                journal.title,
                                textAlign: TextAlign.left,
                                style: context.textTheme.titleLarge!
                                    .copyWith(fontWeight: FontWeight.normal),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Text(
                        journal.emote,
                        style: context.textTheme.displaySmall,
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
