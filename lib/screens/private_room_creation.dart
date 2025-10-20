import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CreateRoomScreen extends StatefulWidget {
  const CreateRoomScreen({super.key});

  @override
  State<CreateRoomScreen> createState() => _CreateRoomScreenState();
}

class _CreateRoomScreenState extends State<CreateRoomScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  int _maxPeople = 5;
  String _theme = "Genel";
  String? _inviteLink;

  bool _isLoading = false;

  Future<void> _createRoom() async {
    if (_nameController.text.isEmpty) return;

    setState(() => _isLoading = true);

    // 🔹 Burada backend API çağrısı yapılacak
    // Örn: final response = await http.post(...)

    await Future.delayed(const Duration(seconds: 2)); // simülasyon
    setState(() {
      _inviteLink = "https://focus.io/join/abcd1234"; // backend’den gelecek link
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text("Özel Oda Oluştur")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: "Oda İsmi",
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _descController,
              decoration: const InputDecoration(
                labelText: "Açıklama (isteğe bağlı)",
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Text("Maksimum Katılımcı Sayısı: "),
                const SizedBox(width: 10),
                DropdownButton<int>(
                  value: _maxPeople,
                  items: List.generate(
                    10,
                    (i) => DropdownMenuItem(
                      value: i + 1,
                      child: Text("${i + 1}"),
                    ),
                  ),
                  onChanged: (val) {
                    setState(() => _maxPeople = val ?? 5);
                  },
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Text("Tema: "),
                const SizedBox(width: 10),
                DropdownButton<String>(
                  value: _theme,
                  items: ["Genel", "Sakin", "Enerjik"]
                      .map((t) => DropdownMenuItem(
                            value: t,
                            child: Text(t),
                          ))
                      .toList(),
                  onChanged: (val) {
                    setState(() => _theme = val ?? "Genel");
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: _isLoading ? null : _createRoom,
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : const Text("Oda Oluştur & Odaklanmaya Başla"),
              ),
            ),
            const SizedBox(height: 20),
            if (_inviteLink != null)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: colorScheme.primary),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        _inviteLink!,
                        style: const TextStyle(fontSize: 14),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.copy),
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: _inviteLink!));
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Link kopyalandı!")),
                        );
                      },
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}