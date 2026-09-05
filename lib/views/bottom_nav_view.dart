import 'package:flutter/material.dart';
import 'package:iconly_plus/iconly_plus.dart';
import 'package:work_time/core/theme/app_colors.dart';

import 'home/home_view.dart';
import 'note/note_view.dart';
import 'users/trash/trash_view.dart';

class BottomNavView extends StatefulWidget {
  const BottomNavView({super.key});

  @override
  State<BottomNavView> createState() => _BottomNavViewState();
}

class _BottomNavViewState extends State<BottomNavView> {
  int _selectedIndex = 0;
  final List _pages = [
    HomeView(),
    NoteView(),
    const TrashView(),
  ];

  void _selectedPage(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final borderColor = isDark ? AppColors.darkBorder : AppColors.lightBorder;

    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: borderColor, width: 1),
          ),
        ),
        child: BottomNavigationBar(
          onTap: _selectedPage,
          currentIndex: _selectedIndex,
          items: bottomNavigationBarItems(isDark),
        ),
      ),
    );
  }

  List<BottomNavigationBarItem> bottomNavigationBarItems(bool isDark) {
    return [
      BottomNavigationBarItem(
        icon: _buildNavItem(
          icon: _selectedIndex == 0 ? IconlyBold.home : IconlyLight.home,
          isSelected: _selectedIndex == 0,
          isDark: isDark,
        ),
        label: 'الرئيسية',
      ),
      BottomNavigationBarItem(
        icon: _buildNavItem(
          icon: _selectedIndex == 1 ? IconlyBold.document : IconlyLight.document,
          isSelected: _selectedIndex == 1,
          isDark: isDark,
        ),
        label: 'الملاحظات',
      ),
      BottomNavigationBarItem(
        icon: _buildNavItem(
          icon: _selectedIndex == 2 ? IconlyBold.delete : IconlyLight.delete,
          isSelected: _selectedIndex == 2,
          isDark: isDark,
        ),
        label: 'خارج العمل',
      ),
    ];
  }

  Widget _buildNavItem({
    required IconData icon,
    required bool isSelected,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: isSelected
            ? (isDark ? AppColors.primary.withValues(alpha: 0.3) : AppColors.primaryLight)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Icon(
        icon,
        color: isSelected
            ? AppColors.primary
            : (isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
      ),
    );
  }
}
