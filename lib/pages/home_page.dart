import 'dart:ui';
import 'package:flutter/material.dart';
import '../shared/data/placeholder.dart';
import 'home_view.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return const _HomePageContent();
  }
}

class _HomePageContent extends StatelessWidget {
  const _HomePageContent();

  String _getPersonalizedGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: _buildAppBar(context),
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 1100),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color:Colors.white,
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: const Home(),
          ),
        ),
      ), // Only show feed view - no switching
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 50.0),
        child: _buildFloatingActionButton(context),
      ),
    );
  }

  Widget _buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        // TODO: Navigate to create event page
        debugPrint('Create event button pressed');
      },
      backgroundColor: Colors.white70,
      foregroundColor: Colors.grey[800],
      elevation: 10,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: const Icon(Icons.add_outlined, size: 28),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      // shape: Border(
      //   bottom: BorderSide(
      //     color: Colors.grey[700]!,
      //     width: 1,
      //   ),
      // ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _getPersonalizedGreeting(),
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
              fontWeight: FontWeight.w600,
              fontFamily: "Roboto",
            ),
          ),
          Row(
            children: [
              Icon(
                Icons.location_on_outlined,
                size: 16,
                color: const Color.fromARGB(255, 97, 97, 97),
              ),
              SizedBox(width: 4),
              Text(
                PlaceholderData.currentUserLocation,
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  color: const Color.fromARGB(255, 97, 97, 97),
                ),
              ),
            ],
          ),
        ],
      ),
      backgroundColor: Colors.transparent,
      surfaceTintColor: null,
      elevation: 4,
      flexibleSpace: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 3.5, sigmaY: 3.5),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.black.withValues(alpha: 0.4),
                  Colors.transparent,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ),
      ),
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black,
                blurRadius: 4,
                offset: const Offset(2, 2),
              ),
            ],
          ),
          child: CircleAvatar(
            foregroundImage: NetworkImage(
              "https://cdn.dribbble.com/userupload/16394495/file/original-44f9e9320643c7c6d3f4203f161a987e.webp?resize=1024x1024&vertical=center",
            ),
          ),
        ),
      ),
    );
  }
}
