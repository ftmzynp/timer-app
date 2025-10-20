import 'package:flutter/material.dart';
import 'package:timer/screens/private_room_creation.dart';
import 'package:timer/widgets/app_drawer.dart'; // 🔹 Sidebar import

class GeneralRoomsScreen extends StatefulWidget {
  const GeneralRoomsScreen({super.key});

  @override
  State<GeneralRoomsScreen> createState() => _GeneralRoomsScreenState();
}

class _GeneralRoomsScreenState extends State<GeneralRoomsScreen> {
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, String>> _rooms = [
    {
      "title": "Study Together",
      "subtitle": "Focus on your tasks with others",
      "image": "assets/images/study.png",
    },
    {
      "title": "Chill Zone",
      "subtitle": "Relax and chat with others",
      "image": "assets/images/chill.png",
    },
    {
      "title": "Accountability Group",
      "subtitle": "Share your progress and get support",
      "image": "assets/images/accountability.png",
    },
  ];

  List<Map<String, String>> _filteredRooms = [];

  @override
  void initState() {
    super.initState();
    _filteredRooms = List.from(_rooms);

    _searchController.addListener(() {
      final query = _searchController.text.toLowerCase();
      setState(() {
        _filteredRooms = _rooms
            .where((room) => room["title"]!.toLowerCase().contains(query))
            .toList();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(currentRoute: '/rooms',), // 🔹 kendi sidebarın
      appBar: AppBar(
        automaticallyImplyLeading: false, // geri butonunu kaldır
        centerTitle: true,
        title: const Text("Genel Odalar"),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),

      body: Column(
        children: [
          // 🔹 Arama Çubuğu
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "Oda Ara...",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.grey.shade200,
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 0,
                  horizontal: 16,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          // 🔹 Liste
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _filteredRooms.length,
              itemBuilder: (ctx, i) {
                final room = _filteredRooms[i];
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  margin: const EdgeInsets.only(bottom: 16),
                  child: ListTile(
                    leading: room["image"] != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.asset(
                              room["image"]!,
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                            ),
                          )
                        : const Icon(Icons.people, size: 40),
                    title: Text(room["title"]!),
                    subtitle: Text(room["subtitle"]!),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      Navigator.pushNamed(context, "/room");
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),

      // 🔹 Oda Oluştur Butonu
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (ctx) => const CreateRoomScreen()),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text("Oda Oluştur"),
      ),
    );
  }
}