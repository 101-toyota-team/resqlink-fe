import 'package:flutter/material.dart';
import 'chat_page.dart'; 

class ChatListScreen extends StatelessWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Dummy Data untuk daftar chat
    final List<Map<String, String>> chatData = [
      {
        "name": "Amel Carla",
        "lastChat": "Siap, estimasi 5 menit lagi sampai.",
        "time": "12:02",
        "image": "assets/images/driver_profile.png",
        "status": "Driver"
      },
      {
        "name": "Budi Santoso",
        "lastChat": "Saya sudah di depan pagar ya kak.",
        "time": "Kemarin",
        "image": "assets/images/driver_profile.png", 
        "status": "Driver"
      },
      {
        "name": "Siti Aminah",
        "lastChat": "Pesanan ambulans sudah dikonfirmasi.",
        "time": "2 Mei",
        "image": "assets/images/driver_profile.png",
        "status": "Admin RS"
      },
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Chat",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0.5,
        automaticallyImplyLeading: false, 
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: Color(0xFFFFF3DE), 
          image: DecorationImage(
            image: AssetImage('assets/images/medic_pattern.png'),
            fit: BoxFit.cover,
            opacity: 0.3,
          ),
        ),
        child: ListView.separated(
          padding: const EdgeInsets.symmetric(vertical: 10),
          itemCount: chatData.length,
          separatorBuilder: (context, index) => const Divider(height: 1, indent: 80),
          itemBuilder: (context, index) {
            final chat = chatData[index];
            return ListTile(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ChatPage()),
                );
              },
              leading: CircleAvatar(
                radius: 28,
                backgroundImage: AssetImage(chat['image']!),
              ),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    chat['name']!,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Text(
                    chat['time']!,
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Row(
                  children: [
                    // Badge status (Driver/Admin)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        chat['status']!,
                        style: const TextStyle(fontSize: 10, color: Colors.grey),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Cuplikan chat
                    Expanded(
                      child: Text(
                        chat['lastChat']!,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: Colors.black54, fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}