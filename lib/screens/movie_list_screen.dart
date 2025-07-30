import 'package:cine_search_app/bloc/movie_detail_bloc.dart';
import 'package:cine_search_app/screens/widget/movie_profile_widget.dart';
import 'package:cine_search_app/utils/app_theme_manager.dart';
import 'package:cine_search_app/utils/icon_images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marquee/marquee.dart';

import 'movie_details_view_screen.dart';

class MovieListScreen extends StatelessWidget {
  const MovieListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MovieDetailBloc(),
      child: MovieListView(),
    );
  }
}

class MovieListView extends StatefulWidget {
  const MovieListView({super.key});

  @override
  State<MovieListView> createState() => _MovieListViewState();
}

class _MovieListViewState extends State<MovieListView> {
  @override
  void initState() {
    searchController.text = "avengers";
    getMoviesData();
    super.initState();
  }

  void getMoviesData() {
    MovieDetailBloc movieBloc = BlocProvider.of<MovieDetailBloc>(context);
    movieBloc.add(GetMovieDetailEvent(searchController.text));
  }

  final searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppThemeManager.backGroundColor,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              spacing: 10,
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundImage: AssetImage(IconImages.userImage),
                ),
                Column(
                  spacing: 5,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Welcome Back!",
                      style: AppThemeManager.customTextStyleWithSize(
                        size: 14,
                        color: AppThemeManager.primaryColor,
                        weight: FontWeight.w300,
                      ),
                    ),
                    Text(
                      "CineSearch User!",
                      style: AppThemeManager.customTextStyleWithSize(
                        size: 14,
                        color: AppThemeManager.primaryColor,
                        weight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                Spacer(),
                Image.asset(IconImages.categoryImage, height: 25, width: 25),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(color: AppThemeManager.fieldColor),
            height: 35,
            padding: EdgeInsets.all(5),
            child: Center(
              child: Marquee(
                text:
                    "* Discover Movies | Search by Title | Smooth Animations | Offline Access with Caching | Built with Flutter *",
                style: AppThemeManager.customTextStyleWithSize(
                  weight: FontWeight.w500,
                  size: 14,
                  color: AppThemeManager.primaryColor,
                ),
                scrollAxis: Axis.horizontal,
                blankSpace: 60.0,
                velocity: 30.0,
                pauseAfterRound: Duration(seconds: 1),
                startPadding: 10.0,
                accelerationDuration: Duration(seconds: 1),
                decelerationDuration: Duration(milliseconds: 500),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              controller: searchController,
              onSubmitted: (value) {
                context.read<MovieDetailBloc>().add(
                  GetMovieDetailEvent(value.trim()),
                );
              },
              style: AppThemeManager.customTextStyleWithSize(
                size: 13,
                color: Colors.white,
                weight: FontWeight.w500,
              ),
              decoration: InputDecoration(
                hintText: 'Search movies',
                filled: true,
                hintStyle: AppThemeManager.customTextStyleWithSize(
                  size: 12,
                  color: AppThemeManager.hintColor,
                ),
                fillColor: AppThemeManager.fieldColor,
                prefixIcon: Icon(
                  Icons.search_sharp,
                  color: AppThemeManager.hintColor,
                  size: 30,
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: AppThemeManager.primaryColor),
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
                border: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.transparent),
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
              ),
            ),
          ),
          Expanded(
            child: BlocListener<MovieDetailBloc, MovieDetailState>(
              listener: (context, state) {
                if (state is MovieDetailFailure) {
                  //AppAlertController().showAlert(message: state.message);
                }
              },
              child: BlocBuilder<MovieDetailBloc, MovieDetailState>(
                builder: (context, state) {
                  if (state is MovieDetailLoading) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: AppThemeManager.primaryColor,
                      ),
                    );
                  }

                  if (state is MovieDetailSuccess) {
                    return GridView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.70,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 10,
                          ),
                      itemCount: state.responseModel.search!.length ?? 0,
                      itemBuilder: (context, index) {
                        final movie = state.responseModel.search![index];
                        return MovieProfileWidget(
                          viewFunction: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MovieDetailsViewScreen(
                                  movieName: movie.title!,
                                  imDbNum: movie.imdbID!,
                                  moviePoster: movie.poster!,
                                ),
                              ),
                            );
                          },
                          imageUrl: movie.poster!,
                          movieTitle: movie.title!,
                          year: movie.year!,
                        );
                      },
                    );
                  }

                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          IconImages.emptyImage,
                          height: 100,
                          width: 100,
                        ),
                        Text(
                          "No Results Found",
                          style: AppThemeManager.customTextStyleWithSize(
                            size: 14,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
