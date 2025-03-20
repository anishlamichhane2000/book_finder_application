import 'package:book_finder_application/feature/home/home_bloc.dart';
import 'package:book_finder_application/feature/home/model/book_data.dart';
import 'package:book_finder_application/feature/home/ui/home_detail_screen.dart';
import 'package:flutter/material.dart';

class BookTile extends StatelessWidget {
  final BookDataModel bookDataModel;
  final HomeBloc homeBloc;

  const BookTile({
    super.key,
    required this.bookDataModel,
    required this.homeBloc,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to the HomeDetailsScreen when the book tile is tapped
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                HomeDetailsScreen(bookDataModel: bookDataModel),
          ),
        );
      },
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Container(
          margin: const EdgeInsets.all(10),
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            gradient: LinearGradient(
              colors: [
                Colors.blue.shade50,
                Colors.white,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Book Image
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  bookDataModel.thumbnail,
                  height: 150, 
                  width: 200,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 150,
                    width: double.infinity,
                    color: Colors.grey[300],
                    child: const Icon(Icons.broken_image, color: Colors.grey),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              // Book Title
              Text(
                bookDataModel.title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              // Publisher
              Text(
                "Publisher: ${bookDataModel.publisher}",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.blueGrey[700],
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              // Book Description
              Text(
                bookDataModel.description,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              // Price
              Text(
                bookDataModel.price != null
                    ? "Price: \$${bookDataModel.price}"
                    : "Price: Not available",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.green[700],
                ),
              ),
              const SizedBox(height: 12),
              // Action Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.favorite_border, color: Colors.red),
                    onPressed: () {
                      homeBloc.add(HomeBooksFavouriteButtonClickedEvent(
                          clickedBook: bookDataModel));

                      
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text("Book has been added to favorites!")),
                      );
                    },
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      
                    },
                    icon: const Icon(Icons.shopping_cart),
                    label: const Text("Buy Now"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
