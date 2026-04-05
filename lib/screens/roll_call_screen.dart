import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';

class RollCallScreen extends StatefulWidget {
  final String subjectName;
  const RollCallScreen({super.key, required this.subjectName});

  @override
  State<RollCallScreen> createState() => _RollCallScreenState();
}

class _RollCallScreenState extends State<RollCallScreen> {
  final Map<String, bool> _attendanceData = {};

  @override
  void initState() {
    super.initState();
    final appState = context.read<AppState>();
    for (var student in appState.students) {
      _attendanceData[student.id] = false;
    }
  }

  void _markAllPresent() {
    setState(() {
      for (var key in _attendanceData.keys) {
        _attendanceData[key] = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? const Color(0xFF1E1E2C) : Colors.white;

    return Scaffold(
      appBar: AppBar(
        title: Text("Roll Call: ${widget.subjectName}"),
        actions: [
          TextButton.icon(
            icon: const Icon(Icons.done_all),
            label: const Text("All Present"),
            onPressed: _markAllPresent,
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            color: Colors.orange.withOpacity(isDark ? 0.15 : 0.08),
            width: double.infinity,
            child: Text(
              "Students with HOD proxy letters are highlighted.",
              style: TextStyle(
                color: Colors.orange.shade700,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: appState.students.length,
              itemBuilder: (context, index) {
                final student = appState.students[index];
                final hasHodLetter = student.hodLetterUrl != null;
                final isPresent = _attendanceData[student.id] ?? false;

                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    color: isPresent
                        ? (isDark ? Colors.green.withOpacity(0.1) : Colors.green.withOpacity(0.05))
                        : cardBg,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: hasHodLetter
                          ? Colors.orange.shade400
                          : (isDark ? Colors.white.withOpacity(0.06) : Colors.grey.shade200),
                      width: hasHodLetter ? 2 : 1,
                    ),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    title: Row(
                      children: [
                        Text(
                          student.name,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: isDark ? Colors.white : Colors.black87,
                          ),
                        ),
                        if (hasHodLetter) ...[
                          const SizedBox(width: 8),
                          Icon(Icons.verified_user, color: Colors.orange.shade500, size: 18),
                        ],
                      ],
                    ),
                    subtitle: Text("${student.batch} | ID: ${student.id}",
                      style: TextStyle(fontSize: 13, color: isDark ? Colors.grey.shade400 : Colors.grey.shade600)),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (hasHodLetter)
                          TextButton(
                            onPressed: () => _showHodDialog(student.name),
                            child: Text("View", style: TextStyle(color: Colors.orange.shade500, fontSize: 12)),
                          ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _attendanceData[student.id] = !isPresent;
                            });
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isPresent ? const Color(0xFF00B4D8) : Colors.transparent,
                              border: Border.all(
                                color: isPresent ? const Color(0xFF00B4D8) : (isDark ? Colors.grey.shade600 : Colors.grey.shade400),
                                width: 2,
                              ),
                            ),
                            child: isPresent
                                ? const Icon(Icons.check, color: Colors.white, size: 20)
                                : const SizedBox(),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            onPressed: () {
              appState.submitRollCall(_attendanceData, widget.subjectName);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Roll Call Submitted Successfully"), backgroundColor: Colors.indigo),
              );
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 18),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Theme.of(context).colorScheme.onPrimary,
            ),
            child: const Text("Submit Roll Call", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
          ),
        ),
      ),
    );
  }

  void _showHodDialog(String name) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Theme.of(context).cardColor,
        title: Text("Proxy Letter: $name"),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.description, size: 64, color: Colors.orange),
            SizedBox(height: 12),
            Text("HOD Signature: Verified\nDate: Today\nReason: Participating in Hackathon"),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Close")),
        ],
      ),
    );
  }
}
