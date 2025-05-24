import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/ask_bloc.dart';
import '../../data/datasource/ask_reponse_datasource.dart';
import '../../data/repositories/ask_repository_impl.dart';
import 'package:beta/core/utils/constants.dart';

class AskScreen extends StatefulWidget {
  const AskScreen({super.key});

  @override
  State<AskScreen> createState() => _AskScreenState();
}

class _AskScreenState extends State<AskScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  late final AskBloc _askBloc;
  final ScrollController _scrollController = ScrollController();
  String? _lastUserMessage;
  late AnimationController _typingAnimationController;
  late Animation<double> _typingAnimation;

  @override
  void initState() {
    super.initState();
    final dataSource = AskDataSource(baseUrlQandA: baseUrlQandA);
    final repository = AskRepositoryImpl(dataSource: dataSource);
    _askBloc = AskBloc(repository);

    _typingAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _typingAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _typingAnimationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    _askBloc.close();
    _typingAnimationController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _sendMessage(String text) {
    if (text.trim().isEmpty) return;
    setState(() {
      _lastUserMessage = text;
    });
    _askBloc.add(FetchAskById(text));
    _controller.clear();
  }

  void _retryLastMessage() {
    if (_lastUserMessage != null) {
      _askBloc.add(FetchAskById(_lastUserMessage!));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _askBloc,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: const Text('Ask Me Anything',
              style: TextStyle(color: Colors.black)),
          centerTitle: true,
          iconTheme: const IconThemeData(color: Colors.black),
        ),
        body: SafeArea(
          child: Column(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.white.withOpacity(0.1),
                      width: 1,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new_rounded,
                          color: Colors.white, size: 22),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    const SizedBox(width: 4),
                    const Icon(
                      Icons.smart_toy_rounded,
                      color: Color(0xFF5ED2C6),
                      size: 24,
                    ),
                    SizedBox(width: 12),
                    Text(
                      'Beta Assistant',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: BlocConsumer<AskBloc, AskState>(
                  listener: (context, state) {
                    if (state is AskLoaded || state is AskError) {
                      _scrollToBottom();
                    }
                  },
                  builder: (context, state) {
                    List<_ChatMessage> messages = [];
                    if (state is AskInitial) {
                      messages.add(_ChatMessage(
                        isBot: true,
                        text:
                            "Hi! 🤖 I'm your AI assistant. Ask me anything—I'm here to help!",
                      ));
                    } else if (state is AskLoaded) {
                      for (final ask in state.asks) {
                        messages.add(
                            _ChatMessage(isBot: false, text: ask.question));
                        messages
                            .add(_ChatMessage(isBot: true, text: ask.answer));
                      }
                    } else if (state is AskError && _lastUserMessage != null) {
                      messages.add(
                          _ChatMessage(isBot: false, text: _lastUserMessage!));
                      messages.add(_ChatMessage(
                        isBot: true,
                        text: state.message,
                        isError: true,
                        onRetry: _retryLastMessage,
                      ));
                    }

                    final isLoading = state is AskLoading;
                    if (isLoading && _lastUserMessage != null) {
                      messages.add(
                          _ChatMessage(isBot: false, text: _lastUserMessage!));
                      messages.add(_ChatMessage(
                        isBot: true,
                        text: 'Typing...',
                        isTyping: true,
                        typingAnimation: _typingAnimation,
                      ));
                    }

                    return Container(
                      color: Colors.transparent,
                      child: ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        itemCount: messages.length,
                        itemBuilder: (context, i) => messages[i],
                      ),
                    );
                  },
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  border: Border(
                    top: BorderSide(
                      color: Colors.blueGrey.withOpacity(0.08),
                      width: 1,
                    ),
                  ),
                ),
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: TextField(
                              controller: _controller,
                              style: const TextStyle(color: Colors.black),
                              decoration: const InputDecoration(
                                hintText: 'Message Beta...',
                                hintStyle: TextStyle(color: Colors.black45),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 16),
                              ),
                              onSubmitted: _sendMessage,
                              minLines: 1,
                              maxLines: 4,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        BlocBuilder<AskBloc, AskState>(
                          builder: (context, state) {
                            final bool isLoading = state is AskLoading;
                            return GestureDetector(
                              onTap: isLoading
                                  ? null
                                  : () => _sendMessage(_controller.text),
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: isLoading
                                      ? Colors.grey
                                      : Colors.blueAccent,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: isLoading
                                    ? const SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                  Colors.blueAccent),
                                        ),
                                      )
                                    : const Icon(Icons.send_rounded,
                                        color: Colors.white, size: 20),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'This AI chatbot does not provide professional medical advice.',
                      style:
                          TextStyle(color: Colors.amber.shade700, fontSize: 11),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ChatMessage extends StatelessWidget {
  final bool isBot;
  final String text;
  final bool isTyping;
  final bool isError;
  final VoidCallback? onRetry;
  final Animation<double>? typingAnimation;

  const _ChatMessage({
    required this.isBot,
    required this.text,
    this.isTyping = false,
    this.isError = false,
    this.onRetry,
    this.typingAnimation,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: isBot ? Colors.blueGrey.withOpacity(0.06) : Colors.transparent,
        border: Border(
          bottom: BorderSide(
            color: Colors.blueGrey.withOpacity(0.08),
            width: 1,
          ),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 30,
            height: 30,
            margin: const EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              color: isBot
                  ? Colors.blueAccent.withOpacity(0.15)
                  : Colors.grey.withOpacity(0.12),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(
              isBot ? Icons.smart_toy_rounded : Icons.person_rounded,
              color: isBot ? Colors.blueAccent : Colors.black54,
              size: 18,
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isBot ? 'Beta' : 'You',
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                if (isTyping && typingAnimation != null)
                  Row(
                    children: [
                      ...List.generate(3, (index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 2),
                          child: AnimatedBuilder(
                            animation: typingAnimation!,
                            builder: (context, child) {
                              return Transform.translate(
                                offset: Offset(0, -4 * typingAnimation!.value),
                                child: Container(
                                  width: 6,
                                  height: 6,
                                  decoration: BoxDecoration(
                                    color: Colors.blueAccent.withOpacity(0.7),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      }),
                    ],
                  )
                else
                  Text(
                    text,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      height: 1.5,
                    ),
                  ),
                if (isError && onRetry != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: TextButton.icon(
                      onPressed: onRetry,
                      icon: const Icon(Icons.refresh,
                          color: Colors.redAccent, size: 16),
                      label: const Text(
                        'Retry',
                        style: TextStyle(color: Colors.redAccent, fontSize: 13),
                      ),
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
