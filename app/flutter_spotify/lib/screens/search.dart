import 'package:flutter/material.dart';

//TODO remove import use context
import '../theme.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.dark(); //TODO
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Search',
                  style: AppTheme.darkTextTheme.headline2,
                ),
                Spacer(),
                IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {},
                ),
                IconButton(
                  icon: Icon(Icons.qr_code),
                  onPressed: () {},
                ),
              ],
            ),
            //TODO searchbar widget
            Text('<SEARCHBAR />'),
            // ListView.builder(
            //     itemCount: 2,
            //     itemBuilder: (context, index) {
            //       return Column(
            //         children: [
            //           const Text('Section 1'),
            //           Row(
            //             children: const [
            //               Text('Left'),
            //               Text('Right'),
            //             ],
            //           )
            //         ],
            //       );
            //     }),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Section 1'),
                Row(
                  children: const [
                    Text('Left'),
                    Spacer(),
                    Text('Right'),
                  ],
                )
              ],
            ),
            Column(
              children: [
                const Text('Section 1'),
                Row(
                  children: const [
                    Text('Left'),
                    Spacer(),
                    Text('Right'),
                  ],
                )
              ],
            ),
            Text(
              'Browse',
              style: AppTheme.darkTextTheme.headline2,
            ),
            Row(
              children: const [
                Text('Left'),
                Spacer(),
                Text('Right'),
              ],
            )
          ],
        ),
      ),
    );
  }
}
