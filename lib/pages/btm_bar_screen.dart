
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';

import 'home/home_page.dart';
import 'note/note_page.dart';
import 'users/trash/trash_page.dart';

class BottomBarScreen extends StatefulWidget {
  const BottomBarScreen({Key? key}) : super(key: key);

  @override
  State<BottomBarScreen> createState() => _BottomBarScreenState();
}

class _BottomBarScreenState extends State<BottomBarScreen> {
  int _selectedIndex = 0;
  List pages = [
    HomePage(),
    NotePage(),
    const TrashPage()
  ];

  void _selectedPage(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectedPage,
        currentIndex: _selectedIndex,
        items: bottomNavigationBarItems(),
      ),
    );
  }

  List<BottomNavigationBarItem> bottomNavigationBarItems() {
    return [
        BottomNavigationBarItem(
            icon:
                Icon(_selectedIndex == 0 ? IconlyBold.home : IconlyLight.home),
            label: 'الرئيسية'),
        const BottomNavigationBarItem(
            icon: Icon( Icons.menu_book_outlined),
            label: 'الملاحظات'),
        BottomNavigationBarItem(
            icon: Icon(
                _selectedIndex == 2 ? IconlyBold.delete : IconlyLight.delete),
            label: 'خارج العمل'),
      ];}
}
