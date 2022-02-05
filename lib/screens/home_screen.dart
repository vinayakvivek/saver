import 'dart:io';
import 'dart:math';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:saver/context_utils.dart';
import 'package:saver/models/account.dart';
import 'package:saver/boxes.dart';
import 'package:saver/screens/account_screen.dart';
import 'package:saver/screens/components/account_tile.dart';
import 'package:saver/screens/components/auth_pointer.dart';
import 'package:saver/screens/components/export_dialog.dart';
import 'package:saver/screens/components/import_dialog.dart';

class HomeScreen extends HookConsumerWidget {
  const HomeScreen({Key? key}) : super(key: key);

  final searchBarHeight = 40.0;
  final searchBarMargin = 10.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scrollController = useScrollController(
        initialScrollOffset: searchBarHeight + searchBarMargin);
    final barHeight = useState(searchBarHeight);
    final animateTo = useCallback((toOffset) {
      Future.delayed(Duration.zero, () {
        scrollController.animateTo(
          toOffset,
          duration: const Duration(milliseconds: 100),
          curve: Curves.easeIn,
        );
      });
    }, [scrollController]);
    useEffect(() {
      void listener() {
        // print(scrollController.offset);
      }

      scrollController.addListener(listener);
      return () => scrollController.removeListener(listener);
    });
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Text("Accounts"),
            SizedBox(width: 10.0),
            AuthPointer(),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              doPostAuth(
                ref,
                () => showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => const ExportDialog(),
                ),
              );
            },
            icon: const Icon(Icons.ios_share),
          ),
          IconButton(
            onPressed: () async {
              doPostAuth(ref, () async {
                FilePickerResult? result =
                    await FilePicker.platform.pickFiles();
                if (result != null) {
                  File file = File(result.files.single.path!);
                  showDialog<String>(
                      context: context,
                      builder: (BuildContext context) =>
                          ImportDialog(file: file));
                } else {
                  // User canceled the picker
                }
              });
            },
            icon: const Icon(Icons.download),
          ),
        ],
      ),
      body: ValueListenableBuilder<Box<Account>>(
        valueListenable: Boxes.getAccounts().listenable(),
        builder: (context, box, _) {
          final accounts = box.values.toList().cast<Account>();
          return NotificationListener<ScrollNotification>(
            onNotification: (scrollNotification) {
              if (scrollNotification is ScrollEndNotification) {
                // final direction = scrollController.position.userScrollDirection;
                final offset = scrollController.offset;

                if (offset < searchBarHeight - 10 && offset > 0.01) {
                  animateTo(0.0);
                } else if (offset > searchBarHeight - 10 &&
                    offset < searchBarHeight + searchBarMargin) {
                  print('scrolling to first');
                  animateTo(searchBarHeight + searchBarMargin);
                }
              } else if (scrollNotification is ScrollUpdateNotification) {
                final offset = scrollController.offset;
                if (offset < searchBarHeight) {
                  barHeight.value = max(10.0, searchBarHeight - offset);
                }
              }
              return false;
            },
            child: ListView.builder(
              controller: scrollController,
              padding: const EdgeInsets.only(top: 8.0, bottom: 150),
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Container(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        child: const Text(""),
                        decoration: BoxDecoration(
                          color: Colors.grey[900],
                          borderRadius: BorderRadius.circular(20),
                        ),
                        height: barHeight.value,
                        width: double.infinity,
                      ),
                    ),
                    margin: EdgeInsets.only(
                      left: 8.0,
                      right: 8.0,
                      bottom: searchBarMargin,
                    ),
                    height: searchBarHeight,
                  );
                }
                final account = accounts[index - 1];
                return AccountTile(account: account);
              },
              itemCount: accounts.length + 1,
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AccountScreen(account: Account.empty()),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
