import 'package:flutter/material.dart';
import 'package:flutter_movie_app/providers/movies_providers.dart';
import 'package:flutter_movie_app/screens/details_screens.dart';
import 'package:flutter_movie_app/screens/home_screens.dart';
import 'package:provider/provider.dart';

void main() => runApp(AppState());

//Se inicializa la instancia
class AppState extends StatelessWidget {
  const AppState({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MoviesProvider(), lazy: false)
      ],
      child: MyApp(),
    );
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Películas',
      initialRoute: 'home',
      routes: {
        'home': (_) => HomeScreens(),
        'details': (_) => DetailsScreens()
      },
      theme: ThemeData.dark()
          .copyWith(appBarTheme: AppBarTheme(color: Colors.indigo)),
    );
  }
}
