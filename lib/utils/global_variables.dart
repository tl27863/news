import 'package:flutter/material.dart';
import 'package:news/screens/add_news.dart';
import 'package:news/screens/newsfeed_screen.dart';
import 'package:news/screens/profile.dart';
import 'package:news/screens/search.dart';

const webScreenSize = 719;

const homeScreenItems = [
  NewsFeedScreen(),
  SearchScreen(),
  AddNewsScreen(),
  ProfileScreen(),
];