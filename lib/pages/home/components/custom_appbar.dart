import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../provider/user_provider.dart';
import '../../../utility/global_methods.dart';

AppBar customAppBar(BuildContext context) {
  final userProvider = Provider.of<UserProvider>(context);
  return !userProvider.clickSearch
        ? AppBar(
    leading: IconButton(
      onPressed: () => userProvider.changeClickSearch(),
      icon: const Icon(
        Icons.search,
        color: Colors.white,
      ),
    ),
          actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.settings))],
          title: Text(
            '${GlobalMethods.getDayName(DateTime.now())} ${GlobalMethods.getDateFormat(DateTime.now())}',
            style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: Colors.white),
          ),
    centerTitle: true,
        )
        : AppBar(
          title: TextField(
              onChanged: (txt) {
                userProvider.searchUsers(txt);
              },
              decoration: InputDecoration(
                  focusColor: Colors.red,
                  hintText: "بحث",
                  hintStyle: TextStyle(color: Colors.grey[400], fontSize: 16),
                  prefixIcon: const Icon(
                    Icons.search,
                    color: Colors.white,
                  ),
                  suffixIcon: IconButton(
                    onPressed: () {
                      userProvider.changeClickSearch();
                      userProvider.getUsers();
                    },
                    icon: const Icon(
                      Icons.arrow_forward_ios_sharp,
                      color: Color(0xFFE94560),
                    ),
                  )),
              textInputAction: TextInputAction.search,
              style: const TextStyle(color: Colors.white70, fontSize: 18),
              cursorColor: const Color(0xFF533483),
            ),
    centerTitle: true,
        );
}
