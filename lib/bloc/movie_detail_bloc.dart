import 'package:cine_search_app/api/app_api_manager.dart';
import 'package:cine_search_app/model/movie_details_model.dart';
import 'package:cine_search_app/model/movie_view_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MovieDetailBloc extends Bloc<MovieDetailEvent, MovieDetailState> {
  MovieDetailBloc() : super(MovieDetailInitial()) {
    on<MovieDetailEvent>((event, emit) async {
      if(event is GetMovieDetailEvent){
        emit(MovieDetailLoading());
        emit(await fetchMovieDetail(event.searchQuery));
      }
      if(event is ViewMovieEvent){
        emit(ViewMovieLoading());
        emit(await getViewMovie(event.imdbID));
      }

    });
  }

  Future<MovieDetailState> fetchMovieDetail(String searchQuery) async {
    late MovieDetailState state;

    await AppApiManager.getMovieDetail(
      searchQuery: searchQuery,
      successBlock: (data) {
        final responseModel = MovieDetailsModel.fromJson(data);
        state = MovieDetailSuccess(responseModel: responseModel);
      },
      failureBlock: (exception) {
        state = MovieDetailFailure(message: exception.toString());
      },
    );

    return state;
  }
}

Future<MovieDetailState> getViewMovie(String imDbNumber) async {
  late MovieDetailState state;

  await AppApiManager.viewMovieDetail(
    imDbID: imDbNumber,
    successBlock: (data) {
      final responseModel = MovieViewModel.fromJson(data);
      state = ViewMovieSuccess(responseModel: responseModel);
    },
    failureBlock: (exception) {
      state = ViewMovieFailure(message: exception.toString());
    },
  );

  return state;
}


abstract class MovieDetailState extends Equatable {
  @override
  List<Object?> get props => [];
}

class MovieDetailInitial extends MovieDetailState {}

class MovieDetailLoading extends MovieDetailState {}

class ViewMovieLoading extends MovieDetailState {}

class ViewMovieSuccess extends MovieDetailState {
  final MovieViewModel responseModel;
  ViewMovieSuccess({required this.responseModel});

  @override
  List<Object?> get props => [responseModel];
}

class MovieDetailSuccess extends MovieDetailState {
  final MovieDetailsModel responseModel;
  MovieDetailSuccess({required this.responseModel});

  @override
  List<Object?> get props => [responseModel];
}

class MovieDetailFailure extends MovieDetailState {
  final String message;
  MovieDetailFailure({required this.message});

  @override
  List<Object?> get props => [message];
}

class ViewMovieFailure extends MovieDetailState {
  final String message;
  ViewMovieFailure({required this.message});

  @override
  List<Object?> get props => [message];
}


abstract class MovieDetailEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetMovieDetailEvent extends MovieDetailEvent {
  final String searchQuery;

  GetMovieDetailEvent(this.searchQuery);

  @override
  List<Object?> get props => [searchQuery];
}

class ViewMovieEvent extends MovieDetailEvent {
  final String imdbID;

  ViewMovieEvent(this.imdbID);

  @override
  List<Object?> get props => [imdbID];
}


