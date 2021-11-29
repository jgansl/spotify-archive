//core
import 'dart:async';
import 'dart:convert';
import 'dart:core';

//external
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

//theme
import './theme.dart';

//screens
// import 'package:flutter_spotify/screens/account.dart';
import 'package:flutter_spotify/screens/home.dart';
import 'package:flutter_spotify/screens/library.dart';
// import 'package:flutter_spotify/screens/login.dart';
import 'package:flutter_spotify/screens/search.dart';
// import 'package:flutter_spotify/screens/splashscreen.dart';

import 'package:logger/logger.dart';
import 'package:spotify_sdk/models/connection_status.dart';
import 'package:spotify_sdk/models/crossfade_state.dart';
import 'package:spotify_sdk/spotify_sdk.dart';
// import 'package:flutter_spotify/utils/web_client.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/services.dart';
import 'package:flutter_spotify/theme.dart';
import 'package:flutter_spotify/models/track.dart';

//web
// import 'flutter..'
// import 'package:flutter_spotify/web.dart';
// void main() {
//   runApp(const MyApp());
// }

//app
Future<void> main() async {

  await dotenv.load(fileName: '.env');
  WidgetsFlutterBinding.ensureInitialized();

  Supabase.initialize(
      url: dotenv.env['SUPABASE_URL'],
      anonKey: dotenv.env['SUPABASE__KEY'],
      authCallbackUrlHostname: 'login-callback', // optional
      debug: true // optional
      );

  // @see https://supabase.io/docs/guides/with-flutter
  // runApp(MyApp());
  runApp(StateContainer(child: AppEntry()));
}

// navigator by static routing
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Supabase Flutter',
//       theme: ThemeData.dark().copyWith(
//         primaryColor: Colors.green,
//         elevatedButtonTheme: ElevatedButtonThemeData(
//           style: ElevatedButton.styleFrom(
//             onPrimary: Colors.white,
//             primary: Colors.green,
//           ),
//         ),
//       ),
//       initialRoute: '/',
//       routes: <String, WidgetBuilder>{
//         '/': (_) => const SplashScreen(),
//         '/login': (_) => const LoginPage(),
//         '/account': (_) => const AccountPage(),
//       },
//     );
//   }
// }

class AppEntry extends StatefulWidget {
  AppEntry({Key? key}) : super(key: key);

  @override
  State<AppEntry> createState() => _AppEntryState();
}

class _AppEntryState extends State<AppEntry> {
  // bool _loading = false;
  bool _connected = false;
  final Logger _logger = Logger();
  CrossfadeState? crossfadeState;
  String? token;
  //late
  Future<List<Track>>? futureTracks;

  @override
  void initState() {
    super.initState();
    getAuthenticationToken();
    setState(() {
      futureTracks = fetchTracks();
    });
  }

  List processItems() {
    return [];
  }

  Future<List<Track>> fetchTracks() async {
    // if (token == null) throw Exception('no token');
    //TODO pagination
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var authenticationToken = prefs.getString('token')!;
    if (authenticationToken == null) {
      throw Exception('token is null');
    }
    //Map<String, String>
    var requestHeaders = {'Authorization': "Bearer $authenticationToken"};
    var items = [];
    var response = await http.get(
        Uri.parse('https://api.spotify.com/v1/me/tracks/?offset=20'),
        headers: requestHeaders);

    if (response.statusCode == 200) {
      final List<Track> data = [];
      // If the server did return a 200 OK response,
      // then parse the JSON.
      var json = jsonDecode(response.body)['items'];
      //     .map((item) => Track.fromJson(item))
      //     .toList();
      for (var i = 0; i < json.length; i++) {
        data.add(Track.fromJson(json[i]));
      }
      setStatus(data.runtimeType.toString());
      return data;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album ${response.statusCode.toString()}');
    }

    while (items.length < jsonDecode(response.body)) {
      response = await http.get(
          //TODOtrhead/oncscorll
          Uri.parse(
              'https://api.spotify.com/v1/me/tracks/?offset=${items.length}'),
          headers: requestHeaders);
      // processIrtems()
    }
  }

