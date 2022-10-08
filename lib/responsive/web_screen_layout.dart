import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:news/models/user.dart';
import 'package:news/providers/user_provider.dart';
import 'package:news/utils/global_variables.dart';
import 'package:news/utils/pallete.dart';
import 'package:provider/provider.dart';

class WebScreenLayout extends StatefulWidget {

  const WebScreenLayout({Key? key}) : super(key: key);

  @override
  State<WebScreenLayout> createState() => _WebScreenLayoutState();
}

class _WebScreenLayoutState extends State<WebScreenLayout> {
  int _page = 0;
  late PageController pageController;

  @override
  void initState() {
    super.initState();
    pageController = PageController();
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  void navigationTap(int page) {
    pageController.jumpToPage(page);
  }

  void onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    final User? user = Provider.of<UserProvider>(context).getUser;

    return user == null ?
    const Center(child: CircularProgressIndicator(),)
    :
    Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: const Size(
          double.infinity,
          kToolbarHeight
        ),
        child: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 10,
              sigmaY: 10
            ),
            child: AppBar(
              backgroundColor: primaryColor.withOpacity(0.65),
              centerTitle: false,
              title: SvgPicture.asset(
                      'assets/logo.svg',
                      color: textColor,
                      height: 46,
              ),
              actions: [
                IconButton(
                  onPressed: () => navigationTap(0),
                  icon: Icon(Icons.home, color: _page == 0 ? textColor : secondaryColor),
                ),
                IconButton(
                  onPressed: () => navigationTap(1),
                  icon: Icon(Icons.search, color: _page == 1 ? textColor : secondaryColor),
                ),
                IconButton(
                  onPressed: () => navigationTap(2),
                  icon: Icon(Icons.add_circle, color: _page == 2 ? textColor : secondaryColor),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: InkWell(
                    onTap: () => navigationTap(3),
                    child: CircleAvatar(
                      radius: 20,
                      backgroundImage: NetworkImage(user.photoUrl),
                    ),
                  )
                )
              ],
            ),
          ),
        ),  
      ),
      body: PageView(
        children: homeScreenItems,
        physics: const NeverScrollableScrollPhysics(),
        controller: pageController,
        onPageChanged: onPageChanged,
      ),
    );
  }
}