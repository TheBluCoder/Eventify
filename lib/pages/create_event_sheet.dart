import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class CreateEventSheet extends StatefulWidget {
  const CreateEventSheet({super.key});

  @override
  State<CreateEventSheet> createState() => _CreateEventSheetState();
}

class _CreateEventSheetState extends State<CreateEventSheet> {
  final TextEditingController _eventNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _rsvpUrlController = TextEditingController();
  final TextEditingController _capacityController = TextEditingController();

  DateTime? _startTime;
  DateTime? _endTime;
  File? _selectedMedia;
  bool _isVideo = false;
  bool _isRSVPEnabled = false;
  String _price = 'Free';

  final ImagePicker _imagePicker = ImagePicker();

  // Random gradient colors
  late final List<Color> _gradientColors;

  @override
  void initState() {
    super.initState();
    _gradientColors = _generateRandomGradient();
    _startTime = DateTime.now().add(const Duration(hours: 1));
    _endTime = _startTime?.add(const Duration(hours: 1));
  }

  List<Color> _generateRandomGradient() {
    final random = Random();
    final color1 = Color.fromARGB(
      255,
      random.nextInt(100) + 50, // 50-150
      random.nextInt(100) + 100, // 100-200
      random.nextInt(100) + 100, // 100-200
    );
    final color2 = Color.fromARGB(
      255,
      random.nextInt(100) + 100, // 100-200
      random.nextInt(100) + 50, // 50-150
      random.nextInt(100) + 150, // 150-250
    );
    return [color1, color2];
  }

