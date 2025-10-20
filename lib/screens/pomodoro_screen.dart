import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:timer/widgets/app_drawer.dart';

class PomodoroScreen extends StatefulWidget {
  const PomodoroScreen({super.key});

  @override
  State<PomodoroScreen> createState() => _PomodoroScreenState();
}

class _PomodoroScreenState extends State<PomodoroScreen> {
  Timer? _timer;
  int remainingSeconds = 0;
  bool isRunning = false;

  // Ayarlar
  int studyMinutes = 25;
  int shortBreakMinutes = 5;
  int longBreakMinutes = 15;
  int sessionsBeforeLongBreak = 4;

  bool autoStartPomodoro = false;
  bool autoStartBreak = false;

  int currentSession = 0;
  String currentPhase = "Ders"; // "Ders", "Kısa mola", "Uzun mola"
  String? currentLabel; // seçilen ders etiketi

  @override
  void initState() {
    super.initState();
    _showSettingsDialog();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  // ---------- DİYALOGLAR ----------

  // Etiket seç & başlat
    // Etiket gir & başlat
  void _askLabelAndStart() {
    TextEditingController labelController =
        TextEditingController(text: currentLabel ?? "");

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return AlertDialog(
          title: const Text("Ne çalışacaksın?"),
          content: TextField(
            controller: labelController,
            decoration: const InputDecoration(
              hintText: "Örn: Matematik, Proje, Okuma...",
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text("İptal"),
            ),
            ElevatedButton(
              onPressed: () {
                String label = labelController.text.trim();
                if (label.isEmpty) label = "Diğer";

                setState(() {
                  _startStudy(label: label);
                });

                Navigator.pop(ctx);
              },
              child: const Text("Başla"),
            ),
          ],
        );
      },
    );
  }

  // Ayar diyalogu (ilk açılış)
  void _showSettingsDialog() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
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
                      _buildPickerTile(
                        "Ders Süresi",
                        studyMinutes,
                        180,
                        "dk",
                        (val) => dialogSetState(() => studyMinutes = val),
                      ),
                      _buildPickerTile(
                        "Kısa Mola",
                        shortBreakMinutes,
                        30,
                        "dk",
                        (val) => dialogSetState(() => shortBreakMinutes = val),
                      ),
                      _buildPickerTile(
                        "Uzun Mola",
                        longBreakMinutes,
                        60,
                        "dk",
                        (val) => dialogSetState(() => longBreakMinutes = val),
                      ),
                      _buildPickerTile(
                        "Kaç oturumdan sonra uzun mola?",
                        sessionsBeforeLongBreak,
                        10,
                        "oturum",
                        (val) => dialogSetState(() => sessionsBeforeLongBreak = val),
                      ),
                      const SizedBox(height: 10),
                      SwitchListTile(
                        title: const Text("Yeni Pomodoroyu Otomatik Başlat"),
                        value: autoStartPomodoro,
                        onChanged: (val) =>
                            dialogSetState(() => autoStartPomodoro = val),
                      ),
                      SwitchListTile(
                        title: const Text("Molayı Otomatik Başlat"),
                        value: autoStartBreak,
                        onChanged: (val) =>
                            dialogSetState(() => autoStartBreak = val),
                      ),
                    ],
                  ),
                ),
                actions: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(ctx);
                      // İlk dersten önce etiket sor
                      _askLabelAndStart();
                    },
                    child: const Text("Başla"),
                  ),
                ],
              );
            },
          );
        },
      );
    });
  }

  // Ortak picker tile
  Widget _buildPickerTile(
    String label,
    int currentValue,
    int maxValue,
    String suffix,
    Function(int) onSelected,
  ) {
    return ListTile(
      title: Text(label),
      trailing: Text(
        "$currentValue $suffix",
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
      onTap: () {
        showModalBottomSheet(
          context: context,
          builder: (ctx) {
            return SizedBox(
              height: 250,
              child: CupertinoPicker(
                scrollController:
                    FixedExtentScrollController(initialItem: currentValue),
                itemExtent: 40,
                onSelectedItemChanged: (val) => onSelected(val),
                children: List.generate(
                  maxValue + 1,
                  (i) => Center(
                    child: Text(
                      "$i $suffix",
                      style: const TextStyle(fontSize: 22),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  // Manuel başlatma diyalogu (mola için)
  void _showManualStartDialog(String phaseName, VoidCallback onStart) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("$phaseName Zamanı"),
        content: Text("$phaseName başlatmak için butona bas."),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              onStart();
            },
            child: const Text("Başla"),
          ),
        ],
      ),
    );
  }

  // ---------- ZAMANLAYICI MANTIĞI ----------

  void _startStudy({String? label}) {
    currentPhase = "Ders";
    if (label != null) currentLabel = label;
    remainingSeconds = studyMinutes * 60;
    _startTimer();
  }

  void _startShortBreak() {
    currentPhase = "Kısa mola";
    currentLabel = null; // mola sırasında etiket göstermiyoruz
    remainingSeconds = shortBreakMinutes * 60;
    _startTimer();
  }

  void _startLongBreak() {
    currentPhase = "Uzun mola";
    currentLabel = null;
    remainingSeconds = longBreakMinutes * 60;
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    isRunning = true;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingSeconds > 0) {
        setState(() => remainingSeconds--);
      } else {
        _timer?.cancel();
        _nextPhase();
      }
    });
    setState(() {});
  }

  void _stopTimer() {
    _timer?.cancel();
    setState(() => isRunning = false);
  }

  void _nextPhase() {
    if (currentPhase == "Ders") {
      currentSession++;
      if (currentSession % sessionsBeforeLongBreak == 0) {
        if (autoStartBreak) {
          _startLongBreak();
        } else {
          _showManualStartDialog("Uzun mola", _startLongBreak);
        }
      } else {
        if (autoStartBreak) {
          _startShortBreak();
        } else {
          _showManualStartDialog("Kısa mola", _startShortBreak);
        }
      }
    } else {
      // Moladan sonraki DERS
      if (autoStartPomodoro) {
        _askLabelAndStart(); // yeni derste etiket sor, sonra başlat
      } else {
        _showManualStartDialog("Ders", _askLabelAndStart);
      }
    }
  }

  String _formatTime(int seconds) {
    final m = (seconds ~/ 60).toString().padLeft(2, "0");
    final s = (seconds % 60).toString().padLeft(2, "0");
    return "$m:$s";
  }

  // ---------- UI ----------

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    const circleSize = 280.0;
    const strokeWidth = 12.0;

    final phaseMinutes = currentPhase == "Ders"
        ? studyMinutes
        : (currentPhase == "Kısa mola" ? shortBreakMinutes : longBreakMinutes);

    final total = (phaseMinutes * 60).clamp(1, 1000000); // 0'a bölmeyi engelle
    final fraction = remainingSeconds / total;

    return Scaffold(
      appBar: AppBar(centerTitle: true, title: const Text("Pomodoro")),
      drawer: const AppDrawer(currentRoute: '/pomodoro'),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              currentPhase,
              style: theme.textTheme.headlineMedium?.copyWith(
                color: colorScheme.primary,
              ),
            ),
            if (currentPhase == "Ders" && currentLabel != null)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  "$currentLabel",
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            const SizedBox(height: 20),
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: circleSize,
                  height: circleSize,
                  child: CircularProgressIndicator(
                    value: fraction,
                    strokeWidth: strokeWidth,
                    color: colorScheme.primary,
                    backgroundColor: colorScheme.surfaceVariant,
                  ),
                ),
                Text(
                  _formatTime(remainingSeconds),
                  style: theme.textTheme.displayMedium,
                ),
              ],
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                if (isRunning) {
                  _stopTimer();
                } else {
                  if (currentPhase == "Ders") {
                    _askLabelAndStart(); // ders başlarken etiketi sor ve başlat
                  } else {
                    // mola ise süreyi ayarlayıp başlat (zaten ayarlı)
                    if (remainingSeconds == 0) {
                      if (currentPhase == "Kısa mola") {
                        remainingSeconds = shortBreakMinutes * 60;
                      } else {
                        remainingSeconds = longBreakMinutes * 60;
                      }
                    }
                    _startTimer();
                  }
                }
              },
              child: Text(isRunning ? "Durdur" : "Başla"),
            ),
          ],
        ),
      ),
    );
  }
}