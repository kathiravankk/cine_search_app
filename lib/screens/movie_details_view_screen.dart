import 'package:cine_search_app/bloc/movie_detail_bloc.dart';
import 'package:cine_search_app/model/movie_view_model.dart';
import 'package:cine_search_app/utils/app_theme_manager.dart';
import 'package:cine_search_app/utils/icon_images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MovieDetailsViewScreen extends StatelessWidget {
  final String imDbNum;
  final String movieName;
  final String moviePoster;

  const MovieDetailsViewScreen({
    super.key,
    required this.imDbNum,
    required this.movieName, required this.moviePoster,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MovieDetailBloc(),
      child: MovieDetailsView(imdbID: imDbNum, movieName: movieName, moviePoster: moviePoster,),
    );
  }
}

class MovieDetailsView extends StatefulWidget {
  final String imdbID;
  final String movieName;
  final String moviePoster;

  const MovieDetailsView({
    super.key,
    required this.imdbID,
    required this.movieName, required this.moviePoster,
  });

  @override
  State<MovieDetailsView> createState() => _MovieDetailsViewState();
}

class _MovieDetailsViewState extends State<MovieDetailsView> {
  late MovieDetailBloc movieBloc;

  @override
  void initState() {
    super.initState();
    viewMoviesData();
  }

  void viewMoviesData() {
    MovieDetailBloc movieBloc = BlocProvider.of<MovieDetailBloc>(context);
    movieBloc.add(ViewMovieEvent(widget.imdbID));
  }

  @override
  Widget build(BuildContext context) {
    print(widget.moviePoster);
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(image: NetworkImage(widget.moviePoster,), fit: BoxFit.cover)
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: AppThemeManager.backGroundColor,
          title: Text(
            widget.movieName,
            style: AppThemeManager.customTextStyleWithSize(
              size: 14,
              color: AppThemeManager.primaryColor,
              weight: FontWeight.w600,
            ),
          ),
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios,
              size: 20,
              color: AppThemeManager.primaryColor,
            ),
          ),
        ),

        body: BlocBuilder<MovieDetailBloc, MovieDetailState>(
          builder: (context, state) {
            if (state is ViewMovieLoading) {
              return const Center(child: CircularProgressIndicator(color: AppThemeManager.primaryColor,));
            } else if (state is ViewMovieSuccess) {
              print("#################");
              final MovieViewModel movie = state.responseModel;
              return Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                   // height: MediaQuery.of(context).size.height,
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.85),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(25),
                        topRight: Radius.circular(25),
                      ),
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        spacing: 10,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            movie.title!,
                            style: AppThemeManager.customTextStyleWithSize(
                              size: 22,
                              weight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Row(
                            spacing: 10,
                            children: [
                              iconText(Icons.star_border,movie.imdbRating! ),
                              iconText(Icons.access_time_sharp, movie.runtime!),
                            ],
                          ),
                          Row(
                            spacing: 10,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: movie.genre!.split(',').map((e) {
                              return Container(
                                decoration: BoxDecoration(
                                  color: AppThemeManager.hintColor,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                child: Text(e.trim(),
                                style:  AppThemeManager.customTextStyleWithSize(size: 10, weight: FontWeight.w500),),
                              );
                            }).toList(),
                          ),
                          Text(
                            movie.plot!,
                            style: const TextStyle(color: Colors.white70),
                          ),
                          buildRowText("Director", movie.director!),
                          buildRowText("Writer", movie.writer!),
                          buildRowText("Actors", movie.actors!),
                          SizedBox(height: 20,)
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }

            return  Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(IconImages.emptyImage, height: 100, width: 100,),
                  Text("No Results Found", style: AppThemeManager.customTextStyleWithSize(size:14, color: Colors.white)),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget iconText(IconData icon, String content){
    return Row(
      spacing: 5,
      children: [
        Icon(icon, size: 15,color: Colors.yellow,),
        Text(content, style: AppThemeManager.customTextStyleWithSize(size: 10, weight: FontWeight.w300, color: Colors.white70),)
      ],
    );
  }

  Widget buildRowText(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: "$title: ",
               style: AppThemeManager.customTextStyleWithSize(
                size: 12,
                color: Colors.white,
                weight: FontWeight.w700,
              ),
            ),
            TextSpan(
              text: value,
              style: AppThemeManager.customTextStyleWithSize(size: 12, color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }
}