  Future<String> getAuthenticationToken() async {
    try {
      //TODO fetch from shared preferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var authenticationToken = prefs.getString('token');
      if (authenticationToken == null || authenticationToken == false) {
        authenticationToken = await SpotifySdk.getAuthenticationToken(
          clientId: dotenv.env['CLIENT_ID'].toString(),
          redirectUrl: dotenv.env['REDIRECT_URL'].toString(),
          scope: 'app-remote-control, '
              'user-modify-playback-state, '
              'playlist-read-private, '
              'playlist-modify-public,'
              'user-read-currently-playing,'
              'user-library-read',
        );
        setStatus('Got a token: $authenticationToken');

        prefs.setString('token', authenticationToken);
      }
      setState(() {
        //update from shared preferences
        token = authenticationToken;
      });
      return token ?? authenticationToken;
    } on PlatformException catch (e) {
      setStatus(e.code, message: e.message);
      return Future.error('$e.code: $e.message');
    } on MissingPluginException {
      setStatus('not implemented');
      return Future.error('not implemented');
    }
  }

  void setStatus(String code, {String? message}) {
    var text = message ?? '';
    _logger.i('$code$text');
  }

  Future<http.Response> fetchSaved() {
    return http.get(Uri.parse('https://jsonplaceholder.typicode.com/albums/1'));
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.dark();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      //home:const App(),
      home: StreamBuilder<ConnectionStatus>(
        stream: SpotifySdk.subscribeConnectionStatus(),
        builder: (context, snapshot) {
          _connected = false;
          var data = snapshot.data;
          if (data != null) {
            _connected = data.connected;
          }
          return Scaffold(
            body: StreamBuilder<ConnectionStatus>(
                stream: SpotifySdk.subscribeConnectionStatus(),
                builder: (context, snapshot) {
                  _connected = false;
                  var data = snapshot.data;
                  if (data != null) {
                    _connected = data.connected;
                  }

                  return SafeArea(
                      child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        // Text(token ?? 'Loading'),
                        // IconButton(
                        //   icon: const Icon(Icons.add),
                        //   onPressed: () {
                        //     setState(() {
                        //       futureTrack = fetchTrack();
                        //     });
                        //   },
                        // ),
                        FutureBuilder<List<Track>>(
                          future: fetchTracks(), //futureTracks,
                          initialData: [],
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return Container(
                                height:
                                    MediaQuery.of(context).size.height - 100,
                                child: ListView.builder(
                                    itemCount: snapshot.data!.length,
                                    itemBuilder:
                                        (BuildContext ctxt, int index) {
                                      return Text(snapshot.data![index].name);
                                    }),
                              );
                            } else if (snapshot.hasError) {
                              return Text('${snapshot.error}');
                            }

                            // By default, show a loading spinner.
                            return const CircularProgressIndicator();
                          },
                        )
                      ],
                    ),
                  )); //PlayerScreen();
                }),
          );
        },
      ),
      title: 'App',
      theme: theme,
      // theme: ThemeData(
      //   brightness: Brightness.light,
      //   /* light theme settings */
      // ),
      // darkTheme: ThemeData(
      //   brightness: Brightness.dark,
      //   /* dark theme settings */
      // ),
      // themeMode: ThemeMode.dark,

      // theme: ThemeData.dark().copyWith(
      //   primaryColor: Colors.green,
      //   elevatedButtonTheme: ElevatedButtonThemeData(
      //     style: ElevatedButton.styleFrom(
      //       onPrimary: Colors.white,
      //       primary: Colors.green,
      //     ),
      //   ),
      // ),

      // routes: {'player': (context) => PlayerScreen()}

      // initialRoute: '/',
      // routes: <String, WidgetBuilder>{
      //   '/': (_) => const App(),
      //   // '/': (_) => const SplashScreen(),
      //   // '/login': (_) => const LoginPage(),
      //   // '/account': (_) => const AccountPage(),
      //   '/dashboard': (_) => const Dashboard(),
      //   '/library': (_) => const LibraryScreen(),
      //   '/player': (_) => const PlayerScreen(),
      // },

      // initialRoute: LoginScreen.route,
      // routes: {
      //   LobbyScreen.route: (context) => LobbyScreen(),
      //   LoginScreen.route: (context) => LoginScreen(),
      //   GameScreen.route: (context) => GameScreen(),
      // },
    );
  }
}

