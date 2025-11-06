import 'dart:ui';
import 'package:flutter/material.dart';
import 'home_page.dart';
import 'discover_page.dart';

class MainNavigationPage extends StatefulWidget {
  const MainNavigationPage({super.key});

  @override
  State<MainNavigationPage> createState() => _MainNavigationPageState();
}

class _MainNavigationPageState extends State<MainNavigationPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HomePage(title: 'Echoes'),
    const DiscoverPage(),
    const Placeholder(), // Notifications page - TODO: implement
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      // Center(child: ConstrainedBox(constraints: BoxConstraints(maxWidth: 1000),child: const Home(),))
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Center(
        heightFactor: 0.75,
        child: SizedBox(
          width: 280,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(50),
                  border: Border(
                    top: BorderSide(
                      color: Colors.white.withValues(alpha: 0.2),
                      width: 0.5,
                    ),
                  ),
                ),
                child: Builder(
                  builder: (context) => MediaQuery(
                    data: MediaQuery.of(context).removePadding(removeBottom: true),
                    child: BottomNavigationBar(
                      iconSize: 22,
                      landscapeLayout: BottomNavigationBarLandscapeLayout.centered,
                      currentIndex: _currentIndex,
                      onTap: (index) {
                        setState(() {
                          _currentIndex = index;
                        });
                      },
                      type: BottomNavigationBarType.fixed,
                      backgroundColor: Colors.white60,
                      elevation: 0,
                      selectedItemColor: Colors.black87,
                      unselectedItemColor: Colors.black54,
                      selectedLabelStyle: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 10,
                        fontWeight: FontWeight.w400,
                      ),
                      unselectedLabelStyle: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 10,
                        fontWeight: FontWeight.w400,
                      ),
                      items: const [
                        BottomNavigationBarItem(
                          icon: Icon(Icons.home_outlined),
                          label: 'Home',
                        ),
                        BottomNavigationBarItem(
                          icon: Icon(Icons.compass_calibration_outlined),
                          label: 'Discover',
                        ),
                        BottomNavigationBarItem(
                          icon: Icon(Icons.notifications_outlined),
                          label: 'Notifications',
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}