part of 'home_bloc.dart';

@immutable
abstract class HomeEvent {}

class HomeInitialEvent extends HomeEvent {}

class FetchBooksByCategoryEvent extends HomeEvent {
  final String category;
  FetchBooksByCategoryEvent({required this.category});
}

class ToggleThemeEvent extends HomeEvent {}

class HomeBooksFavouriteButtonClickedEvent extends HomeEvent {
  late final BookDataModel clickedBook;

  HomeBooksFavouriteButtonClickedEvent({required this.clickedBook});
}

class HomeFavouriteNavigateButtonClickedEvent extends HomeEvent {}
