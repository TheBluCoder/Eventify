import 'package:flutter/material.dart';

/// Manages event interaction states (likes, boosts, saves, calendar)
/// Provides centralized state management for event actions across the app
class EventStateProvider extends ChangeNotifier {
  final Set<String> _likedEventIds = {};
  final Set<String> _boostedEventIds = {};
  final Set<String> _savedEventIds = {};
  final Set<String> _calendarEventIds = {};

  // Getters for checking state
  bool isEventLiked(String eventId) => _likedEventIds.contains(eventId);
  bool isEventBoosted(String eventId) => _boostedEventIds.contains(eventId);
  bool isEventSaved(String eventId) => _savedEventIds.contains(eventId);
  bool isEventInCalendar(String eventId) => _calendarEventIds.contains(eventId);

  // Get all events by state
  Set<String> get likedEventIds => Set.unmodifiable(_likedEventIds);
  Set<String> get boostedEventIds => Set.unmodifiable(_boostedEventIds);
  Set<String> get savedEventIds => Set.unmodifiable(_savedEventIds);
  Set<String> get calendarEventIds => Set.unmodifiable(_calendarEventIds);

  // Toggle like
  void toggleLike(String eventId) {
    if (_likedEventIds.contains(eventId)) {
      _likedEventIds.remove(eventId);
    } else {
      _likedEventIds.add(eventId);
    }
    notifyListeners();
  }

  // Toggle boost
  void toggleBoost(String eventId) {
    if (_boostedEventIds.contains(eventId)) {
      _boostedEventIds.remove(eventId);
    } else {
      _boostedEventIds.add(eventId);
    }
    notifyListeners();
  }

  // Toggle save
  void toggleSave(String eventId) {
    if (_savedEventIds.contains(eventId)) {
      _savedEventIds.remove(eventId);
    } else {
      _savedEventIds.add(eventId);
    }
    notifyListeners();
  }

  // Toggle calendar
  void toggleCalendar(String eventId) {
    if (_calendarEventIds.contains(eventId)) {
      _calendarEventIds.remove(eventId);
    } else {
      _calendarEventIds.add(eventId);
    }
    notifyListeners();
  }

  // Batch operations
  void likeMultiple(List<String> eventIds) {
    _likedEventIds.addAll(eventIds);
    notifyListeners();
  }

  void unlikeMultiple(List<String> eventIds) {
    _likedEventIds.removeAll(eventIds);
    notifyListeners();
  }

  void clearAllLikes() {
    _likedEventIds.clear();
    notifyListeners();
  }

  void clearAllBoosts() {
    _boostedEventIds.clear();
    notifyListeners();
  }

  void clearAllSaved() {
    _savedEventIds.clear();
    notifyListeners();
  }

  void clearAllCalendar() {
    _calendarEventIds.clear();
    notifyListeners();
  }

  // Reset all state
  void reset() {
    _likedEventIds.clear();
    _boostedEventIds.clear();
    _savedEventIds.clear();
    _calendarEventIds.clear();
    notifyListeners();
  }
}
