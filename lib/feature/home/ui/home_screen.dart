import 'package:book_finder_application/feature/favourite/ui/favourite_page.dart';
import 'package:book_finder_application/feature/home/home_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:book_finder_application/feature/home/model/book_data.dart';
import 'package:book_finder_application/feature/home/ui/book_tile.dart';

import '../home_state.dart';

class HomeScreen extends StatefulWidget {
  final VoidCallback onThemeToggle; 

  const HomeScreen({super.key, required this.onThemeToggle});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final HomeBloc homeBloc = HomeBloc();
  int _selectedTabIndex = 0;

  final List<String> tabTitles = [
    "Popular",
    "Artificial Intelligence",
    "Web Development",
    "Programming",
    "Data Science"
  ];

  @override
  void initState() {
    homeBloc.add(HomeInitialEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeBloc, HomeState>(
      bloc: homeBloc,
      listenWhen: (previous, current) => current is HomeActionState,
      buildWhen: (previous, current) => current is! HomeActionState,
      listener: (context, state) {
        if (state is HomeErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        } else if (state is HomeNavigateToFavouritePageActionState) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const FavouriteScreen(),
            ),
          );
        } else if (state is HomeBooksFavouriteActionState) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Book has been added to favorites!")),
          );
        }
      },
      builder: (context, state) {
        if (state is HomeLoadingState) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (state is HomeLoadedSuccessState) {
          return Scaffold(
            appBar: AppBar(
              title: const Text(
                "Welcome to Book Finder App",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    homeBloc.add(HomeFavouriteNavigateButtonClickedEvent());
                  },
                  icon: const Icon(Icons.favorite_border_outlined),
                ),
                IconButton(
                  icon: const Icon(Icons.light_mode),
                  onPressed:
                      widget.onThemeToggle, 
                ),
              ],
            ),
            body: _buildBody(state),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: _selectedTabIndex,
              onTap: (index) {
                setState(() {
                  _selectedTabIndex = index;
                });
                // Fetch books for the selected category
                switch (index) {
                  case 0:
                    homeBloc.add(HomeInitialEvent()); // Fetch Popular Books
                    break;
                  case 1:
                    homeBloc.add(FetchBooksByCategoryEvent(
                        category: "Artificial+Intelligence"));
                    break;
                  case 2:
                    homeBloc.add(
                        FetchBooksByCategoryEvent(category: "Web+Development"));
                    break;
                  case 3:
                    homeBloc.add(
                        FetchBooksByCategoryEvent(category: "Programming"));
                    break;
                  case 4:
                    homeBloc.add(
                        FetchBooksByCategoryEvent(category: "Data+Science"));
                    break;
                }
              },
              selectedItemColor: Colors.blue,
              unselectedItemColor: Colors.grey,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.star),
                  label: "Popular",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.auto_awesome),
                  label: "AI",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.code),
                  label: "Web Dev",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.computer),
                  label: "Programming",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.analytics),
                  label: "Data Science",
                ),
              ],
            ),
          );
        }

        return const Scaffold(
          body: Center(
            child: Text("Error loading books!"),
          ),
        );
      },
    );
  }

  Widget _buildBody(HomeLoadedSuccessState state) {
    final books = _getBooksForSelectedTab(state);

    if (_selectedTabIndex == 0 && state.popularBooks.isNotEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              "Top 3 Popular Tech Books",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(
            height: 500, 
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              itemCount: state.popularBooks.length,
              itemBuilder: (context, index) {
                return SizedBox(
                  width: 300,
                  child: BookTile(
                    bookDataModel: state.popularBooks[index],
                    homeBloc: homeBloc,
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),

           //Only show the book list if there are books
          if (books.isNotEmpty) _buildBookList(books),
        ],
      );
    } else {
      return _buildBookList(books);
    }
  }

  //Get Books for Selected Tab
  List<BookDataModel> _getBooksForSelectedTab(HomeLoadedSuccessState state) {
    switch (_selectedTabIndex) {
      case 1:
        return state.aiBooks;
      case 2:
        return state.webDevBooks;
      case 3:
        return state.programmingBooks;
      case 4:
        return state.dataScienceBooks;
      default:
        return [];
    }
  }

  //Build List of Books
  Widget _buildBookList(List<BookDataModel> books) {
    if (books.isEmpty) {
      return const Center(
        child: Text("No books found in this category."),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(10),
      itemCount: books.length,
      itemBuilder: (context, index) {
        return BookTile(bookDataModel: books[index], homeBloc: homeBloc);
      },
    );
  }
}
