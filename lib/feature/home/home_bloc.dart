import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import '../../database_finder.dart';
import 'home_state.dart';
import 'model/book_data.dart';

part 'home_event.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;

  HomeBloc() : super(HomeInitial()) {
    on<HomeInitialEvent>(_homeInitialFetchEvent);
    on<FetchBooksByCategoryEvent>(_fetchBooksByCategoryEvent);
    on<HomeBooksFavouriteButtonClickedEvent>(_homeBooksFavoriteButtonClickedEvent);
    on<HomeFavouriteNavigateButtonClickedEvent>(_homeFavouriteNavigateButtonClickedEvent);
  }

  FutureOr<void> _homeInitialFetchEvent(
      HomeInitialEvent event, Emitter<HomeState> emit) async {
    var client = http.Client();
    try {
      emit(HomeLoadingState()); // Emit loading state

      // Fetch books from the API
      final response = await client.get(Uri.parse(
          'https://www.googleapis.com/books/v1/volumes?q=subject:Technology&key=AIzaSyB-CVGLyLY59V2Emz3SxpAqSSpim67hOnQ'));

      if (response.statusCode == 200) {
        // Parse the books and take the first 3
        final List<BookDataModel> books = _parseBooks(response).take(3).toList();
        debugPrint('Fetched ${books.length} books'); // Log number of books fetched

        // Emit success state with the fetched books
        emit(HomeLoadedSuccessState(
          popularBooks: books,
          aiBooks: [],
          webDevBooks: [],
          programmingBooks: [],
          dataScienceBooks: [],
        ));
      } else {
        // Emit error state if the API request fails
        emit(HomeErrorState("Failed to load books. Error: ${response.statusCode}"));
      }
    } catch (e) {
      // Emit error state if an exception occurs
      debugPrint('Error in _homeInitialFetchEvent: $e'); // Log the error
      emit(HomeErrorState("An error occurred: ${e.toString()}"));
    } finally {
      client.close(); // Close the HTTP client
    }
  }

  FutureOr<void> _fetchBooksByCategoryEvent(
      FetchBooksByCategoryEvent event, Emitter<HomeState> emit) async {
    var client = http.Client();
    try {
      emit(HomeLoadingState()); // Emit loading state

      // Fetch books by category from the API
      final response = await client.get(Uri.parse(
          'https://www.googleapis.com/books/v1/volumes?q=subject:${event.category}&key=AIzaSyB-CVGLyLY59V2Emz3SxpAqSSpim67hOnQ'));

      if (response.statusCode == 200) {
        // Parse the books
        final books = _parseBooks(response);
        debugPrint('Fetched ${books.length} books for category: ${event.category}'); 

        // Emit success state with the fetched books for the specific category
        emit(HomeLoadedSuccessState(
          popularBooks: [],
          aiBooks: event.category == "Artificial+Intelligence" ? books : [],
          webDevBooks: event.category == "Web+Development" ? books : [],
          programmingBooks: event.category == "Programming" ? books : [],
          dataScienceBooks: event.category == "Data+Science" ? books : [],
        ));
      } else {
        // Emit error state if the API request fails
        emit(HomeErrorState("Failed to load ${event.category} books."));
      }
    } catch (e) {
      // Emit error state if an exception occurs
      debugPrint('Error in _fetchBooksByCategoryEvent: $e'); 
      emit(HomeErrorState("An error occurred: ${e.toString()}"));
    } finally {
      client.close(); // Close the HTTP client
    }
  }

  FutureOr<void> _homeBooksFavoriteButtonClickedEvent(
      HomeBooksFavouriteButtonClickedEvent event, Emitter<HomeState> emit) async {
    try {
      // Check if the book already exists in favorites
      final existingBook = await _databaseHelper.getBookById(event.clickedBook.id);

      if (existingBook != null) {
        // If the book exists, remove it from favorites
        await _databaseHelper.removeFavourite(event.clickedBook.id);
        debugPrint('Removed book from favorites: ${event.clickedBook.title}');
      } else {
        // If the book doesn't exist, add it to favorites
        await _databaseHelper.addFavourite(event.clickedBook);
        debugPrint('Added book to favorites: ${event.clickedBook.title}');
      }

      // Fetch updated favorite books from the database
      final updatedFavorites = await _databaseHelper.getFavouriteBooks();
      debugPrint('Updated favorites: ${updatedFavorites.length} books');

      // Emit the updated favorites state without disrupting the home screen's state
      if (state is HomeLoadedSuccessState) {
        final currentState = state as HomeLoadedSuccessState;
        emit(currentState.copyWith(favoriteBooks: updatedFavorites));
      }
    } catch (e) {
      // Emit error state if an exception occurs
      debugPrint('Error in _homeBooksFavoriteButtonClickedEvent: $e'); // Log the error
      emit(HomeErrorState("An error occurred: ${e.toString()}"));
    }
  }

  FutureOr<void> _homeFavouriteNavigateButtonClickedEvent(
      HomeFavouriteNavigateButtonClickedEvent event, Emitter<HomeState> emit) {
    // Emit navigation state to navigate to the favorites page
    emit(HomeNavigateToFavouritePageActionState());
  }

  // Helper method to parse books from the API response
  List<BookDataModel> _parseBooks(http.Response response) {
    final data = jsonDecode(response.body);
    debugPrint('Parsed JSON data: $data'); 

    return (data['items'] as List).map((book) {
      debugPrint('Book data: $book'); 
      return BookDataModel.fromJson(book);
    }).toList();
  }
}