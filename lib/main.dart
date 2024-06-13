import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hexagonguardians/pages/addClient/add_client.dart';
import 'package:hexagonguardians/pages/atec/atec.dart';
import 'package:hexagonguardians/pages/clientDetail/client_detail.dart';
import 'package:hexagonguardians/pages/createClient/create_client.dart';
import 'package:hexagonguardians/pages/detailAtec/detail_atec.dart';
import 'package:hexagonguardians/pages/removeClient/delete_client.dart';
import 'package:hexagonguardians/pages/home/home.dart';
import 'package:hexagonguardians/pages/login/login.dart';

final _router = GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(
      path: '/home',
      name: 'home',
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      path: '/login',
      name: 'login',
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: '/atec/:id',
      name: 'atec',
      builder: (context, state) {
        final userId = state.pathParameters['id'] ?? '0';
        return Atec(client: userId);
      },
    ),
    GoRoute(
        path: '/detailclient/:id/:name',
        name: 'detailclient',
        builder: (context, state) {
          final userId = state.pathParameters['id'] ?? '0';
          final userName = state.pathParameters['name'] ?? '';

          return ClientDetail(
            id: userId,
            name: userName,
          );
        }),
    GoRoute(
        path: '/detailavaliation/:id',
        name: 'detailavaliation',
        builder: (context, state) {
          final avaliationId = state.pathParameters['id'] ?? '0';

          return AvaliationDetail(
            id: int.parse(avaliationId),
          );
        }),
    GoRoute(
        path: '/addclient',
        name: 'addclient',
        builder: (context, state) => const AddClient()),
    GoRoute(
        path: '/removeclient',
        name: 'removeclient',
        builder: (context, state) => const RemoveClient()),
    GoRoute(
        path: '/createclient',
        name: 'createclient',
        builder: (context, state) => const CreateClient())
  ],
);

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        //theme: ThemeData.dark(),
        //--------------------------------------------
        // theme: ThemeData(
        //   colorScheme: ColorScheme.fromSeed(
        //     seedColor: Colors.lightBlue,
        //     background: Color(0xFF1E1E1E),
        //   ),
        //   useMaterial3: true,
        //   drawerTheme: DrawerThemeData(
        //     backgroundColor: Color(0xFF070707), // Cor de fundo do Drawer
        //   ),
        //   listTileTheme: ListTileThemeData(textColor: Colors.white),
        //   //iconTheme: IconThemeData(color: Colors.white),
        //   //iconButtonTheme: IconButtonThemeData(),
        //   //
        //   //
        //   //primaryIconTheme: IconThemeData(color: Colors.white),
        //   textTheme: const TextTheme(
        //     bodyLarge:
        //         TextStyle(color: Colors.white), // Cor do texto para bodyText1
        //     bodyMedium: TextStyle(color: Color()),
        //     bodySmall: TextStyle(color: Colors.white),
        //   ),
        // ),
        //------------------------------------------------------
        theme: ThemeData(
          brightness: Brightness.dark, // Define o tema como escuro
          primaryColor: Colors.purple[200],
          scaffoldBackgroundColor: const Color(0xFF121212),
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF1F1F1F),
            foregroundColor: Colors.white,
          ),
          drawerTheme: const DrawerThemeData(
            backgroundColor: Color(0xFF1F1F1F),
            elevation: 16,
          ),
          cardColor: const Color(0xFF1F1F1F),
          iconTheme: const IconThemeData(
            color: Colors.white,
          ),
          inputDecorationTheme: const InputDecorationTheme(
            filled: true,
            fillColor: Color(0xFF303030),
            // enabledBorder: OutlineInputBorder(
            //   borderSide: BorderSide(color: Colors.red),
            // ),
            focusedBorder: OutlineInputBorder(
                //borderSide: BorderSide(color: Colors.lightBlue, width: 1.0),
                ),
            //labelStyle: TextStyle(color: Colors.green),
            hintStyle: TextStyle(color: Colors.white),
          ),
          buttonTheme: const ButtonThemeData(
            buttonColor: Colors.deepPurpleAccent,
            textTheme: ButtonTextTheme.primary,
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple[200],
              foregroundColor: Colors.white,
            ),
          ),
          floatingActionButtonTheme: const FloatingActionButtonThemeData(
            backgroundColor: Colors.deepPurpleAccent,
          ),
          checkboxTheme: CheckboxThemeData(
            checkColor: MaterialStateProperty.all(Colors.white),
            fillColor: MaterialStateProperty.all(Colors.purple[200]),
          ),
        ),
        routerConfig: _router);
  }
}