//TODO wrap inherited/bloc/provider for access to spotifySdk
class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  // 7
  int _selectedIndex = 0;

  // 8
  static List<Widget> pages = <Widget>[
    const Dashboard(),
    const SearchScreen(),
    const LibraryScreen(),
  ];

  // 9
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('App', style: Theme.of(context).textTheme.headline6),
      // ),
      body: Stack(
        children: [
          pages[_selectedIndex],
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              BottomNavigationBar(
                selectedItemColor:
                    Theme.of(context).textSelectionTheme.selectionColor,
                currentIndex: _selectedIndex,
                onTap: _onItemTapped,
                items: const <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home_outlined),
                    label: 'home',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.search),
                    label: 'search',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.card_giftcard),
                    label: 'library',
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
      // bottomNavigationBar: BottomNavigationBar(
      //   selectedItemColor: Theme.of(context).textSelectionTheme.selectionColor,
      //   currentIndex: _selectedIndex,
      //   onTap: _onItemTapped,
      //   items: const <BottomNavigationBarItem>[
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.home_outlined),
      //       label: 'home',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.search),
      //       label: 'search',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.card_giftcard),
      //       label: 'library',
      //     ),
      //   ],
      // ),
    );
  }
}

class _InheritedStateContainer extends InheritedWidget {
  // Data is your entire state. In our case just 'User'
  final StateContainerState data;
  // final Logger logger;

  // You must pass through a child and your state.
  const _InheritedStateContainer({
    Key? key,
    required this.data,
    // required this.logger,
    required Widget child,
  }) : super(key: key, child: child);

  // This is a built in method which you can use to check if
  // any state has changed. If not, no reason to rebuild all the widgets
  // that rely on your state.
  @override
  bool updateShouldNotify(_InheritedStateContainer old) => true;
  //{
//     return oldWidget.counter != counter;
//   }

  static _InheritedStateContainer? of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<_InheritedStateContainer>();
  }
}

class StateContainer extends StatefulWidget {
  // You must pass through a child.
  final Widget child;
  // final User user;

  StateContainer({
    required this.child,
    // this.user,
  });

  // This is the secret sauce. Write your own 'of' method that will behave
  // Exactly like MediaQuery.of and Theme.of
  // It basically says 'get the data from the widget of this type.
  static StateContainerState of(BuildContext context, {bool build = true}) {
    return build
        ? context
            .dependOnInheritedWidgetOfExactType<_InheritedStateContainer>()!
            .data
        : context
            .findAncestorWidgetOfExactType<_InheritedStateContainer>()!
            .data;

    // return (context.inheritFromWidgetOfExactType(_InheritedStateContainer)
    //         as _InheritedStateContainer)
    //     .data;
  }

  @override
  StateContainerState createState() => new StateContainerState();
}

class StateContainerState extends State<StateContainer> {
  // Whichever properties you wanna pass around your app as state
  // User user;

  // You can (and probably will) have methods on your StateContainer
  // These methods are then used through our your app to
  // change state.
  // Using setState() here tells Flutter to repaint all the
  // Widgets in the app that rely on the state you've changed.
  // void updateUserInfo({firstName, lastName, email}) {
  // if (user == null) {
  //   user = new User(firstName, lastName, email);
  //   setState(() {
  //     user = user;
  //   });
  // } else {
  //   setState(() {
  //     user.firstName = firstName ?? user.firstName;
  //     user.lastName = lastName ?? user.lastName;
  //     user.email = email ?? user.email;
  //   });
  // }
  //}

  // Simple build method that just passes this state through
  // your InheritedWidget
  @override
  Widget build(BuildContext context) {
    return new _InheritedStateContainer(
      data: this,
      child: widget.child,
    );
  }
}
