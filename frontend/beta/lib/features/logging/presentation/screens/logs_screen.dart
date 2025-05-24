import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../../data/models/log_entry.dart';

class LogsScreen extends StatefulWidget {
  const LogsScreen({super.key});

  @override
  State<LogsScreen> createState() => _LogsScreenState();
}

class _LogsScreenState extends State<LogsScreen> {
  late Box<LogEntry> logBox;
  bool isLoading = true;
  List<LogEntry> logs = [];

  @override
  void initState() {
    super.initState();
    _loadLogs();
  }

  Future<void> _loadLogs() async {
    logBox = await Hive.openBox<LogEntry>('logs');
    setState(() {
      logs = logBox.values.toList();
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final categories = ['blood sugar', 'sleep', 'mood', 'food', 'exercise'];
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text('My Logs', style: TextStyle(color: Colors.black)),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : logs.isEmpty
              ? const Center(
                  child: Text('No logs yet.',
                      style: TextStyle(color: Colors.black54)))
              : ListView(
                  padding: const EdgeInsets.all(16),
                  children: categories.map((cat) {
                    final catLogs =
                        logs.where((l) => l.type.toLowerCase() == cat).toList();
                    if (catLogs.isEmpty) return const SizedBox.shrink();
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(
                            cat[0].toUpperCase() + cat.substring(1),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Colors.blueAccent,
                            ),
                          ),
                        ),
                        ...catLogs.map((log) => Card(
                              color: Colors.white,
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14)),
                              child: ListTile(
                                title: Text(log.value,
                                    style:
                                        const TextStyle(color: Colors.black)),
                                subtitle: Text(
                                  log.timestamp.toString(),
                                  style: const TextStyle(
                                      color: Colors.black54, fontSize: 12),
                                ),
                              ),
                            )),
                        const SizedBox(height: 12),
                      ],
                    );
                  }).toList(),
                ),
    );
  }
}
