import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:typed_data';

class ViewBookPage extends StatefulWidget {
  final int bookID;
  final String bookTitle;
  final String bookAuthor;
  final String bookCategory;
  final String bookDescription;
  final Uint8List bookPhoto;

  const ViewBookPage({
    super.key,
    required this.bookID,
    required this.bookTitle,
    required this.bookAuthor,
    required this.bookCategory,
    required this.bookDescription,
    required this.bookPhoto,
  });

  @override
  State<ViewBookPage> createState() => _ViewBookPageState();
}

class _ViewBookPageState extends State<ViewBookPage> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  void doPhoto() {
    //tutaj fajnie otwiera aparat i można zrobić zdjęcie które następnie się dodaje do bazy i elo kurwa
  }

  Future<void> _takePicture() async {
    try {
      await _initializeControllerFuture;
      final path = join(
        (await getTemporaryDirectory()).path,
        '${DateTime.now()}.png',
      );
      await _controller.takePicture();
      // Once the photo is taken, you can store the path or the image in SQFlite.
      // You can use the `path` variable to save the image path in the database.
      // Or use the `File` object to read the image and save the binary data in the database.
    } catch (e) {
      print("Error taking picture: $e");
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
                        onTap: () => _takePicture,
                        /*
                        child: Image.asset(
                          'assets/images/place_holder.png',
                          fit: BoxFit.contain,
                          height: MediaQuery.of(context).size.height / 3,
                        ),
                        */
                        child: widget.bookPhoto != null
                            ? Image.memory(
                                widget.bookPhoto,
                                fit: BoxFit.cover,
                              )
                            : CircularProgressIndicator(),
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
