import 'package:book_finder_application/feature/home/model/book_data.dart';
import 'package:flutter/material.dart';

@immutable
abstract class HomeState {}

class HomeInitial extends HomeState {}

abstract class HomeActionState extends HomeState {}

class HomeLoadingState extends HomeState {}

class HomeLoadedSuccessState extends HomeState {
  final List<BookDataModel> popularBooks;
  final List<BookDataModel> aiBooks;
  final List<BookDataModel> webDevBooks;
  final List<BookDataModel> programmingBooks;
  final List<BookDataModel> dataScienceBooks;
  final List<BookDataModel> favoriteBooks; // Added favoriteBooks field

  HomeLoadedSuccessState({
    required this.popularBooks,
    required this.aiBooks,
    required this.webDevBooks,
    required this.programmingBooks,
    required this.dataScienceBooks,
    this.favoriteBooks = const [], // Initialize favoriteBooks as an empty list
  });

  // Add the copyWith method
  HomeLoadedSuccessState copyWith({
    List<BookDataModel>? popularBooks,
    List<BookDataModel>? aiBooks,
    List<BookDataModel>? webDevBooks,
    List<BookDataModel>? programmingBooks,
    List<BookDataModel>? dataScienceBooks,
    List<BookDataModel>? favoriteBooks,
  }) {
    return HomeLoadedSuccessState(
      popularBooks: popularBooks ?? this.popularBooks,
      aiBooks: aiBooks ?? this.aiBooks,
      webDevBooks: webDevBooks ?? this.webDevBooks,
      programmingBooks: programmingBooks ?? this.programmingBooks,
      dataScienceBooks: dataScienceBooks ?? this.dataScienceBooks,
      favoriteBooks: favoriteBooks ?? this.favoriteBooks,
    );
  }
}

class HomeErrorState extends HomeState {
  final String message;
  HomeErrorState(this.message);
}

class HomeNavigateToFavouritePageActionState extends HomeActionState {}

class HomeBooksFavouriteActionState extends HomeActionState {}

// Added state for when the favorite books list is updated
class HomeUpdatedFavoriteBooksState extends HomeState {
  final List<BookDataModel> favoriteBooks;
  HomeUpdatedFavoriteBooksState(this.favoriteBooks);
}
