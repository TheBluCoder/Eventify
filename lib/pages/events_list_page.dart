import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../shared/models/event_model.dart';
import '../app/app_constants.dart';
import '../shared/widgets/event_card.dart';
import '../shared/widgets/empty_state_widget.dart';

class EventsListPage extends StatelessWidget {
  final String title;
  final List<EventModel> events;

  const EventsListPage({
    super.key,
    required this.title,
    required this.events,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        flexibleSpace: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: AppConstants.blurSigmaM,
            sigmaY: AppConstants.blurSigmaM,
          ),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.black.withValues(alpha: AppConstants.opacityVeryHeavy),
                  Colors.transparent,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ),
      ),
        title: Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: events.isEmpty
          ? const EmptyStateWidget(message: 'No events yet')
          : RefreshIndicator(
              onRefresh: () async {
                await Future.delayed(AppConstants.refreshDelay);
              },
              child: ListView(
                padding: EdgeInsets.only(
                  top: kToolbarHeight + AppConstants.spacingXXL,
                ),
                children: [
                  ...events.map(
                    (event) => EventCard(
                      event: event,
                      onRegistrationTap: () => _launchRegistrationUrl(
                        event.registrationUrl ?? '',
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }


  Future<void> _launchRegistrationUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}


