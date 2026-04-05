import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';

class ManualTimetableScreen extends StatefulWidget {
  const ManualTimetableScreen({super.key});

  @override
  State<ManualTimetableScreen> createState() => _ManualTimetableScreenState();
}

class _ManualTimetableScreenState extends State<ManualTimetableScreen> {
  final List<String> _availableSubjects = [
    "ML-I (TH)", "DS (TH)", "SDS (TH)", "EFM (TH)", "CMPM (TH)",
    "WE (PR)", "PBC (TUT)", "DS (PR)", "ML-I (PR)", "SDS (PR)", "CMPM (PR)",
  ];
  final Set<String> _selectedSubjects = {};

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? const Color(0xFF1E1E2C) : Colors.white;

    return Scaffold(
      appBar: AppBar(title: const Text("Manual Timetable Entry")),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: Theme.of(context).colorScheme.primary.withOpacity(isDark ? 0.15 : 0.08),
            width: double.infinity,
            child: Text(
              "Select the subjects you are enrolled in:",
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _availableSubjects.length,
              itemBuilder: (context, index) {
                final sub = _availableSubjects[index];
                final isSelected = _selectedSubjects.contains(sub);

                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(
                    color: isSelected ? Theme.of(context).colorScheme.primary.withOpacity(0.08) : cardBg,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: isSelected
                          ? Theme.of(context).colorScheme.primary.withOpacity(0.4)
                          : (isDark ? Colors.white.withOpacity(0.06) : Colors.grey.shade200),
                    ),
                  ),
                  child: CheckboxListTile(
                    title: Text(sub, style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: isDark ? Colors.white : Colors.black87,
                    )),
                    value: isSelected,
                    activeColor: Theme.of(context).colorScheme.primary,
                    onChanged: (val) {
                      setState(() {
                        if (val == true) {
                          _selectedSubjects.add(sub);
                        } else {
                          _selectedSubjects.remove(sub);
                        }
                      });
                    },
                    secondary: isSelected
                        ? Icon(Icons.check_circle, color: Theme.of(context).colorScheme.primary)
                        : Icon(Icons.circle_outlined, color: isDark ? Colors.grey.shade600 : Colors.grey.shade400),
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
            onPressed: _selectedSubjects.isEmpty
                ? null
                : () {
                    context.read<AppState>().saveManualTimetable(_selectedSubjects.toList());
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Timetable updated!"), backgroundColor: Colors.indigo),
                    );
                  },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 18),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Theme.of(context).colorScheme.onPrimary,
            ),
            child: const Text("Save Timetable", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
          ),
        ),
      ),
    );
  }
}
