import 'package:flutter/material.dart';
import '../../themes/app_colors.dart';
import 'chat_page.dart';

class ChatListScreen extends StatelessWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Dummy Data untuk daftar chat
    final List<Map<String, dynamic>> chatData = [
      {
        "name": "Wildan Arifin",
        "lastChat": "Siap, estimasi 5 menit lagi sampai.",
        "time": "12:02",
        "image": "assets/images/driver_profile.png",
        "status": "Driver",
        "isOnline": true,
        "unread": 2,
      },
      {
        "name": "Budi Santoso",
        "lastChat": "Saya sudah di depan pagar ya kak.",
        "time": "Kemarin",
        "image": "assets/images/driver_profile.png",
        "status": "Driver",
        "isOnline": false,
        "unread": 0,
      },
      {
        "name": "Siti Aminah",
        "lastChat": "Pesanan ambulans sudah dikonfirmasi.",
        "time": "2 Mei",
        "image": "assets/images/driver_profile.png",
        "status": "Admin RS",
        "isOnline": true,
        "unread": 0,
      },
    ];

    return Scaffold(
      backgroundColor: AppColors.cardBg,
      appBar: AppBar(
        title: const Text(
          "Chat",
          style: TextStyle(
            color: AppColors.darkBrown,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: AppColors.darkBrown),
            onPressed: () {},
          ),
        ],
      ),
      body: Stack(
        children: [
          // Pattern Background
          Positioned.fill(
            child: Opacity(
              opacity: 0.05,
              child: Image.asset(
                'assets/images/medic_pattern.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
          ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            itemCount: chatData.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final chat = chatData[index];
              return _buildChatTile(context, chat);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildChatTile(BuildContext context, Map<String, dynamic> chat) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ChatPage()),
          );
        },
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Stack(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: AppColors.secondary,
              backgroundImage: AssetImage(chat['image']!),
            ),
            if (chat['isOnline'])
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  width: 14,
                  height: 14,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                ),
              ),
          ],
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                chat['name']!,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: AppColors.textDark,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Text(
              chat['time']!,
              style: TextStyle(
                color: chat['unread'] > 0 ? AppColors.primary : Colors.grey,
                fontSize: 12,
                fontWeight: chat['unread'] > 0 ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: chat['status'] == 'Driver' 
                                ? AppColors.primary.withValues(alpha: 0.1)
                                : AppColors.amber.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            chat['status']!,
                            style: TextStyle(
                              fontSize: 10, 
                              color: chat['status'] == 'Driver' 
                                  ? AppColors.primary 
                                  : AppColors.amber,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            chat['lastChat']!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: chat['unread'] > 0 ? Colors.black87 : Colors.black54,
                              fontSize: 13,
                              fontWeight: chat['unread'] > 0 ? FontWeight.w600 : FontWeight.normal,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (chat['unread'] > 0)
                Container(
                  margin: const EdgeInsets.only(left: 8),
                  padding: const EdgeInsets.all(6),
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    chat['unread'].toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}