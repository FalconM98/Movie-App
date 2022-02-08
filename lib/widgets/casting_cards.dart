import 'package:flutter/cupertino.dart';
import 'package:flutter_movie_app/models/models.dart';
import 'package:flutter_movie_app/providers/movies_providers.dart';
import 'package:provider/provider.dart';

class CastingCards extends StatelessWidget {
  final int movieid;
  const CastingCards({Key? key, required this.movieid}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final moviesProvider = Provider.of<MoviesProvider>(context, listen: false);

    return FutureBuilder(
      future: moviesProvider.getMovieCast(movieid),
      builder: (_, AsyncSnapshot<List<Cast>> snapshot) {
        if (!snapshot.hasData) {
          return Container(
              constraints: BoxConstraints(maxWidth: 150),
              height: 180,
              child: CupertinoActivityIndicator());
        }

        //Se pide los datos del cast
        final cast = snapshot.data;

        return Container(
          margin: EdgeInsets.only(bottom: 30),
          width: double.infinity,
          height: 200,
          child: ListView.builder(
            itemBuilder: (_, int index) => _CastCards(actors: cast![index]),
            itemCount: 8,
            scrollDirection: Axis.horizontal,
          ),
        );
      },
    );
  }
}

class _CastCards extends StatelessWidget {
  final Cast actors;
  const _CastCards({Key? key, required this.actors}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 110,
        height: 100,
        margin: EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: FadeInImage(
                placeholder: AssetImage('assets/loading.gif'),
                image: NetworkImage(actors.fullProfilePath),
                fit: BoxFit.cover,
                height: 150,
                width: 100,
              ),
            ),
            SizedBox(height: 5),
            Text(actors.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center),
          ],
        ));
  }
}
