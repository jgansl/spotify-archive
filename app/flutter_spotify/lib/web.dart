import 'package:flutter/material.dart';
import 'package:flutter_spotify/spotify/spotify_web.dart';
import 'package:flutter_spotify/spotify/models/models.dart';
import 'dart:developer';
import 'dart:math';



class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}


class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  //late
  List<Track> saved = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future _loadData() async {
    var data = await fetchRecentlyPlayed();
    setState((){
      saved.addAll(data);
    });
  }

  Future _loadMoreData() async {
    // perform fetching data delay
    // await Future.delayed(new Duration(seconds: 2));
    return;
    final items = await fetchSaved(saved.length);

    print("load more");
    // update data and loading status
    setState(() {
      saved.addAll(items);
      print('items: '+ items.toString());
      isLoading = false;
    });
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  // Widget projectWidget() {
  //   return FutureBuilder(
  //     builder: (context, projectSnap) {
  //       if (projectSnap.connectionState == ConnectionState.none &&
  //           projectSnap.hasData == null) {
  //         //print('project snapshot data is: ${projectSnap.data}');
  //         return Container();
  //       }
  //       return ListView.builder(
  //         itemCount: projectSnap.data.length,
  //         itemBuilder: (context, index) {
  //           Track project = projectSnap.data[index];
  //           return Column(
  //             children: <Widget>[
  //               // Widget to display the list of project
  //             ],
  //           );
  //         },
  //       );
  //     },
  //     future: fetchSaved(),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(children: [
        Text('TOtal'),
        Sliver
        Expanded(
          child: NotificationListener<ScrollNotification>(
            onNotification: (ScrollNotification scrollInfo) {
              if (!isLoading && scrollInfo.metrics.pixels ==
                  scrollInfo.metrics.maxScrollExtent) {
                _loadMoreData();
                // start loading data
                setState(() {
                  isLoading = false;//true;
                });
              }
              return false;
            },
            child: ListView.builder(
              itemCount: saved.length,
              itemBuilder: (context, index) {
                return ListTile(
                  tileColor: index % 2 == 0 ? Colors.red: Colors.white,
                  title: Text('${saved[index].name}'),//'.artists[0].name}'),
                );
              },
            ),
          ),
        ),
        Container(
          height: isLoading ? 50.0 : 0,
          color: Colors.transparent,
          child: Center(
            child: new CircularProgressIndicator(),
          ),
        ),
        // FutureBuilder <List<Track>>(
        // future: fetchSaved(),//request("$base/me/tracks"),//futureSaved,
        // initialData: const [],
        // builder: (context, snapshot) {
        //   if (snapshot.hasData) {
        //     return SizedBox(
        //       height:
        //       MediaQuery.of(context).size.height - 100,
        //       child: ListView.builder(
        //           itemCount: snapshot.data!.length,
        //           itemBuilder:
        //               (BuildContext ctxt, int index) {
        //             return Text(snapshot.data![index].name);
        //           }),
        //     );
        //     return Text(snapshot.data!.length.toString());
        //   } else if (snapshot.hasError) {
        //     return Text('err 1');
        //   }
        //
        //   // By default, show a loading spinner.
        //   return const CircularProgressIndicator();
        // },),
      ],),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}