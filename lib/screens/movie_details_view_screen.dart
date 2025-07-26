import 'package:cine_search_app/bloc/movie_detail_bloc.dart';
import 'package:cine_search_app/model/movie_view_model.dart';
import 'package:cine_search_app/utils/app_theme_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MovieDetailsViewScreen extends StatelessWidget {
  final String imDbNum;
  final String movieName;

  const MovieDetailsViewScreen({
    super.key,
    required this.imDbNum,
    required this.movieName,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MovieDetailBloc(),
      child: MovieDetailsView(imdbID: imDbNum, movieName: movieName),
    );
  }
}

class MovieDetailsView extends StatefulWidget {
  final String imdbID;
  final String movieName;

  const MovieDetailsView({
    super.key,
    required this.imdbID,
    required this.movieName,
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
    return Scaffold(
      backgroundColor: AppThemeManager.backGroundColor,
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
            return const Center(child: CircularProgressIndicator());
          } else if (state is ViewMovieSuccess) {
            final MovieViewModel movie = state.responseModel;

            return Stack(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.5,
                  width: double.infinity,
                  child: Image.network(movie.poster!, fit: BoxFit.cover),
                ),
                Positioned(
                  top: 40,
                  left: 10,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.85),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(25),
                        topRight: Radius.circular(25),
                      ),
                    ),
                    child: SingleChildScrollView(
                      child: Column(
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
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(
                                Icons.star,
                                size: 16,
                                color: Colors.yellow,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                movie.imdbRating!,
                                style: const TextStyle(color: Colors.white),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                movie.runtime!,
                                style: const TextStyle(color: Colors.white70),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            children: movie.genre!.split(',').map((e) {
                              return Chip(
                                label: Text(e.trim()),
                                backgroundColor: AppThemeManager.primaryColor
                                    .withOpacity(0.2),
                                labelStyle: const TextStyle(
                                  color: Colors.white,
                                ),
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            movie.plot!,
                            style: const TextStyle(color: Colors.white70),
                          ),
                          const SizedBox(height: 12),
                          _buildMetaText("Director", movie.director!),
                          _buildMetaText("Writer", movie.writer!),
                          _buildMetaText("Actors", movie.actors!),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          }

          return const Center(
            child: Text("No Data Found", style: TextStyle(color: Colors.white)),
          );
        },
      ),
    );
  }

  Widget _buildMetaText(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: "$title: ",
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextSpan(
              text: value,
              style: const TextStyle(color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }
}
