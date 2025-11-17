import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../routes/app_routes.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300]!,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.grey[300]!,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('Settings', style: TextTheme.of(context).titleMedium),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User Profile Section
            _buildProfileSection(context),

            const SizedBox(height: 8),

            // Account Settings Section
            _buildSectionHeader(  ' Account Settings'),
            Container(
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  _buildSettingItem(
                    context,
                    icon: Icons.person_outline,
                    iconColor: Colors.grey[600]!,
                    title: 'Account Settings',
                    onTap: () {
                      // TODO: Navigate to account settings
                    },
                  ),
                  _buildSettingItem(
                    context,
                    icon: Icons.wallet_outlined,
                    iconColor: const Color(0xFF9C27B0), // Purple
                    title: 'Payment',
                    onTap: () {
                      // TODO: Navigate to payment
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),
            // const Divider(height: 1),

            // Preferences Section
            _buildSectionHeader('Preferences'),
            Container(
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
            _buildSettingItem(
              context,
              icon: Icons.notifications_outlined,
              iconColor: Colors.red[600]!,
              title: 'Notifications',
              onTap: () {
                // TODO: Navigate to notifications
              },
            ),
            _buildSettingItem(
              context,
              icon: Icons.shield_outlined,
              iconColor: Colors.green[600]!,
              title: 'Permissions',
              onTap: () {
                // TODO: Navigate to permissions
              },
            ),
            _buildSettingItem(
              context,
              icon: Icons.palette_outlined,
              iconColor: Colors.pink[400]!,
              title: 'Appearance',
              onTap: () {
                // TODO: Navigate to appearance
              },
            ),
          ],
        ),
      ),

            const SizedBox(height: 8),

            // Resources Section
            _buildSectionHeader('Resources'),
            Container(
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
            _buildSettingItem(
              context,
              icon: Icons.support_outlined,
              iconColor: Colors.blue[600]!,
              title: 'Contact Support',
              trailing: const Icon(
                Icons.open_in_new,
                size: 18,
                color: Colors.grey,
              ),
              onTap: () {
                // TODO: Open support
              },
            ),
            _buildSettingItem(
              context,
              icon: Icons.star_outline,
              iconColor: Colors.amber[600]!,
              title: 'Rate in App Store',
              trailing: const Icon(
                Icons.open_in_new,
                size: 18,
                color: Colors.grey,
              ),
              onTap: () {
                // TODO: Open app store rating
              },
            ),
            _buildSettingItem(
              context,
              icon: Icons.alternate_email,
              iconColor: Colors.black,
              title: 'Follow @EchoesApp',
              trailing: const Icon(
                Icons.open_in_new,
                size: 18,
                color: Colors.grey,
              ),
              onTap: () {
                // TODO: Open social media
              },
            ),
          ],
        ),
      ),

            const SizedBox(height: 24),

            // Sign Out
            Container(
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(16),
              ),
              child: _buildSettingItem(
                context,
                icon: Icons.logout,
                iconColor: Colors.red[600]!,
                title: 'Sign Out',
                onTap: () {
                  _showSignOutDialog(context);
                },
              ),
            ),

            const SizedBox(height: 32),

            // Footer
            _buildFooter(),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileSection(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () {
        context.push(AppRouter.profile);
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white24),
          color: Colors.white24,
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: Colors.pink[100],
              child: const Text(':)', style: TextStyle(fontSize: 24)),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Tester', style: TextTheme.of(context).titleSmall),
                  const SizedBox(height: 4),
                  Text(
                    'View Profile',
                    style: TextTheme.of(
                      context,
                    ).bodySmall!.copyWith(color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: Colors.grey[400]),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: Colors.grey[600],
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildSettingItem(BuildContext
  context, {
    required IconData icon,
    required Color iconColor,
    required String title,
    Widget? trailing,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: iconColor, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: TextTheme.of(  
                  context,
                ).bodyMedium,
              ),
            ),
            if (trailing != null)
              trailing
            else
              Icon(Icons.chevron_right, color: Colors.grey[400], size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'echoes',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 4),
            Icon(Icons.star, size: 12, color: Colors.grey[400]),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'Version 1.0.0 (1000)',
          style: TextStyle(fontSize: 12, color: Colors.grey[400]),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () {
                // TODO: Navigate to terms
              },
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                'Terms & Privacy',
                style: TextStyle(fontSize: 12, color: Colors.grey[500]),
              ),
            ),
            Text(
              ' · ',
              style: TextStyle(fontSize: 12, color: Colors.grey[400]),
            ),
            TextButton(
              onPressed: () {
                // TODO: Navigate to data & acknowledgments
              },
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                'Data & Acknowledgments',
                style: TextStyle(fontSize: 12, color: Colors.grey[500]),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _showSignOutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Sign Out'),
          content: const Text('Are you sure you want to sign out?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // TODO: Implement sign out logic
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text('Signed out')));
              },
              child: const Text(
                'Sign Out',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }
}
