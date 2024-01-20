import 'dart:typed_data';

import 'package:appfornothing/database/bookshelf_helper.dart';
import 'package:appfornothing/models/book_model.dart';
import 'package:appfornothing/services/services.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class AddBookPage extends StatefulWidget {
  final Function() refreshBooksPage;
  const AddBookPage({
    super.key,
    required this.refreshBooksPage,
  });

  @override
  State<AddBookPage> createState() => _AddBookPageState();
}

class _AddBookPageState extends State<AddBookPage> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController authorController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();

  void _doSomething() async {
    String title = titleController.text;
    String author = authorController.text;
    String category = categoryController.text;
    String description = descriptionController.text;
    Uint8List photoBytes = await Services()
        .getImageBytesFromAssets('assets/images/place_holder.png');

    BookModel sampleBook = BookModel(
      title: title,
      author: author,
      category: category,
      description: description,
      imageBytes: photoBytes,
    );

    BookshelfHelper.instance.add(BookModel(
      title: title,
      author: author,
      category: category,
      description: description,
      imageBytes: photoBytes,
    ));

    DatabaseReference ref = FirebaseDatabase.instance.ref('books/$title');

    Map<String, dynamic> book = sampleBook.toMap();

    await ref.set(book);

    setState(() {});
    widget.refreshBooksPage();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, true);
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            color: Colors.black,
            onPressed: () {
              Navigator.pop(context, true);
            },
          ),
        ),
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextField(
                    controller: titleController,
                    decoration: const InputDecoration(
                      labelText: 'Tytuł',
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: authorController,
                    decoration: const InputDecoration(
                      labelText: 'Autor',
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: categoryController,
                    decoration: const InputDecoration(
                      labelText: 'Kategoria',
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: descriptionController,
                    decoration: const InputDecoration(
                      labelText: 'Opis',
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _doSomething,
                    child: const Text('Dodaj'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
