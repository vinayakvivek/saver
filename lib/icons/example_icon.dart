import 'package:flutter/widgets.dart';

/// source: https://github.com/fluttercommunity/font_awesome_flutter/blob/master/example/lib/example_icon.dart
class ExampleIcon implements Comparable {
  final IconData iconData;
  final String title;

  ExampleIcon(this.iconData, this.title);

  @override
  String toString() => 'IconDefinition{iconData: $iconData, title: $title}';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExampleIcon &&
          runtimeType == other.runtimeType &&
          iconData == other.iconData &&
          title == other.title;

  @override
  int get hashCode => iconData.hashCode ^ title.hashCode;

  @override
  int compareTo(other) => title.compareTo(other.title);
}
