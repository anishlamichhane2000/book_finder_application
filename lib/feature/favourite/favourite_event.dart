import '../../feature/home/model/book_data.dart';

abstract class FavouriteEvent {}

class FavouriteInitialEvent extends FavouriteEvent {}

class AddToFavouriteEvent extends FavouriteEvent {
  final BookDataModel book;

  AddToFavouriteEvent({required this.book});
}

class RemoveFromFavouriteEvent extends FavouriteEvent {
  final String bookId;

  RemoveFromFavouriteEvent({required this.bookId});
}
