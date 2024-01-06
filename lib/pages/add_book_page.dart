import 'package:appfornothing/database/bookshelf_helper.dart';
import 'package:appfornothing/models/book_model.dart';
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

  void _doSomething() {
    String title = titleController.text;
    String author = authorController.text;
    String description = descriptionController.text;

    print('Title: $title');
    print('Author: $author');
    print('Description: $description');

    BookshelfHelper.instance
        .add(BookModel(title: title, author: author, description: description));

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
                    decoration: InputDecoration(
                      labelText: 'Title',
                    ),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: authorController,
                    decoration: InputDecoration(
                      labelText: 'Author',
                    ),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: descriptionController,
                    decoration: InputDecoration(
                      labelText: 'Description',
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _doSomething,
                    child: Text('Dodaj'),
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
