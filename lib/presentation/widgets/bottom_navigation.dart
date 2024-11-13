import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:precise/core/utils/assets.dart';

class BottomNavigation extends StatelessWidget {
  const BottomNavigation({
    super.key,
    required this.child,
  });

  final StatefulNavigationShell child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: child,
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        navigationShell: child,
      ),
    );
  }
}

class CustomBottomNavigationBar extends StatelessWidget {
  const CustomBottomNavigationBar({
    super.key,
    required this.navigationShell,
  });

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      selectedIndex: navigationShell.currentIndex,
      onDestinationSelected: (index) {
        navigationShell.goBranch(
          index,
          initialLocation: index == navigationShell.currentIndex,
        );
      },
      destinations: const [
        NavigationDestinationItem(
          activeIcon: AssetVectors.icHomeActive,
          inactiveIcon: AssetVectors.icHome,
          label: 'Home',
        ),
        NavigationDestinationItem(
          activeIcon: AssetVectors.icBookmarkActive,
          inactiveIcon: AssetVectors.icBookmark,
          label: 'Bookmarks',
        ),
        NavigationDestinationItem(
          activeIcon: AssetVectors.icSettingsActive,
          inactiveIcon: AssetVectors.icSettings,
          label: 'Settings',
        ),
      ],
    );
  }
}

class NavigationDestinationItem extends StatelessWidget {
  final String activeIcon;
  final String inactiveIcon;
  final String label;
  const NavigationDestinationItem(
      {super.key,
      required this.activeIcon,
      required this.inactiveIcon,
      required this.label});

  @override
  Widget build(BuildContext context) {
    return NavigationDestination(
      selectedIcon: SvgPicture.asset(
        activeIcon,
        width: 24,
      ),
      icon: SvgPicture.asset(
        inactiveIcon,
        colorFilter: ColorFilter.mode(
          Theme.of(context).colorScheme.onSurfaceVariant,
          BlendMode.srcIn,
        ),
        width: 24,
      ),
      label: label,
    );
  }
}
