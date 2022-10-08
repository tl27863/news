import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:news/models/user.dart';
import 'package:news/providers/user_provider.dart';
import 'package:news/resources/store_methods.dart';
import 'package:news/utils/pallete.dart';
import 'package:news/utils/utils.dart';
import 'package:news/widgets/comment_card.dart';
import 'package:provider/provider.dart';

class ExpandedNewsCard extends StatefulWidget {
  final snap;
  const ExpandedNewsCard({Key? key, required this.snap}) : super(key: key);

  @override
  State<ExpandedNewsCard> createState() => _ExpandedNewsCardState();
}

class _ExpandedNewsCardState extends State<ExpandedNewsCard> {
  final TextEditingController _commentController = TextEditingController();
  bool _isLoading = false;

  void closeExpandedNews() {
    Navigator.of(context).pop();
  }  

  @override
  void dispose() {
    super.dispose();
    _commentController.dispose();
  }

  void uploadComment(
    String uid,
    String username,
    String profImage
  ) async { 
    try {
      setState(() {
        _isLoading = true;
      });
      
      String res = await StoreMethods().postComment(
        widget.snap['postId'], 
        uid, 
        username, 
        profImage, 
        _commentController.text
      );
        
      setState(() {
        _isLoading = false;
        _commentController.clear();
      });

      if(res == 'success'){
        showSnackBar('Comment successfully posted!', context);
      } else {
        showSnackBar(res, context);
      }

    } catch(err) {
        showSnackBar(err.toString(), context);
    }
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
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: closeExpandedNews,
              ),
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
      body: Container(
        margin: EdgeInsets.fromLTRB(
          MediaQuery.of(context).size.width * 0.04, 
          0, 
          MediaQuery.of(context).size.width * 0.04, 
          MediaQuery.of(context).size.height * 0.04
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                 height: MediaQuery.of(context).size.height * 0.09,
              ),
              Text(
                widget.snap['title'],
                style: const TextStyle(
                  color: textColor,
                  fontWeight: FontWeight.w700,
                  fontSize: 37,
                ),
              ),
              Text(
                '${DateFormat.yMMMd().format(widget.snap['datePublished'].toDate())} ・ ${widget.snap['username']}',
                style: const TextStyle(
                  color: textColor,
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
              Container(
                alignment: Alignment.center,
                margin: EdgeInsets.symmetric(
                  vertical: MediaQuery.of(context).size.height * 0.02
                ),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.4,
                  child: Image.network(
                    widget.snap['image'],
                    fit: BoxFit.fitHeight,
                  ),
                ),
              ),
              Text(
                widget.snap['content'],
                style: const TextStyle(
                  color: textColor,
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                ),
              ),
              SizedBox(
                 height: MediaQuery.of(context).size.height * 0.02,
              ),
              const Text(
                'Comments',
                style: TextStyle(
                  color: textColor,
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                ),
              ),
              StreamBuilder(
                stream: FirebaseFirestore.instance.collection('posts')
                .doc(widget.snap['postId'])
                .collection('comments')
                .orderBy('datePublished', descending: false)
                .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                  if(snapshot.connectionState == ConnectionState.waiting){
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.only(
                      top: 8,
                    ),
                    shrinkWrap: true,
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) => CommentCard(
                      snap: snapshot.data!.docs[index].data()
                    )
                  );
                },
              ),
              Container(
                height: kToolbarHeight,
                padding: const EdgeInsets.only(
                  left: 16,
                  right: 8
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(user.photoUrl),
                      radius: 18,
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(
                          left: 16,
                          right: 8
                        ),
                        child: TextField(
                          controller: _commentController,
                          decoration: const InputDecoration(
                            hintText: 'Comment',
                            border: InputBorder.none
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () => uploadComment(
                        user.uid,
                        user.username,
                        user.photoUrl
                      ),
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.16,
                        padding: const EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 20
                        ),
                        child: _isLoading == true ?
                        const Center(
                          child: CircularProgressIndicator(
                          color: secondaryColor,
                          )
                        )
                        :
                        const Text(
                          'Post',
                          style: TextStyle(
                            color: secondaryColor
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      )
    );
  }
}