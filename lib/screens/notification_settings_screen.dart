import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:material_symbols_icons/symbols.dart';
import '../providers/settings_provider.dart';
import '../app_theme.dart';

class NotificationSettingsScreen extends StatelessWidget {
  const NotificationSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Symbols.arrow_back, color: settings.primaryColor),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Notifications',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          TextButton(
            onPressed: () {},
            child: Text(
              'Edit',
              style: TextStyle(color: settings.primaryColor, fontWeight: FontWeight.bold),
            ),
          ),
        ],
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection(
              child: _buildToggleItem(
                title: 'Allow Notifications',
                subtitle: 'Receive alerts from Reminders',
                value: settings.notificationsEnabled,
                onChanged: (val) => settings.toggleNotifications(val),
              ),
            ),
            const SizedBox(height: 24),
            _buildSectionHeader('Notification Delivery'),
            _buildSection(
              child: Column(
                children: [
                  _buildToggleItem(
                    title: 'Scheduled Summary',
                    icon: Symbols.schedule,
                    iconColor: Colors.orange,
                    value: false,
                    onChanged: (val) {},
                  ),
                  const Divider(indent: 50, height: 1),
                  _buildToggleItem(
                    title: 'Time-Sensitive Notifications',
                    icon: Symbols.timer,
                    iconColor: settings.primaryColor,
                    value: true,
                    onChanged: (val) {},
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                'Time-sensitive notifications are always delivered immediately and remain on the lock screen for an hour.',
                style: TextStyle(
                  color: isDark ? Colors.white60 : Colors.black54,
                  fontSize: 11,
                ),
              ),
            ),
            const SizedBox(height: 24),
            _buildSectionHeader('Alerts'),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 20),
              decoration: BoxDecoration(
                color: isDark ? AppTheme.backgroundDark.withOpacity(0.5) : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: isDark ? Colors.white10 : Colors.black12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildAlertOption('Lock Screen', true, isDark, settings.primaryColor),
                  _buildAlertOption('Notification Center', true, isDark, settings.primaryColor),
                  _buildAlertOption('Banners', true, isDark, settings.primaryColor),
                ],
              ),
            ),
            const SizedBox(height: 24),
            _buildSection(
              child: Column(
                children: [
                  _buildToggleItem(
                    title: 'Sounds',
                    icon: Symbols.volume_up,
                    value: true,
                    onChanged: (val) {},
                    trailingText: 'Default',
                  ),
                  const Divider(indent: 50, height: 1),
                  _buildToggleItem(
                    title: 'Badges',
                    icon: Symbols.counter_1,
                    value: true,
                    onChanged: (val) {},
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            _buildSectionHeader('Options'),
            _buildSection(
              child: Column(
                children: [
                  _buildNavigationItem('Show Previews', 'When Unlocked', isDark),
                  const Divider(indent: 16, height: 1),
                  _buildNavigationItem('Notification Grouping', 'Automatic', isDark),
                ],
              ),
            ),
            const SizedBox(height: 40),
            Center(
              child: Text(
                'Reminders notification settings can also be modified in the main system settings app under Privacy & Security.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: isDark ? Colors.white30 : Colors.black38,
                  fontSize: 11,
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, bottom: 8),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          color: Colors.grey,
          fontSize: 12,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildSection({required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
      ),
      clipBehavior: Clip.antiAlias,
      child: child,
    );
  }

  Widget _buildToggleItem({
    required String title,
    String? subtitle,
    IconData? icon,
    Color? iconColor,
    required bool value,
    required ValueChanged<bool> onChanged,
    String? trailingText,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(icon, color: iconColor ?? Colors.grey, size: 24),
            const SizedBox(width: 12),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                if (subtitle != null)
                  Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
          ),
          if (trailingText != null)
            Text(trailingText, style: const TextStyle(color: Colors.grey, fontSize: 14)),
          const SizedBox(width: 8),
          Switch(
            value: value,
            onChanged: onChanged,
            activeTrackColor: const Color(0xFF0D7FF2),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationItem(String title, String value, bool isDark) {
    return ListTile(
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(value, style: const TextStyle(color: Colors.grey)),
          const Icon(Symbols.chevron_right, color: Colors.grey),
        ],
      ),
      onTap: () {},
    );
  }

  Widget _buildAlertOption(String label, bool selected, bool isDark, Color primary) {
    return Column(
      children: [
        Container(
          width: 50,
          height: 80,
          decoration: BoxDecoration(
            color: isDark ? Colors.black26 : Colors.grey[200],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: selected ? primary : (isDark ? Colors.white12 : Colors.black12),
              width: 2,
            ),
          ),
          child: Column(
            children: [
              const SizedBox(height: 10),
              Container(
                width: 30,
                height: 4,
                decoration: BoxDecoration(
                  color: primary.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(fontSize: 10)),
        Checkbox(
          value: selected,
          onChanged: (val) {},
          shape: const CircleBorder(),
          activeColor: primary,
        ),
      ],
    );
  }
}
