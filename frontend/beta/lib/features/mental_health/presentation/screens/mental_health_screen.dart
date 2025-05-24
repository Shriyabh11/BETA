import 'package:flutter/material.dart';
import 'package:beta/features/mental_health/data/datasource/summary_remote_datasource.dart'
    as summary_ds;
import 'package:beta/core/utils/constants.dart';
import 'package:beta/features/mental_health/data/datasource/chat_remote_datasource.dart';
// import your backend connection as needed

class MentalHealthScreen extends StatefulWidget {
  const MentalHealthScreen({super.key});

  @override
  State<MentalHealthScreen> createState() => _MentalHealthScreenState();
}

class _MentalHealthScreenState extends State<MentalHealthScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, dynamic>> _messages = [
    {'isBot': true, 'text': "Let's talk about how you're feeling! 😊"},
  ];
  String? selectedMood;
  String? summaryText;
  int? totalEntries;
  int? depressionCount;
  String? lastUpdated;
  String? errorMsg;
  bool _isLoading = false;

  late final ChatDataSource _chatDataSource;

  @override
  void initState() {
    super.initState();
    _fetchSummary();
    _chatDataSource = ChatDataSource(baseUrl: 'http://10.0.2.2:8002');
  }

  Future<void> _fetchSummary() async {
    final summaryDataSource =
        summary_ds.SummaryDataSource(baseUrl: baseUrlMentalHealth);
    try {
      final summary = await summaryDataSource.fetchSummary();
      setState(() {
        summaryText = summary.summary;
        totalEntries = summary.stats.totalEntries;
        depressionCount = summary.stats.depressionCount;
        lastUpdated = summary.stats.lastUpdated;
        errorMsg = null;
      });
    } catch (e) {
      setState(() {
        errorMsg = 'Failed to fetch summary: $e';
      });
    }
  }

  void _sendMessage(String text) async {
    if (text.trim().isEmpty) return;
    setState(() {
      _messages.add({'isBot': false, 'text': text});
      _isLoading = true;
    });
    _controller.clear();
    try {
      final response = await _chatDataSource.sendMessage(text);
      setState(() {
        _messages.add({'isBot': true, 'text': response});
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _messages.add({
          'isBot': true,
          'text': 'Sorry, something went wrong. Please try again.'
        });
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text('Mental Health Check-in',
            style: TextStyle(color: Colors.black)),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 32.0, bottom: 16.0),
            child: Text(
              'Welcome to your safe space 💙',
              style: const TextStyle(
                color: Colors.black,
                fontSize: 22,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          if (errorMsg != null) ...[
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(errorMsg!,
                  style: const TextStyle(color: Colors.redAccent)),
            ),
          ] else ...[
            if (summaryText != null) ...[
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  summaryText!,
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontStyle: FontStyle.italic),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _StatCard(
                        label: 'Entries',
                        value: totalEntries?.toString() ?? '-'),
                    _StatCard(
                        label: 'Depression',
                        value: depressionCount?.toString() ?? '-'),
                    _StatCard(label: 'Last Updated', value: lastUpdated ?? '-'),
                  ],
                ),
              ),
            ],
            const Padding(
              padding: EdgeInsets.all(12.0),
              child: Text(
                'This is a safe space just for you. How are you today?',
                style: TextStyle(color: Colors.black54, fontSize: 15),
                textAlign: TextAlign.center,
              ),
            ),
          ],
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              itemCount: _messages.length,
              itemBuilder: (context, i) {
                final msg = _messages[i];
                return _ChatBubble(isBot: msg['isBot'], text: msg['text']);
              },
            ),
          ),
          Container(
            color: Colors.transparent,
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    style: const TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      hintText: 'Type your thoughts...'
                          ' (This is a safe, judgment-free zone)',
                      hintStyle: const TextStyle(color: Colors.black54),
                      filled: true,
                      fillColor: Colors.black.withOpacity(0.08),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 14),
                    ),
                    onSubmitted: _sendMessage,
                    enabled: !_isLoading,
                  ),
                ),
                const SizedBox(width: 8),
                _isLoading
                    ? const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                                Color(0xFF5ED2C6)),
                          ),
                        ),
                      )
                    : CircleAvatar(
                        backgroundColor: const Color(0xFF5ED2C6),
                        child: IconButton(
                          icon: const Icon(Icons.send_rounded,
                              color: Colors.white),
                          onPressed: () => _sendMessage(_controller.text),
                        ),
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  const _StatCard({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.08),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Text(label,
              style: const TextStyle(color: Colors.black54, fontSize: 12)),
          const SizedBox(height: 2),
          Text(value,
              style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 14)),
        ],
      ),
    );
  }
}

class _ChatBubble extends StatelessWidget {
  final bool isBot;
  final String text;
  const _ChatBubble({required this.isBot, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: isBot ? Colors.black.withOpacity(0.05) : Colors.transparent,
        border: Border(
          bottom: BorderSide(
            color: Colors.black.withOpacity(0.1),
            width: 1,
          ),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // No avatar/profile pic for safe space
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isBot ? 'Beta' : 'You',
                  style: TextStyle(
                    color: Colors.black.withOpacity(0.7),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  text,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
