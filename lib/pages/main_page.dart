import 'package:appfornothing/pages/scanner_page.dart';
import 'package:appfornothing/pages/your_books_page.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int currentPageIndex = 0;

  void changePage(int index) {
    if (index == 1) {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const YourBooksPage()));
    } else if (index == 2) {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const ScannerPage()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          title: const Text(
            "Library App",
            style: TextStyle(color: Colors.white),
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white60,
          currentIndex: currentPageIndex,
          onTap: changePage,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: "Strona główna",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.menu_book),
              label: "Twoje książki",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.document_scanner_outlined),
              label: "Skaner",
            ),
          ],
        ),
        body: const SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Strona główna aplikacji',
                ),
                Text("Autor: Maciej Pliszka")
              ],
            ),
          ),
        ),
      ),
    );
  }
}
