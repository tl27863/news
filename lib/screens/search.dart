import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:news/screens/expanded_news.dart';
import 'package:news/utils/global_variables.dart';
import 'package:news/utils/pallete.dart';
import 'package:news/widgets/news_card.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _showSearch = false;

  @override
  void dispose(){
    super.dispose();
    _searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: TextFormField(
          controller: _searchController,
          decoration: const InputDecoration(
            labelText: 'Search News' 
          ),
          onFieldSubmitted: (String _) {
            setState(() {
              _showSearch = true;
            });
          },
        ),
      ),
      body:  _showSearch ?
      FutureBuilder(
        future: FirebaseFirestore.instance.collection('posts')
        .where('title', isGreaterThanOrEqualTo: _searchController.text)
        .where('title', isLessThan: '${_searchController.text}z')
        .get(),
        builder: (context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if(!snapshot.hasData){
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) =>
            Container(
              margin: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width > webScreenSize ?
                  MediaQuery.of(context).size.width * 0.2
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
      ) :
      Container()
    );
  }
}