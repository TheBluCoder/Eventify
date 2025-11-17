import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../shared/models/event_model.dart';
import '../shared/widgets/event_options_menu.dart';

class ViewEventPage extends StatefulWidget {
  final EventModel event;

  const ViewEventPage({
    super.key,
    required this.event,
  });

  @override
  State<ViewEventPage> createState() => _ViewEventPageState();
}

class _ViewEventPageState extends State<ViewEventPage> {
  late bool _isLiked;
  late bool _isBoosted;
  late bool _isAddedToCalendar;

  @override
  void initState() {
    super.initState();
    _isLiked = widget.event.isLiked;
    _isBoosted = widget.event.isBoosted;
    _isAddedToCalendar = false;
  }

  String _formatDateTime(DateTime dateTime) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

    final hour = dateTime.hour;
    final minute = dateTime.minute;
    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    final timeStr = '$displayHour:${minute.toString().padLeft(2, '0')} $period';

    return '${days[dateTime.weekday - 1]}, ${months[dateTime.month - 1]} ${dateTime.day} at $timeStr';
  }

  String _formatTime(DateTime dateTime) {
    final hour = dateTime.hour;
    final minute = dateTime.minute;
    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    return '$displayHour:${minute.toString().padLeft(2, '0')} $period';
  }

  String _formatDateOnly(DateTime dateTime) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[dateTime.month - 1]} ${dateTime.day}, ${dateTime.year}';
  }

  String _formatRecurringDays(List<int> days) {
    const dayNames = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days.map((day) => dayNames[day - 1]).join(', ');
  }

  Future<void> _launchRegistrationUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      // Handle error if URL cannot be launched
      debugPrint('Could not launch URL: $url');
    }
  }

  Future<void> _launchMapLocation() async {
    // Create a URL for maps with the event location
    // This works for both iOS (Apple Maps) and Android (Google Maps)
    final url = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=${widget.event.latitude},${widget.event.longitude}',
    );
    
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      // Fallback to alternative map URL format
      final altUrl = Uri.parse(
        'geo:${widget.event.latitude},${widget.event.longitude}?q=${widget.event.latitude},${widget.event.longitude}(${Uri.encodeComponent(widget.event.location)})',
      );
      if (await canLaunchUrl(altUrl)) {
        await launchUrl(altUrl, mode: LaunchMode.externalApplication);
      } else {
        debugPrint('Could not launch map location');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Generate a consistent gradient based on event ID
    final gradientColors = _generateGradientFromId(widget.event.id);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: gradientColors,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              _buildHeader(context, gradientColors),

              // Scrollable content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),

                      // Event Media Section
                      _buildEventMediaSection(),

                      const SizedBox(height: 24),

                      // Action Buttons Row (Like, Boost, Add to Calendar, More)
                      _buildActionButtonsRow(),

                      const SizedBox(height: 20),
                      // Event Name
                      _buildEventNameField(),

                      const SizedBox(height: 20),


                      // Start/End Time (hidden when recurring)
                      if (!widget.event.isRecurring) ...[
                        _buildTimeSection(),
                        const SizedBox(height: 20),
                      ],

                      // Recurring Event Info (shown when recurring)
                      if (widget.event.isRecurring) ...[
                        _buildRecurringInfoSection(),
                        const SizedBox(height: 20),
                      ],

                      // Location
                      _buildLocationField(),

                      const SizedBox(height: 20),

                      // Event Details Section
                      _buildEventDetailsSection(),

                      const SizedBox(height: 20),

                      // Registration Section
                      _buildRegistrationSection(),

                      const SizedBox(height: 20),

                      // Event Stats Section
                      _buildEventStatsSection(),

                      const SizedBox(height: 20),

                      // Tags Section
                      _buildTagsSection(),

                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Color> _generateGradientFromId(String id) {
    // Generate consistent colors based on event ID
    final hash = id.hashCode;
    final color1 = Color.fromARGB(
      255,
      (hash % 100) + 50,
      ((hash ~/ 100) % 100) + 100,
      ((hash ~/ 10000) % 100) + 100,
    );
    final color2 = Color.fromARGB(
      255,
      ((hash ~/ 1000) % 100) + 100,
      ((hash ~/ 100000) % 100) + 50,
      ((hash ~/ 10000000) % 100) + 150,
    );
    return [color1, color2];
  }

  void _handleLike() {
    setState(() {
      _isLiked = !_isLiked;
    });
    // TODO: Implement actual like functionality
  }

  void _handleBoost() {
    setState(() {
      _isBoosted = !_isBoosted;
    });
    // TODO: Implement actual boost functionality
  }

  void _handleAddToCalendar() {
    setState(() {
      _isAddedToCalendar = !_isAddedToCalendar;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_isAddedToCalendar
            ? '${widget.event.title} added to your calendar'
            : '${widget.event.title} removed from your calendar'),
        duration: const Duration(seconds: 2),
      ),
    );
    // TODO: Implement actual calendar integration
  }

  void _handleFlag() {
    // TODO: Implement flag/report functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Flagged: ${widget.event.title}'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _handleShare() {
    // TODO: Implement share functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Sharing: ${widget.event.title}'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, List<Color> gradientColors) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: Row(
        children: [
          // Profile icon
          Container(
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
              backgroundImage: NetworkImage(widget.event.organizerAvatar),
              onBackgroundImageError: (exception, stackTrace) {},
              child: widget.event.organizerAvatar.isEmpty
                  ? const Icon(Icons.person, color: Colors.white)
                  : null,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.event.organizerUsername,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (widget.event.isBoosted && widget.event.boosterUsername != null)
                  Row(
                    children: [
                      const Icon(
                        Icons.rocket_launch,
                        size: 10,
                        color: Colors.white70,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Boosted by ${widget.event.boosterUsername}',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
          // Close Button
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.2),
              ),
              padding: const EdgeInsets.all(8),
              child: const Icon(Icons.close, color: Colors.white, size: 20),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtonsRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Like button
        TextButton.icon(
          onPressed: _handleLike,
          icon: Icon(
            _isLiked ? Icons.favorite : Icons.favorite_border,
            color: _isLiked ? Colors.red : Colors.white,
            size: 16,
          ),
          label:  Text(
            'Like',
            style: TextTheme.of(context).bodySmall!.copyWith(color: Colors.white)
          ),
          style: TextButton.styleFrom(
            backgroundColor: Colors.white.withValues(alpha: 0.2),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
          ),
        ),
        // Boost button
        TextButton.icon(
          onPressed: _handleBoost,
          icon: Icon(
            Icons.rocket_launch,
            color: _isBoosted ? Colors.orange : Colors.white,
            size: 16,
          ),
          label:  Text(
            'Boost',
            style: TextTheme.of(context).bodySmall!.copyWith(color: Colors.white)
          ),
          style: TextButton.styleFrom(
            backgroundColor: Colors.white.withValues(alpha: 0.2),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
          ),
        ),
        // Add to Calendar button
        TextButton.icon(
          onPressed: _handleAddToCalendar,
          icon: Icon(
            _isAddedToCalendar ? Icons.event_available : Icons.calendar_today,
            color: Colors.white,
            size: 16,
          ),
          label:  Text(
            'Calendar',
            style: TextTheme.of(context).bodySmall!.copyWith(color: Colors.white)
          ),
          style: TextButton.styleFrom(
            backgroundColor: Colors.white.withValues(alpha: 0.2),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
          ),
        ),
        // More options button
        EventOptionsMenu(
          organizerUsername: widget.event.organizerUsername,
          onFlag: _handleFlag,
          onShare: _handleShare,
          onFollow: () {
            // TODO: Implement follow functionality
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Following ${widget.event.organizerUsername}'),
                duration: const Duration(seconds: 2),
              ),
            );
          },
          showAddToCalendar: false, // Already have a dedicated Calendar button
          useCustomButton: true,
          customButton: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.more_horiz,
              color: Colors.white,
              size: 16,
            ),
          ),
          menuColor: Colors.white,
        ),
      ],
    );
  }

  Widget _buildEventMediaSection() {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (widget.event.mediaUrl.isNotEmpty)
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: widget.event.isVideo
                  ? const Center(
                      child: Icon(
                        Icons.play_circle_outline,
                        color: Colors.white,
                        size: 64,
                      ),
                    )
                  : Image.network(
                      widget.event.mediaUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Colors.greenAccent.withValues(alpha: 0.3),
                                Colors.cyanAccent.withValues(alpha: 0.3),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(16),
                          ),
                        );
                      },
                    ),
            )
          else
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.greenAccent.withValues(alpha: 0.3),
                    Colors.cyanAccent.withValues(alpha: 0.3),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildEventNameField() {
    return Text(
      widget.event.title,
      style: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w500,
        fontSize: 18,
      ),
    );
  }

  Widget _buildTimeSection() {
    const double dottedLineHeight = 30.0;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        // Circle column with dotted line
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // Start circle
            Container(
              width: 12,
              height: 12,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
            ),
            // Dotted line
            CustomPaint(
              size: const Size(2, dottedLineHeight),
              painter: DottedLinePainter(),
            ),
            // End circle
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
            ),
          ],
        ),
        const SizedBox(width: 12),
        // Text column (expanded)
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Start time row
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Start',
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      _formatDateTime(widget.event.dateTime),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
              // SizedBox with same height as dotted line
              const SizedBox(height: dottedLineHeight),
              // End time row (if we had end time, but EventModel only has dateTime)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'End',
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      _formatTime(widget.event.dateTime.add(const Duration(hours: 1))),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }


  Widget _buildRecurringInfoSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.repeat, color: Colors.white70, size: 20),
              SizedBox(width: 12),
              Text(
                'Recurring Event',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          if (widget.event.recurringDays != null && widget.event.recurringDays!.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              'Days: ${_formatRecurringDays(widget.event.recurringDays!)}',
              style: const TextStyle(color: Colors.white70, fontSize: 14),
            ),
          ],
          if (widget.event.recurringPeriodStart != null) ...[
            const SizedBox(height: 8),
            Text(
              'Period: ${_formatDateOnly(widget.event.recurringPeriodStart!)}',
              style: const TextStyle(color: Colors.white70, fontSize: 14),
            ),
          ],
          if (widget.event.recurringPeriodEnd != null) ...[
            const SizedBox(height: 4),
            Text(
              ' - ${_formatDateOnly(widget.event.recurringPeriodEnd!)}',
              style: const TextStyle(color: Colors.white70, fontSize: 14),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildLocationField() {
    return GestureDetector(
      onTap: _launchMapLocation,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            const Icon(Icons.location_on_outlined, color: Colors.white70, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                widget.event.location,
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
            const Icon(Icons.open_in_new, color: Colors.white70, size: 18),
          ],
        ),
      ),
    );
  }

  Widget _buildEventDetailsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Event Details',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            widget.event.description,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRegistrationSection() {
    if (!widget.event.isRSVP && (widget.event.registrationUrl == null || widget.event.registrationUrl!.isEmpty)) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Registration',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        // RSVP Status
        if (widget.event.isRSVP)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                const Icon(Icons.lock_outline, color: Colors.white70, size: 20),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'RSVP Required',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        if (widget.event.registrationUrl != null && widget.event.registrationUrl!.isNotEmpty) ...[
          if (widget.event.isRSVP) const SizedBox(height: 12),
          GestureDetector(
            onTap: () => _launchRegistrationUrl(widget.event.registrationUrl!),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  const Icon(Icons.link, color: Colors.white70, size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      widget.event.registrationUrl!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        decoration: TextDecoration.underline,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const Icon(Icons.open_in_new, color: Colors.white70, size: 18),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildEventStatsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Event Stats',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              const Icon(Icons.people_outline, color: Colors.white70, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  '${widget.event.interestedCount} ${widget.event.interestedCount == 1 ? 'person is' : 'people are'} interested',
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTagsSection() {
    if (widget.event.tags.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Tags',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: widget.event.tags.map((tag) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.25),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.5),
                  width: 1,
                ),
              ),
              child: Text(
                tag,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

// Custom painter for dotted line (same as in create_event_sheet.dart)
class DottedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.3)
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    const dashHeight = 8.0;
    const dashSpace = 3.0;
    double startY = 0;

    while (startY < size.height) {
      canvas.drawLine(
        Offset(size.width / 2, startY),
        Offset(size.width / 2, (startY + dashHeight).clamp(0, size.height)),
        paint,
      );
      startY += dashHeight + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

