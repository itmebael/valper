import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SupportScreen extends StatefulWidget {
  const SupportScreen({super.key});

  @override
  State<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {
  final List<Map<String, dynamic>> messages = [
    {'from': 'bot', 'text': 'Hello! How can I help you today?'},
  ];
  final TextEditingController _controller = TextEditingController();

  void _handleSend() {
    final input = _controller.text.trim();
    if (input.isEmpty) return;

    setState(() {
      // Add user message
      messages.add({'from': 'user', 'text': input});

      // Determine bot reply
      final lowerInput = input.toLowerCase();

      if (lowerInput.contains('hi') ||
          lowerInput.contains('hello') ||
          lowerInput.contains('hey')) {
        messages.add({'from': 'bot', 'text': 'Good day ma\'am or sir!'});
      } else if (lowerInput.contains('how to use') || lowerInput.contains('how do i use') || lowerInput.contains('instructions')) {
        messages.add({
          'from': 'bot',
          'text': 'To use this app, you can register your vehicle, check parking slots, and get support right here. Feel free to explore the menu options!'
        });
      } else if (lowerInput.contains('creator') || lowerInput.contains('who made') || lowerInput.contains('who are the creators')) {
        messages.add({
          'from': 'bot',
          'text': 'This app was created by Looren, Carlo, and Abel.'
        });
      } else {
        messages.add({
          'from': 'bot',
          'text': 'We are currently updating our system. Please try again later.'
        });
      }
    });

    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Support'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          Column(
            children: [
              Image.asset(
                'assets/valper_logo.png',
                height: 60,
              ),
              const SizedBox(height: 5),
              Text(
                'AI Chat Support',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final msg = messages[index];
                final isUser = msg['from'] == 'user';

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Row(
                    mainAxisAlignment:
                        isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (!isUser)
                        CircleAvatar(
                          backgroundImage: AssetImage('assets/valper_logo.png'),
                          radius: 16,
                        ),
                      if (!isUser) const SizedBox(width: 8),
                      Flexible(
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: isUser ? Colors.grey[400] : Colors.blue[700],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            msg['text'],
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                      if (isUser) const SizedBox(width: 8),
                      if (isUser)
                        const CircleAvatar(
                          child: Icon(Icons.person, size: 18),
                          radius: 16,
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: Colors.grey[300]!),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Ask me anything...',
                      hintStyle: GoogleFonts.poppins(),
                      filled: true,
                      fillColor: Colors.grey[100],
                      contentPadding:
                          const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onSubmitted: (_) => _handleSend(),
                  ),
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: _handleSend,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.blue[800],
                      shape: BoxShape.circle,
                    ),
                    padding: const EdgeInsets.all(12),
                    child: const Icon(Icons.send, color: Colors.white),
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
