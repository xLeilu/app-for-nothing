import 'package:appfornothing/database/bookshelf_helper.dart';
import 'package:appfornothing/models/book_model.dart';
import 'package:appfornothing/pages/add_book_page.dart';
import 'package:appfornothing/pages/view_book_page.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class YourBooksPage extends StatefulWidget {
  const YourBooksPage({super.key});

  @override
  State<YourBooksPage> createState() => _YourBooksPageState();
}

class _YourBooksPageState extends State<YourBooksPage> {
  late Future<List<BookModel>> booksList;

  refreshPage() {
    setState(() {
      booksList = BookshelfHelper.instance.getBooks();
    });
  }

  void deleteBook(int? bookID) {
    int id = bookID?.toInt() ?? 0;
    BookshelfHelper.instance.removeBook(id);
    refreshPage();
  }

  void deleteFirebase(String title) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref('books/$title');

    await ref.remove();
  }

  Widget createList(BuildContext context) {
    return FutureBuilder(
        future: booksList,
        builder: ((context, snapshot) {
          if (snapshot.hasData) {
            List<BookModel> localBookList = snapshot.data!;
            if (localBookList.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [Text("Brak danych")],
                ),
              );
            } else {
              return Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 8.0, left: 3.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.height / 4,
                          child: const Text(
                            "Tytuł",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.height / 8,
                          child: const Text(
                            "Autor",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Text("   "),
                      ],
                    ),
                  ),
                  const Divider(
                    color: Colors.grey,
                  ),
                  Expanded(
                    child: ListView.separated(
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemCount: localBookList.length,
                      itemBuilder: ((context, index) {
                        return InkWell(
                          onTap: () {
                            int bookID = localBookList[index].id?.toInt() ?? 0;

                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ViewBookPage(
                                          bookID: bookID,
                                          bookTitle: localBookList[index].title,
                                          bookAuthor:
                                              localBookList[index].author,
                                          bookCategory:
                                              localBookList[index].category,
                                          bookDescription:
                                              localBookList[index].description,
                                          bookPhoto:
                                              localBookList[index].imageBytes,
                                          refreshBooksPage: refreshPage,
                                        )));
                          },
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 5.0),
                            child: SizedBox(
                              height: MediaQuery.of(context).size.height / 16,
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      width:
                                          MediaQuery.of(context).size.height /
                                              4,
                                      child: Text(
                                        localBookList[index].title,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                    ),
                                    SizedBox(
                                      width:
                                          MediaQuery.of(context).size.height /
                                              8,
                                      child: Text(
                                        localBookList[index].author,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        //dodac potwierdzenie czy na pewno usunąć jako popup czy coś
                                        deleteBook(localBookList[index].id);
                                        deleteFirebase(
                                            localBookList[index].title);
                                      },
                                      child: Container(
                                        width: 25,
                                        height: 25,
                                        decoration: BoxDecoration(
                                          color: Colors.red,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: const Center(
                                          child: Text(
                                            'X',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ]),
                            ),
                          ),
                        );
                      }),
                      separatorBuilder: (BuildContext context, int index) =>
                          const Divider(
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ],
              );
            }
          } else if (snapshot.hasError) {
            debugPrint("erolo");
            return Text(snapshot.error.toString());
          }
          debugPrint("nonlo");
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [Center(child: CircularProgressIndicator())],
          );
        }));
  }

  @override
  void initState() {
    super.initState();

    booksList = BookshelfHelper.instance.getBooks();
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
          title: const Text(
            "Twoje książki",
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: SafeArea(
          child: createList(context),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AddBookPage(
                          refreshBooksPage: refreshPage,
                        )));
          },
          foregroundColor: Colors.white,
          backgroundColor: Theme.of(context).colorScheme.primary,
          shape: const CircleBorder(),
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
