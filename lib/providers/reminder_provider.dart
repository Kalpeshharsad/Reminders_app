import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../services/notification_service.dart';

enum Frequency { hourly, threeHours, sixHours, twelveHours, daily, weekly, monthly, yearly }

class Reminder {
  final String id;
  final String title;
  final Frequency frequency;
  final TimeOfDay startTime;
  final DateTime startDate;
  bool isCompleted;

  Reminder({
    required this.id,
    required this.title,
    required this.frequency,
    required this.startTime,
    required this.startDate,
    this.isCompleted = false,
  });

  String get frequencyText {
    switch (frequency) {
      case Frequency.hourly: return 'Hourly';
      case Frequency.threeHours: return '3 Hours';
      case Frequency.sixHours: return '6 Hours';
      case Frequency.twelveHours: return '12 Hours';
      case Frequency.daily: return 'Daily';
      case Frequency.weekly: return 'Weekly';
      case Frequency.monthly: return 'Monthly';
      case Frequency.yearly: return 'Yearly';
    }
  }

  Color get categoryColor {
    if (title.contains('Water')) return Colors.blue;
    if (title.contains('Vitamins')) return Colors.orange;
    if (title.contains('Gym')) return Colors.green;
    if (title.contains('Grocery')) return Colors.purple;
    return Colors.blue;
  }
}

class ReminderProvider with ChangeNotifier {
  final List<Reminder> _reminders = [
    Reminder(
      id: '1',
      title: 'Drink Water',
      frequency: Frequency.hourly,
      startTime: const TimeOfDay(hour: 8, minute: 0),
      startDate: DateTime.now(),
    ),
    Reminder(
      id: '2',
      title: 'Take Vitamins',
      frequency: Frequency.daily,
      startTime: const TimeOfDay(hour: 9, minute: 0),
      startDate: DateTime.now(),
    ),
  ];

  List<Reminder> get reminders => _reminders;

  final NotificationService _notificationService = NotificationService();

  void addReminder(Reminder reminder) {
    _reminders.add(reminder);
    _scheduleReminderNotification(reminder);
    notifyListeners();
  }

  void toggleReminder(String id) {
    final index = _reminders.indexWhere((r) => r.id == id);
    if (index != -1) {
      _reminders[index].isCompleted = !_reminders[index].isCompleted;
      notifyListeners();
    }
  }

  void removeReminder(String id) {
    _reminders.removeWhere((r) => r.id == id);
    _notificationService.cancelNotification(id.hashCode);
    notifyListeners();
  }

  void _scheduleReminderNotification(Reminder reminder) {
    DateTime scheduledDate = DateTime(
      reminder.startDate.year,
      reminder.startDate.month,
      reminder.startDate.day,
      reminder.startTime.hour,
      reminder.startTime.minute,
    );

    // If the scheduled time is in the past for today, and it's daily/hourly, we might want to schedule for next occurrence
    // but for now let's just schedule it as is.

    DateTimeComponents? matchComponents;
    switch (reminder.frequency) {
      case Frequency.daily:
        matchComponents = DateTimeComponents.time;
        break;
      case Frequency.weekly:
        matchComponents = DateTimeComponents.dayOfWeekAndTime;
        break;
      case Frequency.monthly:
        matchComponents = DateTimeComponents.dayOfMonthAndTime;
        break;
      case Frequency.yearly:
        matchComponents = DateTimeComponents.dateAndTime;
        break;
      default:
        matchComponents = null; // Hourly and others might need custom logic or just repeat
    }

    _notificationService.scheduleNotification(
      id: reminder.id.hashCode,
      title: 'Reminder: ${reminder.title}',
      body: 'It\'s time for your ${reminder.frequencyText.toLowerCase()} task!',
      scheduledDate: scheduledDate,
      matchDateTimeComponents: matchComponents,
    );
  }
}
