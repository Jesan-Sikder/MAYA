import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/message.dart';
import '../services/gemini_service.dart';
import '../services/auth_service.dart';
import '../widgets/message_bubble.dart';
import '../widgets/chat_input.dart';
import '../widgets/theme_toggle.dart';
class ChatScreen extends StatefulWidget {
  const ChatScreen({super. key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  void _toggleTheme() => setState(() => _isDark = !_isDark);
  final GeminiService _geminiService = GeminiService();
  final List<Message> _messages = [];
  final ScrollController _scrollController = ScrollController();
  bool _isTyping = false;
  bool _isDark = true;
  @override
  void initState() {
    super.initState();
    // Welcome message
    _messages.add(Message(
      text: "Hi! I'm MAYA, your mental health companion.  💙 I'm here to listen, support, and guide you on your journey to better mental health. How are you feeling today?",
      isUser: false,
    ));
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding. instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _handleSendMessage(String text) async {
    if (text.trim().isEmpty) return;

    final userMessage = Message(text: text, isUser: true);
    setState(() {
      _messages.add(userMessage);
      _isTyping = true;
    });
    _scrollToBottom();

    try {
      final response = await _geminiService.sendMessage(text);
      final mayaMessage = Message(text: response, isUser: false);

      setState(() {
        _messages.add(mayaMessage);
        _isTyping = false;
      });
      _scrollToBottom();
    } catch (e) {
      setState(() {
        _messages. add(Message(
          text: "I apologize, but I'm having trouble responding right now. Please try again. 💙",
          isUser: false,
        ));
        _isTyping = false;
      });
      _scrollToBottom();
    }
  }

  void _clearChat() {
    setState(() {
      _messages.clear();
      _messages.add(Message(
        text: "Chat cleared! How can I help you today? 💙",
        isUser: false,
      ));
    });
    _geminiService.clearHistory();
  }

  Future<void> _handleSignOut() async {
    // Show confirmation dialog
    final shouldSignOut = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out? '),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );

    if (shouldSignOut == true && mounted) {
      final authService = Provider.of<AuthService>(context, listen: false);
      await authService. signOut();
    }
  }

  // ✅ HELPER METHOD INSIDE THE CLASS
  String _getInitial(User? user) {
    if (user?. displayName != null && user! .displayName!.isNotEmpty) {
      return user.displayName! .substring(0, 1). toUpperCase();
    }
    if (user?.email != null && user!.email!. isNotEmpty) {
      return user.email!.substring(0, 1).toUpperCase();
    }
    return 'M';
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('MAYA Ai'),
        backgroundColor: const Color(0xFF10a37f),
        foregroundColor: Colors. white,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: _clearChat,
            tooltip: 'Clear chat',
          ),
          ThemeToggleButton(
            isDark: _isDark,
            onToggle: _toggleTheme,
          ),
        ],
      ),


      drawer: Drawer(
        child: Container(
          color: _isDark ? const Color(0xFF222B27) : Colors.white,
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
          UserAccountsDrawerHeader(
          decoration: BoxDecoration(
          gradient: _isDark
            ? const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF222B27), Color(0xFF222B27)],
          )
              : const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF10a37f), Color(0xFF195d4a)],
        ),
      ),






              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                backgroundImage: user?.photoURL != null
                    ? NetworkImage(user!.photoURL!)
                    : null,
                child: user?.photoURL == null
                    ? Text(
                  _getInitial(user), // ✅ USE THE HELPER METHOD
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF10a37f),
                  ),
                )
                    : null,
              ),
              accountName: Text(
                user?.displayName ?? 'MAYA User',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              accountEmail: Text(user?.email ??  'No email'),
            ),



              ListTile(
                leading: Icon(Icons.chat_bubble_outline, color: _isDark ? Colors.white : Colors.black),
                title: Text('Chat', style: TextStyle(color: _isDark ? Colors.white : Colors.black)),
                onTap: () => Navigator.pop(context),
              ),
              ListTile(
                leading: Icon(Icons.delete_outline, color: _isDark ? Colors.white : Colors.black),
                title: Text('Clear Chat', style: TextStyle(color: _isDark ? Colors.white : Colors.black)),
                onTap: () {
                  Navigator.pop(context);
                  _clearChat();
                },
              ),
              const Divider(),
              ListTile(
                leading: Icon(Icons.info_outline, color: _isDark ? Colors.white : Colors.black),
                title: Text('About MAYA', style: TextStyle(color: _isDark ? Colors.white : Colors.black)),
                onTap: () {
                  Navigator.pop(context);
                  showAboutDialog(
                    context: context,
                    applicationName: 'MAYA AI',
                    applicationVersion: '1.0.0',
                    applicationIcon: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF10a37f),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'MAYA',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    children: const [
                      Text(
                        'Your Mental Health AI Assistant\n\n'
                            'MAYA is here to provide compassionate support and guidance '
                            'on your mental health journey. Remember, MAYA is a supportive '
                            'companion and not a replacement for professional therapy.',
                      ),
                    ],
                  );
                },
              ),
              // ListTile(
              //   leading: Icon(Icons.developer_mode, color: _isDark ? Colors.white : Colors.black),
              //   title: Text('Developer', style: TextStyle(color: _isDark ? Colors.white : Colors.black)),
              //   onTap: () {
              //     Navigator.pop(context); // close drawer
              //     showDialog(
              //       context: context,
              //       builder: (context) => AlertDialog(
              //         title: const Text('Developer'),
              //         content: Column(
              //           mainAxisSize: MainAxisSize.min,
              //           children: [
              //             CircleAvatar(
              //               radius: 36,
              //               backgroundImage: NetworkImage(
              //                 "https://avatars.githubusercontent.com/u/151659583?s=400&u=2603f17d7d5582f30a67b2bf5d8c21838906903d&v=4",
              //               ),
              //               backgroundColor: Colors.transparent,
              //             ),
              //             const SizedBox(height: 12),
              //             const Text(
              //               'Created by Jesan',
              //               style: TextStyle(
              //                 fontWeight: FontWeight.bold,
              //                 fontSize: 16,
              //               ),
              //               textAlign: TextAlign.center,
              //             ),
              //             const SizedBox(height: 8),
              //             const Text(
              //               "I'm the developer behind MAYA AI.\nFeel free to reach out!",
              //               textAlign: TextAlign.center,
              //             ),
              //           ],
              //         ),
              //         actions: [
              //           TextButton(
              //             onPressed: () => Navigator.pop(context),
              //             child: const Text('Close'),
              //           ),
              //         ],
              //       ),
              //     );
              //   },
              // ),
              ListTile(
                leading: Icon(Icons.developer_mode, color: _isDark ? Colors.white : Colors.black),
                title: Text('Developer', style: TextStyle(color: _isDark ? Colors.white : Colors.black)),
                onTap: () {
                  Navigator.pop(context); // close drawer
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Developer'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // First Developer
                          CircleAvatar(
                            radius: 36,
                            backgroundImage: NetworkImage(
                              "https://avatars.githubusercontent.com/u/151659583?s=400&u=2603f17d7d5582f30a67b2bf5d8c21838906903d&v=4",
                            ),
                            backgroundColor: Colors.transparent,
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'Developer: Jesan HR',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            "I'm the developer behind MAYA AI.\nFeel free to reach out!",
                            textAlign: TextAlign.center,
                          ),

                          // Second Developer
                          const SizedBox(height: 20), // extra spacing
                          CircleAvatar(
                            radius: 36,
                            backgroundImage: NetworkImage(
                              "https://avatars.githubusercontent.com/u/53723390?v=4", // Change to their avatar URL
                            ),
                            backgroundColor: Colors.transparent,
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'Co-Developer: Reshad',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            "Reshad contributed to API integration.",
                            textAlign: TextAlign.center,
                          ),

                          // Third Developer
                          const SizedBox(height: 20), // extra spacing
                          CircleAvatar(
                            radius: 36,
                            backgroundImage: NetworkImage(
                              "https://avatars.githubusercontent.com/u/161743966?v=4", // Change to their avatar URL
                            ),
                            backgroundColor: Colors.transparent,
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'Co-Developer: Raha',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            "Raha contributed to UI.",
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Close'),
                        ),
                      ],
                    ),
                  );
                },
              ),
              // ListTile(
              //   leading: Icon(Icons.privacy_tip_outlined, color: _isDark ? Colors.white : Colors.black),
              //   title: Text('Privacy Policy', style: TextStyle(color: _isDark ? Colors.white : Colors.black)),
              //   onTap: () {
              //     Navigator.pop(context);
              //     ScaffoldMessenger.of(context).showSnackBar(
              //       const SnackBar(content: Text('Privacy Policy coming soon')),
              //     );
              //   },
              // ),
              ListTile(
                leading: Icon(Icons.privacy_tip_outlined, color: _isDark ? Colors.white : Colors.black),
                title: Text('Privacy Policy', style: TextStyle(color: _isDark ? Colors.white : Colors.black)),
                onTap: () {
                  Navigator.pop(context); // Close the drawer
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Privacy Policy'),
                      content: SingleChildScrollView(
                        child: Text(
                          '''
MAYA AI ("we", "us", "our") is committed to protecting your privacy. This Privacy Policy describes how your personal information is handled in our app.

1. Information We Collect

- MAYA AI does not require you to provide personal information to use its core features. If you sign in, your email and display name may be collected to personalize your experience.
- We may collect anonymous usage data (such as app crashes or feature usage) to improve the app and its performance.

2. How We Use Information

- To provide, maintain, improve, and personalize MAYA AI.
- To understand app usage for better quality.

3. How Your Information Is Shared

- We do NOT sell, trade, or share your personal information except as required by law.

4. AI Assistant Limitations

- MAYA AI is designed for supportive conversations for mental wellness only.
- MAYA AI does NOT provide medical advice, diagnosis, or suggest/prescribe medication.
- All responses are supportive, not a replacement for professional mental health services.

5. Security

- We take reasonable steps to protect your information but cannot guarantee 100% security.

6. Data Retention

- Anonymous data may be retained for analytics and service improvement.
- You may request deletion of your account data at any time.

7. Children's Privacy

- MAYA AI is not for children under 18. We do not knowingly collect data from children.

8. Changes

- We may update this policy from time to time.

9. Contact Us:

Jesan  
Gmail: rahman241-15-628@diu.edu.bd

By using MAYA AI, you agree to this Privacy Policy.
            ''',
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                      actions: [
                        TextButton(
                          child: const Text('Close'),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.help_outline, color: _isDark ? Colors.white : Colors.black),
                title: Text('Help & Support', style: TextStyle(color: _isDark ? Colors.white : Colors.black)),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Help & Support coming soon')),
                  );
                },
              ),




              ListTile(
                leading: Icon(Icons.volunteer_activism, color: _isDark ? Colors.white : Colors.black),
                title: Text('Support/Donate', style: TextStyle(color: _isDark ? Colors.white : Colors.black)),
                onTap: () {
                  Navigator.pop(context);
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Support MAYA AI'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'MAYA AI is a free mental health support app. If you find it helpful and would like to support its development, please consider making a donation.\n\nYour contribution helps us keep MAYA AI free and improve the service for everyone.',
                          ),
                          const SizedBox(height: 16),
                          // Replace with your own payment info below!
                          const Text(
                            'Donate via BKash:',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const Text('Will give number soon'),
                          const SizedBox(height: 8),
                          const Text(
                            'PayPal:',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SelectableText('Will be availble soon'), // make it selectable
                          const SizedBox(height: 8),
                          // Add more options below if needed
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Close'),
                        ),
                      ],
                    ),
                  );
                },
              ),


            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text(
                'Sign Out',
                style: TextStyle(color: Colors.red),
              ),
              onTap: () {
                Navigator.pop(context);
                _handleSignOut();
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
      ),
        body: Container(
          color: _isDark ? const Color(0xFF222B27) : Colors.white,
          child: Column(
            children: [
          Expanded(
            child: ListView. builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                // return MessageBubble(message: _messages[index]);
                return MessageBubble(
                  message: _messages[index],
                  animate: index == _messages.length - 1,
                  showAvatar: index == 0 || _messages[index].isUser != _messages[index - 1].isUser,
                );
              },
            ),
          ),
          if (_isTyping)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Color(0xFF10a37f),
                    child: Text('M', style: TextStyle(color: Colors.white)),
                  ),
                  SizedBox(width: 12),
                  Text(
                    'MAYA is typing...',
                    style: TextStyle(fontStyle: FontStyle. italic),
                  ),
                ],
              ),
            ),
          ChatInput(onSend: _handleSendMessage),
        ],
      ),
        ),

    );
  }
} // ✅ CLASS ENDS HERE - NO CODE AFTER THIS!