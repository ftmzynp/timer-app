import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RoomDashboardScreen extends StatefulWidget {
  const RoomDashboardScreen({super.key});

  @override
  State<RoomDashboardScreen> createState() => _RoomDashboardScreenState();
}

class _RoomDashboardScreenState extends State<RoomDashboardScreen> {
  Timer? _timer;
  int selectedSeconds = 0; 
  bool isRunning = false;

  // Simüle edilen kullanıcı
  String currentUser = "Sophia B."; // test için değiştir
  String get hostName => participants.firstWhere((p) => p["role"] == "Host")["name"];
  bool get isHost => currentUser == hostName;

  // Pomodoro ayarları
  int studyMinutes = 25;
  int shortBreakMinutes = 5;
  int longBreakMinutes = 15;
  int sessionsBeforeLongBreak = 4;

  int currentSession = 0;
  String currentPhase = "Ders"; // "Ders", "Kısa mola", "Uzun mola"

  // Katılımcılar
  List<Map<String, dynamic>> participants = [
    {
      "name": "Ethan H.",
      "role": "Host",
      "status": "Researching for thesis",
      "isOnline": true,
      "avatar": "https://i.pravatar.cc/150?img=1",
    },
    {
      "name": "Sophia B.",
      "role": "",
      "status": "Studying for exams",
      "isOnline": true,
      "avatar": "https://i.pravatar.cc/150?img=2",
    },
    {
      "name": "Liam C.",
      "role": "",
      "status": "Finishing homework",
      "isOnline": false,
      "avatar": "https://i.pravatar.cc/150?img=3",
    },
  ];

