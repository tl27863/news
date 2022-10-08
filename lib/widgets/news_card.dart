import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:news/utils/pallete.dart';

class NewsCard extends StatelessWidget {
  final snap;
  const NewsCard({Key? key, required this.snap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: MediaQuery.of(context).size.height * 0.01,
        horizontal: MediaQuery.of(context).size.width * 0.02
      ),
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.7
      ),
      width: MediaQuery.of(context).size.width * 0.9,
      decoration: BoxDecoration(
        color: secondaryColor,
        border: Border.all(style: BorderStyle.none),
        borderRadius: const BorderRadius.all(Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.fromLTRB(
              8, 
              8, 
              8, 
              0
            ),
            height: MediaQuery.of(context).size.height * 0.45,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20)
              ),
              image: DecorationImage(
                image: NetworkImage(snap['image']),
                fit: BoxFit.cover,
                alignment: FractionalOffset.topCenter
              )
            ),
            child: Container()
          ),
          Container(
            margin: const EdgeInsets.symmetric(
              vertical: 8,
              horizontal: 8
            ),
            padding: const EdgeInsets.symmetric(
              vertical: 8,
              horizontal: 8
            ),
            decoration: BoxDecoration(
              color: primaryColor,
              border: Border.all(style: BorderStyle.none),
              borderRadius: const BorderRadius.all(Radius.circular(10)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: Text(snap['title'],
                    style: const TextStyle(
                      color: textColor,
                      fontWeight: FontWeight.w800,
                      fontSize: 24
                    )
                  ),
                ),
                Text(
                  DateFormat.yMMMd().format(snap['datePublished'].toDate())
                  + ' ・ ' + snap['username'],
                  style: const TextStyle(
                    color: textColor,
                    fontSize: 18
                  )
                ),
              ],
            ),
          )
        ],
      ),
    );  
  }
}