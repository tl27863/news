import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import 'package:news/models/user.dart';
import 'package:news/providers/user_provider.dart';
import 'package:news/screens/expanded_news.dart';
import 'package:news/utils/global_variables.dart';
import 'package:news/utils/pallete.dart';
import 'package:news/widgets/news_card.dart';
import 'package:provider/provider.dart';

class NewsFeedScreen extends StatelessWidget {
  const NewsFeedScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final User? user = Provider.of<UserProvider>(context).getUser;

    return user == null ? 
    const Center(child: CircularProgressIndicator(),)
    :
    Scaffold(
      extendBodyBehindAppBar: true,
      appBar: MediaQuery.of(context).size.width > webScreenSize ?
      null
      :
      PreferredSize(
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
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    radius: 20,
                    backgroundImage: NetworkImage(user.photoUrl),
                  )
                )
              ],
            ),
          ),
        ),  
      ),
      body: Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: StreamBuilder(
          stream:  FirebaseFirestore.instance.collection('posts')
          .orderBy('datePublished', descending: true)
          .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            if(snapshot.connectionState == ConnectionState.waiting){
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            return ListView.builder(
              shrinkWrap: true,
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) => 
              Container(
                margin: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width > webScreenSize ?
                  MediaQuery.of(context).size.width * 0.19
                  :
                  0
                ),
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).
                      push(MaterialPageRoute(builder: (context) => ExpandedNewsCard(snap: snapshot.data!.docs[index].data())));
                  },
                  child: NewsCard(
                    snap: snapshot.data!.docs[index].data(),
                  ),
                ),
              )
            );
          },
        ),
      ),
    );
  }
}