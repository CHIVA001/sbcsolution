import 'package:flutter/material.dart';

class CustomBottomNav extends StatefulWidget {
  const CustomBottomNav({Key? key}) : super(key: key);

  @override
  State<CustomBottomNav> createState() => _CustomBottomNavState();
}

class _CustomBottomNavState extends State<CustomBottomNav> {
  int _currentIndex = 0;

  final List<IconData> _icons = [
    Icons.map,       // Left icon
    Icons.military_tech, // 2nd
    Icons.search,    // 3rd
    Icons.person,    // Right icon
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Center(
        child: Text("Selected Index: $_currentIndex"),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.pink,
        shape: const CircleBorder(),
        onPressed: () {
          // Middle button action
          print("Scan button pressed");
        },
        child: const Icon(Icons.qr_code_scanner, size: 28, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        elevation: 5,
        child: Container(
          height: 65,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: List.generate(2, (index) {
                  return IconButton(
                    icon: Icon(
                      _icons[index],
                      color: _currentIndex == index ? Colors.pink : Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        _currentIndex = index;
                      });
                    },
                  );
                }),
              ),
              const SizedBox(width: 40), // space for FAB
              Row(
                children: List.generate(2, (index) {
                  int realIndex = index + 2;
                  return IconButton(
                    icon: Icon(
                      _icons[realIndex],
                      color: _currentIndex == realIndex ? Colors.pink : Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        _currentIndex = realIndex;
                      });
                    },
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

