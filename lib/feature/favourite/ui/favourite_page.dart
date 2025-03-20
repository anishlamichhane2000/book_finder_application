import 'package:book_finder_application/feature/favourite/favourite_bloc.dart';
import 'package:book_finder_application/feature/favourite/favourite_event.dart';
import 'package:book_finder_application/feature/favourite/ui/favourite_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../favourite_state.dart';

class FavouriteScreen extends StatefulWidget {
  const FavouriteScreen({super.key});

  @override
  State<FavouriteScreen> createState() => _FavouriteScreenState();
}

class _FavouriteScreenState extends State<FavouriteScreen> {
  final FavouriteBloc favouriteBloc = FavouriteBloc();

  @override
  void initState() {
    super.initState();
    favouriteBloc.add(FavouriteInitialEvent());
  }

  @override
  void dispose() {
    favouriteBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: const Text('Favourite Books'),
      ),
      body: BlocConsumer<FavouriteBloc, FavouriteState>(
        bloc: favouriteBloc,
        listener: (context, state) {},
        builder: (context, state) {
          if (state is FavouriteLoadingState) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is FavouriteLoadingSuccessState) {
            final favouriteBooks = state.favouriteBooks;
            if (favouriteBooks.isEmpty) {
              return const Center(child: Text('No favorite books yet.'));
            }

            return ListView.builder(
              itemCount: favouriteBooks.length,
              itemBuilder: (context, index) {
                return FavouriteTile(
                  bookDataModel: favouriteBooks[index],
                  favouriteBloc: favouriteBloc,
                );
              },
            );
          }

          if (state is FavouriteErrorState) {
            return Center(child: Text(state.errorMessage));
          }

          return const SizedBox();
        },
      ),
    );
  }
}
