import 'package:appfornothing/database/bookshelf_helper.dart';
import 'package:appfornothing/models/book_model.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';

class ViewBookPage extends StatefulWidget {
  final int bookID;
  final String bookTitle;
  final String bookAuthor;
  final String bookCategory;
  final String bookDescription;
  final Uint8List bookPhoto;
  final Function() refreshBooksPage;

  const ViewBookPage({
    super.key,
    required this.bookID,
    required this.bookTitle,
    required this.bookAuthor,
    required this.bookCategory,
    required this.bookDescription,
    required this.bookPhoto,
    required this.refreshBooksPage,
  });

  @override
  State<ViewBookPage> createState() => _ViewBookPageState();
}

class _ViewBookPageState extends State<ViewBookPage> {
  late Uint8List bookImage;

  final imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();
    bookImage = widget.bookPhoto;
  }

  Future<void> updateDBPhoto(int bookId, String photoPath) async {
    await BookshelfHelper.instance.updatePhoto(bookId, photoPath);

    BookModel updatedBook =
        await BookshelfHelper.instance.getSingleBook(bookId);

    setState(() {
      bookImage = updatedBook.imageBytes;
    });
  }

  Future<void> getImage() async {
    final image = await imagePicker.pickImage(
        source: ImageSource.camera, imageQuality: 25);

    if (image != null && image.path.isNotEmpty) {
      await updateDBPhoto(widget.bookID, image.path);
      widget.refreshBooksPage();
    } else {
      debugPrint('No image selected');
    }
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
            color: Colors.white,
            onPressed: () {
              Navigator.pop(context, true);
            },
          ),
          title: Text(
            widget.bookTitle,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: const TextStyle(color: Colors.white),
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: InkWell(
                        onTap: getImage,
                        child: widget.bookPhoto != null
                            ? Image.memory(
                                bookImage,
                                fit: BoxFit.cover,
                                height: MediaQuery.of(context).size.height / 3,
                                width: MediaQuery.of(context).size.width / 2.5,
                              )
                            : const CircularProgressIndicator(),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 3,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                              width: MediaQuery.of(context).size.width / 2,
                              child: const Text(
                                "Tytuł",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              )),
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 2,
                            child: Text(
                              widget.bookTitle.toString(),
                              overflow: TextOverflow.visible,
                              maxLines: 5,
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 2.2,
                            child: const Divider(
                              color: Colors.grey,
                            ),
                          ),
                          SizedBox(
                              width: MediaQuery.of(context).size.width / 2,
                              child: const Text(
                                "Autor",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              )),
                          SizedBox(
                              width: MediaQuery.of(context).size.width / 2,
                              child: Text(
                                widget.bookAuthor.toString(),
                                overflow: TextOverflow.visible,
                                maxLines: 2,
                              )),
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 2.2,
                            child: const Divider(
                              color: Colors.grey,
                            ),
                          ),
                          SizedBox(
                              width: MediaQuery.of(context).size.width / 2,
                              child: const Text(
                                "Gatunek",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              )),
                          SizedBox(
                              width: MediaQuery.of(context).size.width / 2,
                              child: Text(
                                widget.bookCategory.toString(),
                                overflow: TextOverflow.visible,
                                maxLines: 2,
                              )),
                        ],
                      ),
                    ),
                  ],
                ),
                Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Column(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 1,
                          child: const Text(
                            "Opis książki",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 1,
                          child: const Divider(
                            color: Colors.grey,
                          ),
                        ),
                        SizedBox(
                            width: MediaQuery.of(context).size.width / 1,
                            child: Text(widget.bookDescription.toString())),
                      ],
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
