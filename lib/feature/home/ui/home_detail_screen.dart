import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:book_finder_application/feature/home/home_bloc.dart';
import 'package:book_finder_application/feature/home/model/book_data.dart';

import '../home_state.dart';

class HomeDetailsScreen extends StatelessWidget {
  final BookDataModel bookDataModel;

  const HomeDetailsScreen({super.key, required this.bookDataModel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(bookDataModel.title),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Book Image
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  bookDataModel.thumbnail,
                  height: 250, 
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 250,
                    width: double.infinity,
                    color: Colors.grey[300],
                    child: const Icon(Icons.broken_image, color: Colors.grey),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Book Title
              Text(
                bookDataModel.title,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),

              // Author(s)
              if (bookDataModel.authors != null &&
                  bookDataModel.authors!.isNotEmpty)
                Text(
                  "Author(s): ${bookDataModel.authors!.join(', ')}",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.blueGrey[700],
                  ),
                )
              else
                Text(
                  "Author(s): Unknown",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.blueGrey[700],
                  ),
                ),
              const SizedBox(height: 8),

              // Publisher
              Text(
                "Publisher: ${bookDataModel.publisher}",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.blueGrey[700],
                ),
              ),
              const SizedBox(height: 8),

              // Price
              Text(
                bookDataModel.price != null
                    ? "Price: \$${bookDataModel.price}"
                    : "Price: Not available",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.green[700],
                ),
              ),
              const SizedBox(height: 16),

              // Description
              if (bookDataModel.description.isNotEmpty)
                Text(
                  "Description: ${bookDataModel.description}",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                  textAlign: TextAlign.justify,
                )
              else
                Text(
                  "Description: Not available.",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                  textAlign: TextAlign.justify,
                ),
              const SizedBox(height: 20),

              
              ElevatedButton.icon(
                onPressed: () {
                  
                },
                icon: const Icon(Icons.shopping_cart),
                label: const Text("Add to Cart"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
              ),
              const SizedBox(height: 16),

              
              BlocBuilder<HomeBloc, HomeState>(
                builder: (context, state) {
                  return IconButton(
                    icon: const Icon(Icons.favorite_border, color: Colors.red),
                    onPressed: () {
                      
                      context
                          .read<HomeBloc>()
                          .add(HomeBooksFavouriteButtonClickedEvent(
                            clickedBook: bookDataModel,
                          ));
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
