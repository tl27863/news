import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:news/models/user.dart';
import 'package:news/providers/user_provider.dart';
import 'package:news/resources/store_methods.dart';
import 'package:news/utils/pallete.dart';
import 'package:news/utils/utils.dart';
import 'package:provider/provider.dart';

class AddNewsScreen extends StatefulWidget {
  const AddNewsScreen({Key? key}) : super(key: key);

  @override
  State<AddNewsScreen> createState() => _AddNewsScreenState();
}

class _AddNewsScreenState extends State<AddNewsScreen> {
  Uint8List? _image;
  bool _isLoading = false;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  void selectImage() async {
    Uint8List img = await pickImage(ImageSource.gallery);
    setState(() {
      _image = img;
    });
  }

  @override
  void dispose(){
    super.dispose();
    _titleController.dispose();
    _contentController.dispose();
  }

  void postNews(
    String uid,
    String username
  ) async {
    try{
      setState(() {
        _isLoading = true;
      });

      String res = await StoreMethods().uploadPost(uid, username, _titleController.text, _contentController.text, _image!);

      setState(() {
        _isLoading = false;
      });

      if(res == 'success'){
        showSnackBar('News successfully posted!', context);
        resetPost();
      } else {
        showSnackBar(res, context);
      }
    } catch(err){
      showSnackBar(err.toString(), context);
    }
  }

  void resetPost(){
    setState(() {
      _image = null;
      _titleController.clear();
      _contentController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final User? user = Provider.of<UserProvider>(context).getUser;

    return user == null ? 
    const Center(child: CircularProgressIndicator(),)
    :
    Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        centerTitle: true,
        title: const Text('Add News'),
        actions: [
          SizedBox(
            width: 70,
            child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  color: textColor,
                )
              )
            : IconButton(
              onPressed: () => postNews(user.uid, user.username), 
              icon: const Icon(Icons.add_circle_rounded),
              iconSize: 30,
              alignment: Alignment.center,
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox( 
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                child: TextField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    hintText: 'Title',
                    border: InputBorder.none
                  ),
                  maxLines: 2,
                  style: const TextStyle(
                    fontSize: 30,
                    color: textColor
                  ),
                ),
              ),
            ),
            SizedBox( 
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            _image == null ? (
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                height: MediaQuery.of(context).size.height * 0.2,
                child: Center(
                  child: IconButton(
                    onPressed: selectImage, 
                    icon: const Icon(Icons.upload)
                  ),
                )
              ),
            ) 
            ):(
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              height: MediaQuery.of(context).size.height * 0.4,
              child: AspectRatio(
                aspectRatio: 3/2,
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: MemoryImage(_image!),
                      fit: BoxFit.fitHeight,
                      alignment: FractionalOffset.topCenter
                    )
                  ),
                ),
              ),
            )
            ),
            SizedBox( 
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                child: TextField(
                  controller: _contentController,
                  decoration: const InputDecoration(
                    hintText: 'News Content',
                    border: InputBorder.none
                  ),
                  maxLines: 15,
                  maxLength: 6000,
                  style: const TextStyle(
                    fontSize: 18,
                    color: textColor
                  ),
                ),
              ),
            ),
            SizedBox( 
              height: MediaQuery.of(context).size.height * 0.04,
            ),
          ],
        ),
      ),
    );
  }
}