import 'package:flutter/material.dart';

/**
 * on the stack => pop()
 */
class LikedSongsScreen extends StatefulWidget {
  const LikedSongsScreen({Key? key}) : super(key: key);

  @override
  _LikedSongsScreenState createState() => _LikedSongsScreenState();
}

class _LikedSongsScreenState extends State<LikedSongsScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            //imagebutton
            Text('Your Library'), //style
            Spacer(),
            IconButton(icon: Icon(Icons.search), onPressed: () {}),
            IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  //triiiger parent stack to displat adding new playlsit
                }),
          ],
        ),
        // ScrollView()
      ],
    );
  }
}
