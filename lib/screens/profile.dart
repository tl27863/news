import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:news/models/user.dart' as models;
import 'package:news/providers/user_provider.dart';
import 'package:news/resources/auth_methods.dart';
import 'package:news/screens/expanded_news.dart';
import 'package:news/screens/login_screen.dart';
import 'package:news/utils/global_variables.dart';
import 'package:news/utils/pallete.dart';
import 'package:news/utils/utils.dart';
import 'package:news/widgets/news_card.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isLoading = false;
  int postCount = 0;

  @override
  void initState(){
    super.initState();
    getData();
  }

  getData() async {
    try {
      setState(() {
        _isLoading = true;
      });

      var postSnap = await FirebaseFirestore.instance.collection('posts')
      .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
      .get();
      postCount = postSnap.docs.length;

      setState(() {
        _isLoading = false;
      });
    } catch (err) {
      showSnackBar(err.toString(), context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final models.User? user = Provider.of<UserProvider>(context).getUser;

    return (user == null || _isLoading ) ?
    const Center(child: CircularProgressIndicator(),)
    :
    Scaffold(
      appBar: MediaQuery.of(context).size.width > webScreenSize ?
      null
      :
      AppBar(
        backgroundColor: primaryColor,
        title: Text('${user.username} Profile'),
        centerTitle: false,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          vertical: MediaQuery.of(context).size.width > webScreenSize ?
            kToolbarHeight + 8
            :
            16
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.1,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.black,
                    backgroundImage: NetworkImage(user.photoUrl),
                    radius: 60,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user.username,
                          style: const TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 24
                          ),
                        ),
                        Text(
                          user.email,
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 14
                          ),
                        ),
                        const SizedBox(
                          width: 1,
                          height: 4
                        ),
                        Text( 
                          'Published ${postCount.toString()} News',
                          style: const TextStyle(
                            fontWeight: FontWeight.w100,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: InkWell(
                onTap: () async {
                  await AuthMethods().signOut();
                  Navigator.of(context)
                    .pushReplacement(MaterialPageRoute(builder: (context) => const LoginScreen()));
                },
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: MediaQuery.of(context).size.height * 0.05,
                  decoration: BoxDecoration(
                    color: secondaryColor,
                    borderRadius: BorderRadius.circular(5)
                  ),
                  child: const Center(
                    child: Text('Sign Out')
                  ),
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: StreamBuilder(
                  stream:  FirebaseFirestore.instance.collection('posts')
                  .where('uid', isEqualTo: user.uid)
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
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}