import 'dart:async';
import 'dart:math';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:timer/widgets/app_drawer.dart';

class TimerHome extends StatefulWidget {
  const TimerHome({super.key});

  @override
  State<TimerHome> createState() => _TimerHomeState();
}

class _TimerHomeState extends State<TimerHome> {
  int maxMinutes = 180;
  int selectedSeconds = 0;
  bool isRunning = false;
  bool isCountdown = true;
  Timer? _timer;
  bool isFullscreen = false;

  String? studyLabel; // 🔹 Çalışma etiketi

  static const double _startAngle = -pi / 2;

  void _toggleMode(bool countdown) {
    setState(() {
      isCountdown = countdown;
      selectedSeconds = 0;
      _timer?.cancel();
      isRunning = false;
    });
  }

  void _startPause() {
    if (isRunning) {
      _timer?.cancel();
      setState(() => isRunning = false);
      return;
    }
    if (selectedSeconds == 0 && isCountdown) return;

    // 🔹 Başlamadan önce etiket sorulsun
    if (studyLabel == null || studyLabel!.isEmpty) {
      _askStudyLabel();
      return;
    }

    setState(() => isRunning = true);

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (isCountdown) {
          if (selectedSeconds > 0) {
            selectedSeconds--;
          } else {
            _stopTimer();
          }
        } else {
          selectedSeconds++;
        }
      });
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    setState(() => isRunning = false);
  }

  void _resetTimer() {
    _timer?.cancel();
    setState(() {
      isRunning = false;
      selectedSeconds = 0;
      // studyLabel = null; // 🔹 İstersen reset ile etiketi de sıfırlatabilirsin
    });
  }

  String _formatTime(int totalSeconds) {
    final minutes = totalSeconds ~/ 60;
    final seconds = totalSeconds % 60;
    return "${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";
  }

  // 🔹 Yardımcılar
  double _angleToSpan(double rawAngle) {
    double a = rawAngle - _startAngle;
    while (a < 0) a += 2 * pi;
    if (a > 2 * pi) a = 2 * pi;
    return a;
  }

  int _secondsFromSpan(double spanAngle) {
    final frac = (spanAngle / (2 * pi)).clamp(0.0, 1.0);
    int secs = (frac * maxMinutes * 60).round();
    if (secs > maxMinutes * 60) secs = maxMinutes * 60;
    return secs;
  }

  double _spanFromSeconds(int seconds) {
    final frac = (seconds / (maxMinutes * 60)).clamp(0.0, 1.0);
    return frac * 2 * pi;
  }

  // 🔹 Manuel süre seçimi
  Future<void> _showTimePicker() async {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    int currentMinutes = selectedSeconds ~/ 60;
    int currentSeconds = selectedSeconds % 60;

    int pickedMinutes = currentMinutes;
    int pickedSeconds = currentSeconds;

    await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              height: 350,
              color: theme.cardColor.withOpacity(0.95),
              child: StatefulBuilder(
                builder: (context, setModalState) {
                  return Column(
                    children: [
                      const SizedBox(height: 10),
                      Container(
                        height: 5,
                        width: 50,
                        decoration: BoxDecoration(
                          color: theme.dividerColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      const SizedBox(height: 15),
                      Text(
                        "Süre Ayarla",
                        style: theme.textTheme.titleLarge?.copyWith(
                          color: colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Expanded(
                        child: Row(
                          children: [
                            Expanded(
                              child: CupertinoPicker(
                                scrollController: FixedExtentScrollController(
                                  initialItem: currentMinutes,
                                ),
                                itemExtent: 40,
                                onSelectedItemChanged: (val) {
                                  setModalState(() => pickedMinutes = val);
                                },
                                children: List.generate(
                                  maxMinutes + 1,
                                  (i) => Center(
                                    child: Text(
                                      "$i dk",
                                      style: TextStyle(
                                        color: i == pickedMinutes
                                            ? colorScheme.primary
                                            : colorScheme.onSurface,
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: CupertinoPicker(
                                scrollController: FixedExtentScrollController(
                                  initialItem: currentSeconds,
                                ),
                                itemExtent: 40,
                                onSelectedItemChanged: (val) {
                                  setModalState(() => pickedSeconds = val);
                                },
                                children: List.generate(
                                  60,
                                  (i) => Center(
                                    child: Text(
                                      "$i sn",
                                      style: TextStyle(
                                        color: i == pickedSeconds
                                            ? colorScheme.primary
                                            : colorScheme.onSurface,
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          TextButton(
                            child: Text(
                              "İptal",
                              style: TextStyle(color: colorScheme.onSurface),
                            ),
                            onPressed: () => Navigator.pop(context),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: colorScheme.primary,
                              foregroundColor: colorScheme.onPrimary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text("Kaydet"),
                            onPressed: () {
                              int totalSecs =
                                  pickedMinutes * 60 + pickedSeconds;
                              if (totalSecs > maxMinutes * 60) {
                                totalSecs = maxMinutes * 60;
                              }
                              setState(() {
                                selectedSeconds = totalSecs;
                              });
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                    ],
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  // 🔹 Çalışma etiketi popup
  void _askStudyLabel() {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Ne çalışıyorsun?"),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: "Örn: Matematik, Proje, Kitap..."),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("İptal"),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                studyLabel = controller.text;
              });
              Navigator.pop(ctx);
              _startPause(); // etiket belirlendikten sonra timer başlasın
            },
            child: const Text("Başla"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    const strokeWidth = 12.0;
    const circleSize = 280.0;

    final radius = circleSize / 2;
    final handleRadius = radius;

    final span = _spanFromSeconds(selectedSeconds);
    final angleFromSeconds = _startAngle + span;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          isCountdown ? "Zamanlayıcı" : "Kronometre",
          style: theme.textTheme.titleMedium?.copyWith(
            color: colorScheme.onSurface,
          ),
        ),
      ),
      drawer: AppDrawer(currentRoute: '/home'),
      body: SafeArea(
        child: Column(
          children: [
            if (studyLabel != null && studyLabel!.isNotEmpty) ...[
              const SizedBox(height: 10),
              Text(
                "$studyLabel",
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.primary,
                ),
              ),
              const SizedBox(height: 10),
            ],

            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return GestureDetector(
                    onTapDown: (details) {
                      if(isRunning) return;
                      final RenderBox box =
                          context.findRenderObject() as RenderBox;
                      final center = box.size.center(Offset.zero);
                      final touchPos =
                          box.globalToLocal(details.globalPosition) - center;

                      final distance = touchPos.distance;
                      final innerRadius = radius - strokeWidth;
                      final outerRadius = radius + strokeWidth;

                      if (distance >= innerRadius && distance <= outerRadius) {
                        final rawAngle = atan2(touchPos.dy, touchPos.dx);
                        final span = _angleToSpan(rawAngle);
                        setState(() {
                          selectedSeconds = _secondsFromSpan(span);
                        });
                      } else {
                        setState(() {
                          isFullscreen = !isFullscreen;
                        });
                      }
                    },
                    child: Center(
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          SizedBox(
                            width: circleSize,
                            height: circleSize,
                            child: CircularProgressIndicator(
                              value: isCountdown
                                  ? selectedSeconds / (maxMinutes * 60)
                                  : 1.0,
                              strokeWidth: strokeWidth,
                              color: colorScheme.primary,
                              backgroundColor: colorScheme.surfaceVariant,
                            ),
                          ),
                          Transform.translate(
                            offset: Offset(
                              handleRadius * cos(angleFromSeconds),
                              handleRadius * sin(angleFromSeconds),
                            ),
                            child: GestureDetector(
                              behavior: HitTestBehavior.translucent,
                              onPanUpdate: (details) {
                                if(isRunning) return;
                                final RenderBox box =
                                    context.findRenderObject() as RenderBox;
                                final center = box.size.center(Offset.zero);
                                final touchPos =
                                    box.globalToLocal(details.globalPosition) -
                                    center;
                                final rawAngle = atan2(
                                  touchPos.dy,
                                  touchPos.dx,
                                );
                                final span = _angleToSpan(rawAngle);
                                setState(() {
                                  selectedSeconds = _secondsFromSpan(span);
                                });
                              },
                              child: CircleAvatar(
                                radius: 10,
                                backgroundColor: colorScheme.primary,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: _showTimePicker,
                            child: Text(
                              _formatTime(selectedSeconds),
                              style: theme.textTheme.headlineMedium?.copyWith(
                                color: colorScheme.onSurface,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            if (!isRunning)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ChoiceChip(
                    label: const Text("Zamanlayıcı"),
                    selected: isCountdown,
                    onSelected: (_) => _toggleMode(true),
                  ),
                  const SizedBox(width: 12),
                  ChoiceChip(
                    label: const Text("Kronometre"),
                    selected: !isCountdown,
                    onSelected: (_) => _toggleMode(false),
                  ),
                ],
              ),

            const SizedBox(height: 20),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
                minimumSize: const Size(200, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              onPressed: _startPause,
              child: Text(
                isRunning ? "Durdur" : "Başlat",
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 10),

            if (!isRunning && selectedSeconds > 0)
              TextButton(
                onPressed: _resetTimer,
                child: Text(
                  "Sıfırla",
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface,
                    fontSize: 16,
                  ),
                ),
              ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}