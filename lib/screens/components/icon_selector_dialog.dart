import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:saver/icons/example_icon.dart';
import 'package:saver/icons/icons.dart';

class IconSelectorDialog extends HookWidget {
  const IconSelectorDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final searchTerm = useState("");
    final filteredIcons = useState(<ExampleIcon>[]);
    return AlertDialog(
      title: const Text('Select an icon'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            decoration: const InputDecoration(
              hintText: 'Type an icon name',
            ),
            onChanged: (value) {
              searchTerm.value = value;
              filteredIcons.value = icons
                  .where((icon) =>
                      icon.title.toLowerCase().contains(value.toLowerCase()))
                  .take(9)
                  .toList();
            },
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * .6,
            height: 300.0,
            child: GridView.count(
              crossAxisCount: 3,
              children: List.generate(filteredIcons.value.length, (index) {
                final icon = filteredIcons.value[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.pop(context, icon);
                  },
                  child: Container(
                    alignment: Alignment.center,
                    child: FaIcon(
                      icon.iconData,
                      size: 40,
                    ),
                  ),
                );
              }),
            ),
          )
        ],
      ),
    );
  }
}
