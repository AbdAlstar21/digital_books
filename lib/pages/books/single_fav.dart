import 'dart:async';
import 'dart:convert';

import 'package:digital_books/pages/books/books_favorite.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_network/image_network.dart';
import 'package:provider/provider.dart';

import 'package:digital_books/pages/book_details/book_details.dart';
import 'package:digital_books/pages/provider/loading.dart';

import '../components/progres.dart';
import '../config.dart';
import '../function.dart';
import 'books_data.dart';
import 'edit.dart';

class SingleFavorite extends StatelessWidget {
  int book_index;
  BooksData books;
  SingleFavorite({Key? key, required this.book_index, required this.books})
      : super(key: key);

  
  @override
  Widget build(BuildContext context) {
    var providerFav = Provider.of<LoadingControl>(context);

    return MaterialButton(
      onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => BookDetails(
                      books: books,
                      book_index: book_index,
                    )));
      },
      child: Card(
        child: Column(
          children: <Widget>[
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(4.0),
                  margin: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0),
                    color: Colors.blue[300],
                  ),
                  child:
                      books.book_thumbnail == "" || books.book_thumbnail == null
                          ? ImageNetwork(
                              image: imageBook + "def.png",
                              width: 110,
                              height: 140,
                              onLoading: const CircularProgressIndicator(
                                color: Colors.indigoAccent,
                              ),
                              onError: const Icon(
                                Icons.error,
                                color: Colors.red,
                              ),
                            )
                          : ImageNetwork(
                              image: imageBook + books.book_thumbnail,
                              width: 110,
                              height: 140,
                              onLoading: CircularProgressIndicator(
                                color: Colors.indigoAccent,
                              ),
                              onError: const Icon(
                                Icons.error,
                                color: Colors.red,
                              ),
                            ),
                ),
                Expanded(
                  child: ListTile(
                    title: Text(
                      books.book_name,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            books.book_author_name,
                            style: const TextStyle(fontSize: 18),
                          ),
                          Row(
                            children: [
                              const Icon(
                                Icons.star,
                                color: Colors.amber,
                              ),
                              Text(books.book_eva.toString()),
                              Padding(padding: EdgeInsets.only(right: 10)),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.download,
                                    color: Colors.green,
                                  ),
                                  Text(books.book_download.toString()),
                                ],
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              const Icon(
                                Icons.date_range,
                                color: Colors.blueAccent,
                              ),
                              Text(books.book_date),
                            ],
                          )
                        ]),
                    trailing: Column(
                      children: <Widget>[
                        Consumer<LoadingControl>(
                            builder: (context, load, child) {
                          return GestureDetector(
                            onTap: () {
                              bookListFav!.removeAt(book_index);
                              deleteData("fav_id", books.fav_id,
                                  "favorite/delete_fav.php");
                              providerFav.add_loading();
                              // saveFavorite(books.fav_id, books.book_id,book_index, context, load);
                            },
                            child: books.fav_id == null || books.fav_id == ""
                                ? Icon(
                                    Icons.favorite_border,
                                    size: 34,
                                  )
                                : Icon(
                                    Icons.favorite,
                                    color: Colors.purple,
                                    size: 34,
                                  ),
                          );
                        }),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
