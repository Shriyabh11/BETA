import 'package:freezed_annotation/freezed_annotation.dart';

part 'navigation_item.freezed.dart';

@freezed
class NavigationItem with _$NavigationItem {
  const factory NavigationItem({
    required String label,
    required String icon,
    required String route,
  }) = _NavigationItem;

  static const List<NavigationItem> items = [
    NavigationItem(
      label: 'Home',
      icon: 'home',
      route: '/home',
    ),
    NavigationItem(
      label: 'Logs',
      icon: 'note_alt',
      route: '/logs',
    ),
    NavigationItem(
      label: 'Me',
      icon: 'person',
      route: '/profile',
    ),
  ];
}
