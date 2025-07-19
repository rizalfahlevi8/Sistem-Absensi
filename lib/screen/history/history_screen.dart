import 'package:flutter/material.dart';
import 'package:presensi/provider/history/presensi_history_provider.dart';
import 'package:presensi/screen/component/loader_widget.dart';
import 'package:presensi/screen/component/presensi_card_widget.dart';
import 'package:presensi/static/presensi_list_result_state.dart';
import 'package:provider/provider.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    final apiProvider = context.read<PresensiHistoryProvider>();

    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent) {
        if (apiProvider.pageItems != null) {
          apiProvider.fetchPresensiList();
        }
      }
    });

    Future.microtask(() async => apiProvider.fetchPresensiList());
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "History",
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.blue[800],
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: Consumer<PresensiHistoryProvider>(
              builder: (context, value, child) {
                return switch (value.resultState) {
                  PresensiListLoadingState() => Center(
                    child: LoaderWidget(),
                  ),
                  PresensiListResultLoadedState(data: var presensiList) =>
                    ListView.builder(
                      controller: scrollController,
                      itemCount:
                          presensiList.length + (value.pageItems != null ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index == presensiList.length &&
                            value.pageItems != null) {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.all(8),
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }
                        final presensi = presensiList[index];

                        return PresensiCardWidget(
                          presensi: presensi,
                        );
                      },
                    ),
                  PresensiListErrorState(error: var message) => Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 50,
                          color: Colors.redAccent,
                        ),
                        SizedBox(height: 20),
                        Text(
                          message,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.redAccent,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 20),
                        ElevatedButton.icon(
                          onPressed: () {
                            context.read<PresensiHistoryProvider>().fetchPresensiList();
                          },
                          icon: Icon(Icons.refresh),
                          label: Text(
                            "coba lagi",
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Theme.of(context).primaryColor,
                            padding: EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 10,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  _ => SizedBox(),
                };
              },
            ),
          ),
        ],
      ),
    );
  }
}