  Future<void> _pickMedia() async {
    try {
      final XFile? pickedFile = await _imagePicker.pickMedia(imageQuality: 85);

      if (pickedFile != null) {
        setState(() {
          _selectedMedia = File(pickedFile.path);
          _isVideo = pickedFile.mimeType?.startsWith('video/') ?? false;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error picking media: $e')));
      }
    }
  }

  Future<void> _selectStartTime() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _startTime ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (!mounted) return;

    if (picked != null) {
      final TimeOfDay? time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_startTime ?? DateTime.now()),
      );

      if (!mounted) return;

      if (time != null) {
        setState(() {
          _startTime = DateTime(
            picked.year,
            picked.month,
            picked.day,
            time.hour,
            time.minute,
          );
          if (_endTime != null && _endTime!.isBefore(_startTime!)) {
            _endTime = _startTime!.add(const Duration(hours: 1));
          }
        });
      }
    }
  }

  Future<void> _selectEndTime() async {
    if (_startTime == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select start time first')),
      );
      return;
    }

    final TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(
        _endTime ?? _startTime!.add(const Duration(hours: 1)),
      ),
    );

    if (!mounted) return;

    if (time != null) {
      final endDateTime = DateTime(
        _startTime!.year,
        _startTime!.month,
        _startTime!.day,
        time.hour,
        time.minute,
      );

      if (endDateTime.isBefore(_startTime!)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('End time must be after start time')),
        );
        return;
      }

      setState(() {
        _endTime = endDateTime;
      });
    }
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

  void _handleCreateEvent() {
    // TODO: Implement event creation logic
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Event created successfully!')),
    );
  }

  @override
  void dispose() {
    _eventNameController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _rsvpUrlController.dispose();
    _capacityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.9,
      maxChildSize: 0.98,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: _gradientColors,
            ),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              // Drag handle
              Container(
                margin: const EdgeInsets.only(top: 12, bottom: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              // Header
              _buildHeader(),

              // Scrollable content
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),

                      // Event Media Section
                      _buildEventMediaSection(),

                      const SizedBox(height: 24),

                      // Event Name
                      _buildEventNameField(),

                      const SizedBox(height: 20),

                      // Start/End Time
                      _buildTimeSection(),

                      const SizedBox(height: 20),

                      // Location
                      _buildLocationField(),

                      const SizedBox(height: 20),

                      // Description
                      _buildDescriptionField(),

                      const SizedBox(height: 32),

                      // Ticketing Section
                      _buildTicketingSection(),

                      const SizedBox(height: 32),

                      // Options Section
                      _buildOptionsSection(),

                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
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
              foregroundImage: NetworkImage(
                "https://cdn.dribbble.com/userupload/16394495/file/original-44f9e9320643c7c6d3f4203f161a987e.webp?resize=1024x1024&vertical=center",
              ),
            ),
          ),
          const SizedBox(width: 8),
          const Icon(
            Icons.keyboard_arrow_down,
            color: Colors.white70,
            size: 16,
          ),

          const Spacer(),

          // Title
          Text(
            'Create Event',
            style: TextTheme.of(context).titleMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),

          const Spacer(),

          // Confirm Button
          GestureDetector(
            onTap: _handleCreateEvent,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.2),
              ),
              padding: const EdgeInsets.all(8),
              child: const Icon(Icons.check, color: Colors.white, size: 20),
            ),
          ),
        ],
      ),
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
          if (_selectedMedia != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: _isVideo
                  ? const Center(
                      child: Icon(
                        Icons.play_circle_outline,
                        color: Colors.white,
                        size: 64,
                      ),
                    )
                  : Image.file(_selectedMedia!, fit: BoxFit.cover),
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

          // Add Media Button
          Positioned(
            bottom: 12,
            right: 12,
            child: GestureDetector(
              onTap: _pickMedia,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.9),
                  border: Border.all(color: Colors.white, width: 2),
                ),
                padding: const EdgeInsets.all(10),
                child: const Icon(
                  Icons.add_photo_alternate,
                  color: Colors.black87,
                  size: 24,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEventNameField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(16),
      ),
      child: TextField(
        controller: _eventNameController,
        style: const TextStyle(color: Colors.white, fontSize: 18),
        maxLength: 25,
        decoration: InputDecoration(
          hintText: 'Event Name',
          hintStyle: TextTheme.of(context).bodyMedium?.copyWith(
            color: Colors.white.withValues(alpha: 0.6),
            fontWeight: FontWeight.w500,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
          counterText: '',
          counterStyle: TextStyle(
            color: Colors.white.withValues(alpha: 0.5),
            fontSize: 12,
          ),
        ),
        onChanged: (value) {
          setState(() {}); // Update counter
        },
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
              GestureDetector(
                onTap: _selectStartTime,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Start',
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _startTime != null
                            ? _formatDateTime(_startTime!)
                            : 'Select start time',
                        style: TextStyle(
                          color: _startTime != null
                              ? Colors.white
                              : Colors.white60,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // SizedBox with same height as dotted line
              const SizedBox(height: dottedLineHeight),
              // End time row
              GestureDetector(
                onTap: _selectEndTime,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'End',
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _endTime != null
                            ? _formatTime(_endTime!)
                            : 'Select end time',
                        style: TextStyle(
                          color: _endTime != null
                              ? Colors.white
                              : Colors.white60,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLocationField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(16),
      ),
      child: TextField(
        controller: _locationController,
        style: const TextStyle(color: Colors.white, fontSize: 16),
        decoration: InputDecoration(
          hintText: 'Choose Location',
          hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.6)),
          prefixIcon: const Icon(
            Icons.location_on_outlined,
            color: Colors.white70,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
        ),
        readOnly: true,
        onTap: () {
          // TODO: Implement location picker
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location picker coming soon')),
          );
        },
      ),
    );
  }

  Widget _buildDescriptionField() {
    var maxLength = 1000;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(16),
      ),
      child: TextField(
        maxLength: maxLength,
        controller: _descriptionController,
        style: const TextStyle(color: Colors.white, fontSize: 16),
        decoration: InputDecoration(
          hintText: 'Add Description',
          hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.6)),

          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
          // counterText: '$wordCount/$maxLength chars',
          counterStyle: TextStyle(
            color: _descriptionController.text.length > maxLength
                ? Colors.red.withValues(alpha: 0.8)
                : Colors.white.withValues(alpha: 0.5),
            fontSize: 12,
          ),
        ),
        maxLines: 3,
      ),
    );
  }

  Widget _buildTicketingSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Ticketing',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),

        // RSVP Toggle
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Row(
            children: [
              const Icon(Icons.lock_outline, color: Colors.white70, size: 20),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'RSVP',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
              Switch(
                value: _isRSVPEnabled,
                onChanged: (value) {
                  setState(() {
                    _isRSVPEnabled = value;
                  });
                },
                activeThumbColor: Colors.white,
                activeTrackColor: Colors.white.withValues(alpha: 0.5),
                inactiveThumbColor: Colors.white,
                inactiveTrackColor: Colors.white.withValues(alpha: 0.3),
              ),
            ],
          ),
        ),

        // RSVP URL Field (shown when RSVP is enabled)
        if (_isRSVPEnabled) ...[
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(16),
            ),
            child: TextField(
              maxLength: 200,
              controller: _rsvpUrlController,
              style: const TextStyle(color: Colors.white, fontSize: 16),
              decoration: InputDecoration(
                counterText: '',
                hintText: 'RSVP URL (e.g., Eventbrite, RSVPify)',
                hintStyle: TextStyle(
                  color: Colors.white.withValues(alpha: 0.6),
                ),
                prefixIcon: const Icon(Icons.link, color: Colors.white70),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
              ),
              keyboardType: TextInputType.url,
              onChanged: (value) => setState(() {
                if (value.length > 200) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('RSVP URL cannot exceed 200 characters'),
                    ),
                  );
                }
              }),
            ),
          ),
        ],

        const SizedBox(height: 12),

        // Price Dropdown
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Row(
            children: [
              const Icon(Icons.attach_money, color: Colors.white70, size: 20),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Price',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
              DropdownButton<String>(
                borderRadius: BorderRadius.circular(12),
                value: _price,
                underline: Container(),
                dropdownColor: Colors.black45,
                style: const TextStyle(color: Colors.white70, fontSize: 16),
                items: const [
                  DropdownMenuItem(value: 'Free', child: Text('Free')),
                  DropdownMenuItem(value: 'Paid', child: Text('Paid')),
                ],
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      _price = newValue;
                    });
                  }
                },
                icon: const Icon(
                  Icons.keyboard_arrow_down,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOptionsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Options',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),

        // Capacity TextField
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(16),
          ),
          child: TextField(
            controller: _capacityController,
            style: const TextStyle(color: Colors.white, fontSize: 16),
            decoration: InputDecoration(
              hintText: 'Enter capacity ',
              hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.6)),
              prefixIcon: const Icon(
                Icons.people_outline,
                color: Colors.white70,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
            ),
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          ),
        ),
      ],
    );
  }
}

// Custom painter for dotted line
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
