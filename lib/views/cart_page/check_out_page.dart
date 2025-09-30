import 'package:flutter/material.dart';
import 'package:remixicon/remixicon.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../constants/app_color.dart';

class CheckOutPage extends StatelessWidget {
  const CheckOutPage({super.key});

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBgLight,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new),
        ),
        title: Text(
          'Check Out',
          style: TextStyle(
            fontSize: 24.0,
            color: AppColors.darkBg,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 30, 16, 0),
          child: Column(
            children: [
              Row(
                children: const [
                  Icon(RemixIcons.money_dollar_circle_line, size: 32.0),
                  SizedBox(width: 8.0),
                  Text(
                    'Payment Method',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              ListTile(
                tileColor: AppColors.lightBg,
                leading: const Icon(Icons.info_outline),
                title: const Text('Coming soon'),
              ),
              const SizedBox(height: 32.0),
              Row(
                children: const [
                  Icon(RemixIcons.contacts_book_2_line, size: 32.0),
                  SizedBox(width: 8.0),
                  Text(
                    'Contact By',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8.0),

              // Phone
              _buildListTile(
                icon: Icons.phone,
                title: '012777030',
                onTap: () => _launchUrl("tel:012777030"),
              ),

              // Facebook page (example)
              _buildListTile(
                icon: Icons.facebook,
                title: 'Facebook',
                onTap: () => _launchUrl("https://www.facebook.com/"),
              ),

              // Telegram chat (example)
              _buildListTile(
                icon: Icons.telegram,
                title: 'Telegram',
                onTap: () => _launchUrl("https://t.me/yourusername"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _buildListTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: ListTile(
        onTap: onTap,
        tileColor: AppColors.lightBg,
        leading: Icon(icon, size: 24.0),
        title: Text(title),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 20,
          color: Colors.grey,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 8.0),
      ),
    );
  }
}
