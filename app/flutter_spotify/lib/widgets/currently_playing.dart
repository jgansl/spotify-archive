// /**
//  * GestureDecector -> switch screen
//  */
// import 'package:flutter/material.dart';
//
// //TODO make part of bnottom bar
// class CurrentlyPlayingWidget extends StatefulWidget {
//   const CurrentlyPlayingWidget({Key? key}) : super(key: key);
//
//   @override
//   _CurrentlyPlayingWidgetState createState() => _CurrentlyPlayingWidgetState();
// }
//
// class _CurrentlyPlayingWidgetState extends State<CurrentlyPlayingWidget> {
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         setState(() {
//           // Toggle light when tapped.
//           // Navigator.pushNamed(context, 'player');
//           Navigator.push(
//             context,
//             // MaterialPageRoute(builder: (context) => PlayerScreen()),
//             PageRouteBuilder(
//               pageBuilder: (c, a1, a2) => PlayerScreen(),
//               transitionsBuilder: (c, anim, a2, child) =>
//                   FadeTransition(opacity: anim, child: child),
//               transitionDuration: const Duration(milliseconds: 150),
//             ),
//           );
//         });
//       },
//       onVerticalDragStart: (DragStartDetails dragStartDetails) {
//         Navigator.pushNamed(context, 'player'); //
//         // Navigator.pushNamed(context, LobbyScreen.route);
//       },
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.end,
//         children: [
//           Container(
//             // color: Colors.black,
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(8),
//               color: Colors.black,
//               // boxShadow: const [
//               //   BoxShadow(color: Colors.red, spreadRadius: 1),
//               // ],
//             ),
//             margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 87.0),
//             child: Row(children: [
//               //TODO album image
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Image.network('https://picsum.photos/250?image=9',
//                     height: 50, width: 50),
//               ),
//               //TODO infomation injection
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: const [
//                   Text('Title'),
//                   Text('Artist(s)'),
//                 ],
//               ),
//               Spacer(),
//               IconButton(icon: Icon(Icons.airplay), onPressed: () {}),
//               IconButton(icon: Icon(Icons.pause_circle), onPressed: () {}),
//             ]),
//           ),
//           //TODO trackposition slider
//         ],
//         // Container(
//         //   color: Colors.yellow.shade600,
//         //   padding: const EdgeInsets.all(8),
//         //   // Change button text when light changes state.
//         //   child: Text(_lightIsOn ? 'TURN LIGHT OFF' : 'TURN LIGHT ON'),
//         // ),
//       ),
//     );
//   }
// }
// //
// // Column(
// // mainAxisAlignment: MainAxisAlignment.end,
// // children: [
// // Container(
// // height: 50,
// // width: MediaQuery.of(context).size.width,
// // margin: const EdgeInsets.only(left: 0.0, right: 0.0),
// // decoration: BoxDecoration(
// // color: const Color(0xff7c94b6),
// // // image: const DecorationImage(
// // //   image: NetworkImage(
// // //       'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl-2.jpg'),
// // //   fit: BoxFit.cover,
// // // ),
// // border: Border.all(
// // color: Colors.black,
// // width: 1,
// // ),
// // borderRadius: BorderRadius.circular(4),
// // ),
// // child: Padding(
// // padding: const EdgeInsets.all(8.0),
// // child: Row(
// // children: [
// // Text("Currently Playing"),
// // Spacer(),
// // IconButton(
// // icon: Icon(Icons.airplay), onPressed: () {}),
// // IconButton(icon: Icon(Icons.pause), onPressed: () {}),
// // ],
// // ),
// // )),
// // Container(
// // height: 50,
// // width: MediaQuery.of(context).size.width,
// // margin: const EdgeInsets.only(left: 0.0, right: 0.0),
// // decoration: BoxDecoration(
// // color: const Color(0xff7c94b6),
// // // image: const DecorationImage(
// // //   image: NetworkImage(
// // //       'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl-2.jpg'),
// // //   fit: BoxFit.cover,
// // // ),
// // border: Border.all(
// // color: Colors.black,
// // width: 1,
// // ),
// // borderRadius: BorderRadius.circular(4),
// // ),
// // child: Padding(
// // padding: const EdgeInsets.all(8.0),
// // child: Text("Hello"),
// // ))
// // ],