  @override
  void initState() {
    super.initState();
    // Kullanıcı girince status sorulsun
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _askStatusDialog();
      if (isHost) {
        _showPomodoroSetupDialog();
      }
    });
  }

  /// 🔹 Oda linkini kopyala
  void _copyRoomLink() {
    Clipboard.setData(const ClipboardData(text: "https://studyroom.app/room123"));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Oda linki kopyalandı")),
    );
  }

  /// 🔹 Kullanıcıya status sor
  void _askStatusDialog() {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Ne çalışıyorsun?"),
        content: TextField(
          controller: controller,
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              setState(() {
                final index = participants.indexWhere((p) => p["name"] == currentUser);
                if (index != -1) {
                  participants[index]["status"] = controller.text;
                  participants[index]["isOnline"] = true;
                }
              });
              Navigator.pop(ctx);
            },
            child: const Text("Kaydet"),
          )
        ],
      ),
    );
  }

  /// 🔹 Pomodoro ayar popup (host için)
  void _showPomodoroSetupDialog() {
    final controller = TextEditingController();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, dialogSetState) {
            return AlertDialog(
              title: const Text("Pomodoro Ayarları"),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildPickerTile("Ders Süresi", studyMinutes, 180, "dk",
                        (val) => dialogSetState(() => studyMinutes = val)),
                    _buildPickerTile("Kısa Mola", shortBreakMinutes, 30, "dk",
                        (val) => dialogSetState(() => shortBreakMinutes = val)),
                    _buildPickerTile("Uzun Mola", longBreakMinutes, 60, "dk",
                        (val) => dialogSetState(() => longBreakMinutes = val)),
                    _buildPickerTile("Kaç oturumdan sonra uzun mola?", sessionsBeforeLongBreak, 10, "oturum",
                        (val) => dialogSetState(() => sessionsBeforeLongBreak = val)),
                  ],
                ),
              ),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _startStudy();
                      // host status güncelle
                      final index = participants.indexWhere((p) => p["name"] == currentUser);
                      if (index != -1) {
                        participants[index]["status"] = controller.text;
                      }
                    });
                    Navigator.pop(ctx);
                  },
                  child: const Text("Başla"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  /// 🔹 Picker helper
  Widget _buildPickerTile(
    String label,
    int currentValue,
    int maxValue,
    String suffix,
    Function(int) onSelected,
  ) {
    return ListTile(
      title: Text(label),
      trailing: Text("$currentValue $suffix"),
      onTap: () {
        showModalBottomSheet(
          context: context,
          builder: (ctx) {
            return SizedBox(
              height: 200,
              child: CupertinoPicker(
                scrollController: FixedExtentScrollController(initialItem: currentValue),
                itemExtent: 40,
                onSelectedItemChanged: (val) => onSelected(val),
                children: List.generate(
                  maxValue + 1,
                  (i) => Center(child: Text("$i $suffix")),
                ),
              ),
            );
          },
        );
      },
    );
  }

  // 🔹 Timer kontrolleri
  void _startStudy() {
    currentPhase = "Ders";
    selectedSeconds = studyMinutes * 60;
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    isRunning = true;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (selectedSeconds > 0) {
        setState(() => selectedSeconds--);
      } else {
        _timer?.cancel();
      }
    });
    setState(() {});
  }

  void _stopTimer() {
    _timer?.cancel();
    setState(() => isRunning = false);
  }

  String _formatTime(int s) {
    final m = (s ~/ 60).toString().padLeft(2, "0");
    final sec = (s % 60).toString().padLeft(2, "0");
    return "$m:$sec";
  }

  /// 🔹 Kullanıcı Molaya Çık / Molayı Bitir
  void _toggleBreak() {
    final index = participants.indexWhere((p) => p["name"] == currentUser);
    if (index != -1) {
      setState(() {
        participants[index]["isOnline"] = !participants[index]["isOnline"];
      });
    }
  }

  /// 🔹 Çıkış kontrolü
  Future<bool> _onWillPop() async {
    if (isHost) {
      final result = await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text("Odadan çık"),
          content: const Text("Odayı silmek mi yoksa sadece çıkmak mı istersin?"),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx, "cancel"), child: const Text("Vazgeç")),
            TextButton(onPressed: () => Navigator.pop(ctx, "delete"), child: const Text("Odayı Sil")),
            TextButton(onPressed: () => Navigator.pop(ctx, "leave"), child: const Text("Sadece Çık")),
          ],
        ),
      );
      if (result == "delete") {
        Navigator.pop(context);
        return true;
      } else if (result == "leave") {
        setState(() {
          final idx = participants.indexWhere((p) => p["name"] == currentUser);
          participants[idx]["role"] = "";
          if (participants.length > 1) {
            participants[1]["role"] = "Host"; // sonraki admin
          }
        });
        Navigator.pop(context);
        return true;
      }
      return false;
    } else {
      final result = await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text("Odadan çık"),
          content: const Text("Çıkmak istiyor musun?"),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text("Hayır")),
            TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text("Evet")),
          ],
        ),
      );
      if (result == true) {
        setState(() {
          participants.removeWhere((p) => p["name"] == currentUser);
        });
        Navigator.pop(context);
        return true;
      }
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: theme.scaffoldBackgroundColor,
          elevation: 0,
          title: Text("Çalışma Odası", style: TextStyle(color: colorScheme.onSurface), textAlign: TextAlign.center),
          
        ),
        body: Column(
          children: [
            const SizedBox(height: 20),

            // 🔹 Timer
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 220,
                  height: 220,
                  child: CircularProgressIndicator(
                    value: selectedSeconds / (studyMinutes * 60),
                    strokeWidth: 10,
                    backgroundColor: colorScheme.surfaceVariant,
                    color: colorScheme.primary,
                  ),
                ),
                Text(
                  _formatTime(selectedSeconds),
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),

            // 🔹 Host veya kullanıcıya göre buton
            if (isHost)
              ElevatedButton(
                onPressed: isRunning ? _stopTimer : _startTimer,
                child: Text(isRunning ? "Durdur" : "Başlat"),
              )
            else
              ElevatedButton(
                onPressed: _toggleBreak,
                child: Text(
                  participants.firstWhere((p) => p["name"] == currentUser)["isOnline"]
                      ? "Molaya Çık"
                      : "Molayı Bitir",
                ),
              ),

            const SizedBox(height: 30),

            // 🔹 Participants
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Text("Katılımcılar (${participants.length})",
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: colorScheme.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.primary,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    onPressed: _copyRoomLink,
                    icon: Icon(Icons.person_add, size: 18, color: colorScheme.onPrimary),
                    label: Text("Davet Et", style: TextStyle(color: colorScheme.onPrimary)),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: participants.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.9,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemBuilder: (context, index) {
                  final p = participants[index];
                  return Container(
                    decoration: BoxDecoration(
                      color: colorScheme.surface,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Stack(
                          children: [
                            CircleAvatar(radius: 28, backgroundImage: NetworkImage(p["avatar"])),
                            Positioned(
                              right: 0,
                              bottom: 0,
                              child: CircleAvatar(
                                radius: 6,
                                backgroundColor: p["isOnline"] ? Colors.green : Colors.red,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(p["name"],
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: colorScheme.onSurface,
                              fontWeight: FontWeight.w600,
                            )),
                        if (p["role"].isNotEmpty)
                          Text(p["role"], style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          )),
                        const SizedBox(height: 4),
                        Text(p["status"],
                            textAlign: TextAlign.center,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            )),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}