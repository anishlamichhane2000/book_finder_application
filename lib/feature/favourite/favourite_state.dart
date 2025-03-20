import '../../feature/home/model/book_data.dart';

abstract class FavouriteState {}

class FavouriteInitial extends FavouriteState {}

class FavouriteLoadingState extends FavouriteState {}

class FavouriteLoadingSuccessState extends FavouriteState {
  final List<BookDataModel> favouriteBooks;

  FavouriteLoadingSuccessState({required this.favouriteBooks});
}

class FavouriteErrorState extends FavouriteState {
  final String errorMessage;

  FavouriteErrorState({required this.errorMessage});
}
