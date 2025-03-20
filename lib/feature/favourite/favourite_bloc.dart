import 'package:book_finder_application/database_finder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'favourite_event.dart';
import 'favourite_state.dart';

class FavouriteBloc extends Bloc<FavouriteEvent, FavouriteState> {
  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;

  FavouriteBloc() : super(FavouriteInitial()) {
    on<FavouriteInitialEvent>(_onFavouriteInitialEvent);
    on<RemoveFromFavouriteEvent>(_onRemoveFromFavouriteEvent);
    on<AddToFavouriteEvent>(_onAddToFavouriteEvent);
  }

  Future<void> _onFavouriteInitialEvent(
      FavouriteInitialEvent event, Emitter<FavouriteState> emit) async {
    emit(FavouriteLoadingState());
    try {
      final favouriteBooksList = await _databaseHelper.getFavouriteBooks();
      emit(FavouriteLoadingSuccessState(favouriteBooks: favouriteBooksList));
    } catch (e) {
      emit(FavouriteErrorState(errorMessage: "Failed to load favorites: ${e.toString()}"));
    }
  }

  Future<void> _onRemoveFromFavouriteEvent(
      RemoveFromFavouriteEvent event, Emitter<FavouriteState> emit) async {
    try {
      await _databaseHelper.removeFavourite(event.bookId);
      final updatedBooksList = await _databaseHelper.getFavouriteBooks();
      emit(FavouriteLoadingSuccessState(favouriteBooks: updatedBooksList));
    } catch (e) {
      emit(FavouriteErrorState(errorMessage: "Failed to remove from favorites: ${e.toString()}"));
    }
  }

  Future<void> _onAddToFavouriteEvent(
      AddToFavouriteEvent event, Emitter<FavouriteState> emit) async {
    try {
      await _databaseHelper.addFavourite(event.book);
      final updatedBooksList = await _databaseHelper.getFavouriteBooks();
      emit(FavouriteLoadingSuccessState(favouriteBooks: updatedBooksList));
    } catch (e) {
      emit(FavouriteErrorState(errorMessage: "Failed to add to favorites: ${e.toString()}"));
    }
  }
}
