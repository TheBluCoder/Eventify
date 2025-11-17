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
  DateTime? _expirationDate;
  File? _selectedMedia;
  bool _isVideo = false;
  bool _isRSVPEnabled = false;
  bool _isRecurring = false;
  String _price = 'Free';
  List<int> _selectedRecurringDays = []; // 1=Monday, 7=Sunday
  DateTime? _recurringPeriodStart;
  DateTime? _recurringPeriodEnd;
  List<String> _selectedTags = []; // Maximum 3 tags
  final TextEditingController _tagController = TextEditingController();

  final ImagePicker _imagePicker = ImagePicker();

  // Random gradient colors
  late final List<Color> _gradientColors;

  @override
  void initState() {
    super.initState();
    _gradientColors = _generateRandomGradient();
    _startTime = DateTime.now().add(const Duration(hours: 1));
    _endTime = _startTime?.add(const Duration(hours: 1));
    _expirationDate = _startTime; // Default to start date
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
          // Update expiration date to match start date if it was previously set to old start date
          if (_expirationDate == null || _expirationDate!.isBefore(_startTime!)) {
            _expirationDate = _startTime;
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

  Future<void> _selectExpirationDate() async {
    if (_startTime == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select start time first')),
      );
      return;
    }

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _expirationDate ?? _startTime!,
      firstDate: _startTime!,
      lastDate: DateTime.now().add(const Duration(days: 730)), // 2 years
    );

    if (!mounted) return;

    if (picked != null) {
      setState(() {
        _expirationDate = DateTime(
          picked.year,
          picked.month,
          picked.day,
        );
      });
    }
  }

  Future<void> _selectRecurringPeriodStart() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _recurringPeriodStart ?? _startTime ?? DateTime.now(),
      firstDate: _startTime ?? DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 730)),
    );

    if (!mounted) return;

    if (picked != null) {
      setState(() {
        _recurringPeriodStart = DateTime(
          picked.year,
          picked.month,
          picked.day,
        );
        // Ensure end date is after start date
        if (_recurringPeriodEnd != null &&
            _recurringPeriodEnd!.isBefore(_recurringPeriodStart!)) {
          _recurringPeriodEnd = null;
        }
      });
    }
  }

  Future<void> _selectRecurringPeriodEnd() async {
    if (_recurringPeriodStart == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select recurring period start date first')),
      );
      return;
    }

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _recurringPeriodEnd ?? _recurringPeriodStart!,
      firstDate: _recurringPeriodStart!,
      lastDate: DateTime.now().add(const Duration(days: 730)),
    );

    if (!mounted) return;

    if (picked != null) {
      if (picked.isBefore(_recurringPeriodStart!)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('End date must be after start date')),
        );
        return;
      }

      setState(() {
        _recurringPeriodEnd = DateTime(
          picked.year,
          picked.month,
          picked.day,
        );
      });
    }
  }

  void _toggleRecurringDay(int day) {
    setState(() {
      if (_selectedRecurringDays.contains(day)) {
        _selectedRecurringDays.remove(day);
      } else {
        _selectedRecurringDays.add(day);
        _selectedRecurringDays.sort();
      }
    });
  }

  String _formatDateOnly(DateTime dateTime) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[dateTime.month - 1]} ${dateTime.day}, ${dateTime.year}';
  }

  void _addTag(String tag) {
    if (tag.trim().isEmpty) return;
    final trimmedTag = tag.trim();
    if (_selectedTags.length >= 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Maximum 3 tags allowed')),
      );
      return;
    }
    if (_selectedTags.contains(trimmedTag)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tag already added')),
      );
      return;
    }
    setState(() {
      _selectedTags.add(trimmedTag);
      _tagController.clear();
    });
  }

  void _removeTag(String tag) {
    setState(() {
      _selectedTags.remove(tag);
    });
  }

  // Predefined popular tags
  static const List<String> _popularTags = [
    'Tech',
    'Music',
    'Art',
    'Food',
    'Sports',
    'Networking',
    'Education',
    'Entertainment',
    'Community',
    'Business',
    'Health',
    'Fitness',
    'Culture',
    'Family',
    'AI',
    'Live',
    'Career',
    'Festival',
  ];

  void _handleCreateEvent() {
    // Validate recurring event data if enabled
    if (_isRecurring) {
      if (_selectedRecurringDays.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select at least one day for recurring event')),
        );
        return;
      }
      if (_recurringPeriodStart == null || _recurringPeriodEnd == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select recurring period start and end dates')),
        );
        return;
      }
    }

    // TODO: Implement event creation logic
    // Include the following fields when creating the event:
    // - expirationDate: _expirationDate
    // - isRecurring: _isRecurring
    // - recurringDays: _selectedRecurringDays (if recurring)
    // - recurringPeriodStart: _recurringPeriodStart (if recurring)
    // - recurringPeriodEnd: _recurringPeriodEnd (if recurring)
    // - tags: _selectedTags (maximum 3 tags)
    
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
    _tagController.dispose();
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

                      // Start/End Time (hidden when recurring is enabled)
                      if (!_isRecurring) ...[
                        _buildTimeSection(),
                        const SizedBox(height: 20),
                      ],

                      // Expiration Date
                      _buildExpirationDateSection(),

                      const SizedBox(height: 20),

                      // Recurring Event Toggle
                      _buildRecurringToggleSection(),

                      // Recurring Event Details (shown when enabled)
                      if (_isRecurring) ...[
                        const SizedBox(height: 20),
                        _buildRecurringDetailsSection(),
                      ],

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

                      const SizedBox(height: 32),

                      // Tags Section (last as it's the least relevant and longest)
                      _buildTagsSection(),

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
          hintStyle: TextTheme.of(context).bodyLarge?.copyWith(
            color: Colors.white.withValues(alpha: 0.5),
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

  Widget _buildExpirationDateSection() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: GestureDetector(
        onTap: _selectExpirationDate,
        child: Row(
          children: [
            const Icon(Icons.event_busy_outlined, color: Colors.white70, size: 20),
            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                'Expiration Date',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
            Text(
              _expirationDate != null
                  ? _formatDateOnly(_expirationDate!)
                  : 'Select date',
              style: TextStyle(
                color: _expirationDate != null
                    ? Colors.white
                    : Colors.white60,
                fontSize: 14,
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.chevron_right, color: Colors.white70, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildRecurringToggleSection() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Row(
        children: [
          const Icon(Icons.repeat, color: Colors.white70, size: 20),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              'Recurring Event',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
          Switch(
            value: _isRecurring,
            onChanged: (value) {
              setState(() {
                _isRecurring = value;
                if (value) {
                  // Initialize recurring period dates if not set
                  if (_recurringPeriodStart == null && _startTime != null) {
                    _recurringPeriodStart = DateTime(
                      _startTime!.year,
                      _startTime!.month,
                      _startTime!.day,
                    );
                  }
                  if (_recurringPeriodEnd == null && _startTime != null) {
                    // Default to 3 months from start date
                    _recurringPeriodEnd = DateTime(
                      _startTime!.year,
                      _startTime!.month,
                      _startTime!.day,
                    ).add(const Duration(days: 90));
                  }
                } else {
                  // Clear recurring data when disabled
                  _selectedRecurringDays.clear();
                  _recurringPeriodStart = null;
                  _recurringPeriodEnd = null;
                }
              });
            },
            activeThumbColor: Colors.white,
            activeTrackColor: Colors.white.withValues(alpha: 0.5),
            inactiveThumbColor: Colors.white,
            inactiveTrackColor: Colors.white.withValues(alpha: 0.3),
          ),
        ],
      ),
    );
  }

  Widget _buildRecurringDetailsSection() {
    const daysOfWeek = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Recurring Details',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          
          // Day selector
          const Text(
            'Days of Week',
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: List.generate(7, (index) {
              final day = index + 1; // 1=Monday, 7=Sunday
              final isSelected = _selectedRecurringDays.contains(day);
              return GestureDetector(
                onTap: () => _toggleRecurringDay(day),
                child: Container(
                  width: 45,
                  height: 45,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Colors.white.withValues(alpha: 0.3)
                        : Colors.white.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isSelected
                          ? Colors.white
                          : Colors.white.withValues(alpha: 0.3),
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      daysOfWeek[index],
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.normal,
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
          
          const SizedBox(height: 20),
          
          // Recurring period start
          GestureDetector(
            onTap: _selectRecurringPeriodStart,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.calendar_today, color: Colors.white70, size: 18),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Period Start',
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                  ),
                  Text(
                    _recurringPeriodStart != null
                        ? _formatDateOnly(_recurringPeriodStart!)
                        : 'Select date',
                    style: TextStyle(
                      color: _recurringPeriodStart != null
                          ? Colors.white
                          : Colors.white60,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 12),
          
          // Recurring period end
          GestureDetector(
            onTap: _selectRecurringPeriodEnd,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.event_available, color: Colors.white70, size: 18),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Period End',
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                  ),
                  Text(
                    _recurringPeriodEnd != null
                        ? _formatDateOnly(_recurringPeriodEnd!)
                        : 'Select date',
                    style: TextStyle(
                      color: _recurringPeriodEnd != null
                          ? Colors.white
                          : Colors.white60,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTagsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              'Tags',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              '${_selectedTags.length}/3',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.7),
                fontSize: 14,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        
        // Selected tags
        if (_selectedTags.isNotEmpty) ...[
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _selectedTags.map((tag) {
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
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      tag,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 6),
                    GestureDetector(
                      onTap: () => _removeTag(tag),
                      child: Icon(
                        Icons.close,
                        size: 16,
                        color: Colors.white.withValues(alpha: 0.8),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 12),
        ],
        
        // Add tag input
        Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: TextField(
                  controller: _tagController,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                  decoration: InputDecoration(
                    hintText: _selectedTags.length >= 3 
                        ? 'Maximum 3 tags reached'
                        : 'Add a tag',
                    hintStyle: TextStyle(
                      color: Colors.white.withValues(alpha: 0.6),
                    ),
                    prefixIcon: const Icon(
                      Icons.tag,
                      color: Colors.white70,
                      size: 20,
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                  enabled: _selectedTags.length < 3,
                  onSubmitted: (value) {
                    if (_selectedTags.length < 3) {
                      _addTag(value);
                    }
                  },
                ),
              ),
            ),
            if (_selectedTags.length < 3) ...[
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () {
                  if (_tagController.text.trim().isNotEmpty) {
                    _addTag(_tagController.text);
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.25),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.add,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ],
          ],
        ),
        
        const SizedBox(height: 12),
        
        // Popular tags suggestions
        if (_selectedTags.length < 3) ...[
          const Text(
            'Popular tags',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _popularTags
                .where((tag) => !_selectedTags.contains(tag))
                .take(12)
                .map((tag) {
              return GestureDetector(
                onTap: () => _addTag(tag),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.3),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    tag,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
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
