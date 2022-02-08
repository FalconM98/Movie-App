import 'package:flutter_movie_app/providers/movies_providers.dart';
import 'package:flutter_movie_app/search/search_deletegate.dart';
import 'package:flutter_movie_app/widgets/card_swiper.dart';
import 'package:flutter_movie_app/widgets/movie_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreens extends StatelessWidget {
  const HomeScreens({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //Instancia de MoviesProviders
    final moviesProvider = Provider.of<MoviesProvider>(context);
    return Scaffold(
        appBar: AppBar(
          title: Text('Películas'),
          centerTitle: true,
          elevation: 0,
          actions: [
            IconButton(
                icon: Icon(Icons.search_outlined),
                onPressed: () {
                  showSearch(context: context, delegate: MovieSearchDelegate());
                })
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              //Tarjeta Principal
              CardSwiper(movies: moviesProvider.onDisplayMovie),
              //Movie Slide
              MovieSlider(
                movies: moviesProvider.popularMovie,
                title: 'Populares!!!',
                nextPage: () {
                  moviesProvider.getOnPopularMovies();
                },
              )
            ],
          ),
        ));
  }
}
