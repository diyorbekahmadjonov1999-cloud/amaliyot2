import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const Color _teal = Color(0xFF009577);
const Color _ink = Color(0xFF1B2B28);
const Color _muted = Color(0xFF8A9A97);
const Color _botBlue = Color(0xFF3B6FE0);
const Color _botBlueBg = Color(0xFFD6E4FF);
const Color _online = Color(0xFF00B67A);

class _Msg {
  final String text;
  final bool fromUser;
  const _Msg(this.text, this.fromUser);
}

class AssistantPage extends StatefulWidget {
  /// Pastki navigatsiya balandligi: yozish paneli uning ostida qolmasligi uchun
  final double bottomPadding;

  const AssistantPage({super.key, this.bottomPadding = 0});

  @override
  State<AssistantPage> createState() => _AssistantPageState();
}

class _AssistantPageState extends State<AssistantPage> {
  final _ctrl = TextEditingController();
  final _scroll = ScrollController();

  final List<_Msg> _messages = [
    const _Msg(
      'Good to see you! I am your House Engine AI assistant. '
          'Which type of assistance would you like to take?',
      false,
    ),
  ];
  bool _typing = false;

  bool get _hasText => _ctrl.text.trim().isNotEmpty;

  @override
  void dispose() {
    _ctrl.dispose();
    _scroll.dispose();
    super.dispose();
  }

  void _scrollToEnd() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scroll.hasClients) return;
      _scroll.animateTo(
        _scroll.position.maxScrollExtent,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    });
  }

  void _send() {
    final text = _ctrl.text.trim();
    if (text.isEmpty || _typing) return;

    setState(() {
      _messages.add(_Msg(text, true));
      _ctrl.clear();
      _typing = true;
    });
    _scrollToEnd();

    // TODO: haqiqiy AI/backend javobi shu yerda keladi
    Future.delayed(const Duration(milliseconds: 900), () {
      if (!mounted) return;
      setState(() {
        _messages.add(const _Msg(
          'Thanks for your message! I am still being set up, '
              'real answers will be available soon.',
          false,
        ));
        _typing = false;
      });
      _scrollToEnd();
    });
  }

  void _comingSoon(String what) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$what will be added later')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final itemCount = _messages.length + (_typing ? 1 : 0);

    return Material(
      color: Colors.white,
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: const BoxDecoration(
                      color: _botBlueBg,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.smart_toy_outlined,
                        size: 22, color: _botBlue),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'AI Assistant',
                        style: GoogleFonts.montserrat(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: _ink,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Container(
                            width: 7,
                            height: 7,
                            decoration: const BoxDecoration(
                              color: _online,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 5),
                          Text(
                            'Online',
                            style: GoogleFonts.montserrat(
                              fontSize: 11,
                              color: _online,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Divider(height: 1, color: Colors.grey.withValues(alpha: 0.25)),

            // Xabarlar
            Expanded(
              child: ListView.builder(
                controller: _scroll,
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                itemCount: itemCount,
                itemBuilder: (context, i) {
                  if (i == _messages.length) {
                    return const _Bubble(text: 'Typing...', fromUser: false);
                  }
                  final m = _messages[i];
                  return _Bubble(text: m.text, fromUser: m.fromUser);
                },
              ),
            ),

            // Yozish paneli
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                  top: BorderSide(color: Colors.grey.withValues(alpha: 0.25)),
                ),
              ),
              padding: EdgeInsets.fromLTRB(12, 10, 12, 10 + widget.bottomPadding),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => _comingSoon('Attaching files'),
                    child: const Icon(Icons.attach_file_rounded,
                        size: 22, color: _muted),
                  ),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: () => _comingSoon('Sending images'),
                    child: const Icon(Icons.image_outlined,
                        size: 22, color: _muted),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: _ctrl,
                      cursorColor: _teal,
                      minLines: 1,
                      maxLines: 4,
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => _send(),
                      onChanged: (_) => setState(() {}),
                      style: GoogleFonts.montserrat(fontSize: 12, color: _ink),
                      decoration: InputDecoration(
                        isDense: true,
                        hintText: 'Ask me anything...',
                        hintStyle:
                        GoogleFonts.montserrat(fontSize: 12, color: _muted),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 11),
                        suffixIcon: GestureDetector(
                          onTap: () => _comingSoon('Voice input'),
                          child: const Icon(Icons.mic_none_rounded,
                              size: 20, color: _muted),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(
                              color: Colors.grey.withValues(alpha: 0.4)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: const BorderSide(color: _teal),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: _send,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: _hasText ? _teal : const Color(0xFFEEF1F6),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.send_rounded,
                        size: 18,
                        color: _hasText ? Colors.white : _muted,
                      ),
                    ),
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

// ---------------------------------------------------------------------------
// Xabar pufagi
// ---------------------------------------------------------------------------
class _Bubble extends StatelessWidget {
  final String text;
  final bool fromUser;

  const _Bubble({required this.text, required this.fromUser});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: fromUser ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        child: Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: fromUser ? _teal : Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: fromUser
                ? null
                : Border.all(color: Colors.grey.withValues(alpha: 0.3)),
          ),
          child: Text(
            text,
            style: GoogleFonts.montserrat(
              fontSize: 12.5,
              height: 1.4,
              color: fromUser ? Colors.white : _ink,
            ),
          ),
        ),
      ),
    );
  }
}