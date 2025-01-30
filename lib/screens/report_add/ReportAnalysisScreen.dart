import '../../ImportAll.dart';

class ReportAnalysis extends StatefulWidget {
  File selectedMedia;
  String imageLink;

  ReportAnalysis(this.selectedMedia, this.imageLink);

  @override
  State<ReportAnalysis> createState() => _ReportAnalysisState();
}

class _ReportAnalysisState extends State<ReportAnalysis> {
  bool done = false;
  FirestoreService firestoreService = new FirestoreService();
  GeminiService geminiService = new GeminiService();
  late final ChatSession _chat;
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _textController = TextEditingController();
  final FocusNode _textFieldFocus = FocusNode();
  final List<({Image? image, String? text, bool fromUser})> _generatedContent =
      <({Image? image, String? text, bool fromUser})>[];
  bool _loading = false;
  String uname = "";

  void initState() {
    super.initState();
    String? email = FirebaseAuth.instance.currentUser?.email;
    uname = email!.substring(0, email.indexOf('@'));
    _chat = GeminiModel.startChat();
    _sendImagePrompt(Prompt.analyzeReportPrompt());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: GeminiApiKey.isNotEmpty
                  ? ListView.builder(
                      controller: _scrollController,
                      itemBuilder: (context, idx) {
                        final content = _generatedContent[idx];
                        return MessageWidget(
                          text: content.text,
                          image: content.image,
                          isFromUser: content.fromUser,
                        );
                      },
                      itemCount: _generatedContent.length,
                    )
                  : ListView(
                      children: const [
                        Text(
                          'No API key found. Please provide an API Key using '
                          "'--dart-define' to set the 'API_KEY' declaration.",
                        ),
                      ],
                    ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 25,
                horizontal: 15,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      autofocus: true,
                      focusNode: _textFieldFocus,
                      decoration: promptTextFieldDecoration,
                      controller: _textController,
                      onSubmitted: _sendChatMessage,
                    ),
                  ),
                  const SizedBox.square(dimension: 5),
                  IconButton(
                    onPressed: () async {
                      _sendChatMessage(_textController.text);
                    },
                    icon: Icon(
                      Icons.send,
                      color: Color(0xFF355C7D),
                    ),
                  ),
                  const SizedBox.square(dimension: 5),
                  Text(
                    "Or ",
                    style: TextStyle(color: Color(0xFF355C7D)),
                  ),
                  const SizedBox.square(dimension: 5),
                  if (!_loading)
                    CustomButtonGestureDetector(
                      'Analyze Report',
                      MediaQuery.of(context).size.width / 4,
                      MediaQuery.of(context).size.width / 6,
                      Color(0xFF355C7D),
                      Colors.white,
                      15,
                      !_loading
                          ? () async {
                              _sendImagePrompt(Prompt.analyzeReportPrompt());
                            }
                          : null,
                    )
                  else
                    const CircularProgressIndicator(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _sendImagePrompt(String prompt) async {
    setState(() {
      _loading = true;
    });
    try {
      _generatedContent.add((
        image: Image.file(widget.selectedMedia),
        text: "Analyze report",
        fromUser: true
      ));
      String text =
          await geminiService.sendImagePromptToGemini(prompt, widget.selectedMedia, _chat);

      _generatedContent.add((image: null, text: text, fromUser: false));

      if (text == "something wrong!") {
        _showError('No response from API.');
        return;
      } else {
        setState(() {
          _loading = false;

          if (!done) {
            done = true;
            // final reportProvider = Provider.of<ReportProvider>(context);
            // reportProvider.addReport(Report(
            //     username: uname,
            //     viewer: [],
            //     date: DateTime.now(),
            //     image: widget.imageLink,
            //     summary: text));
            firestoreService.storeSummeryImgLink(uname, widget.imageLink, text);
          }
          _scrollDown();
        });
      }
    } catch (e) {
      _showError(e.toString());
      setState(() {
        _loading = false;
      });
    } finally {
      _textController.clear();
      setState(() {
        _loading = false;
      });
      _textFieldFocus.requestFocus();
    }
  }

  Future<void> _sendChatMessage(String prompt) async {
    setState(() {
      _loading = true;
    });

    try {
      _generatedContent.add((image: null, text: prompt, fromUser: true));

      String text = await geminiService.sendChatMessage(prompt, _chat);

      _generatedContent.add((image: null, text: text, fromUser: false));

      if (text == "something wrong!") {
        _showError('No response from API.');
        return;
      } else {
        setState(() {
          _loading = false;
          _scrollDown();
        });
      }
    } catch (e) {
      _showError(e.toString());
      setState(() {
        _loading = false;
      });
    } finally {
      _textController.clear();
      setState(() {
        _loading = false;
      });
      _textFieldFocus.requestFocus();
    }
  }

  void _scrollDown() {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(
          milliseconds: 750,
        ),
        curve: Curves.easeOutCirc,
      ),
    );
  }

  void _showError(String message) {
    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Something went wrong'),
          content: SingleChildScrollView(
            child: SelectableText(message),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            )
          ],
        );
      },
    );
  }
}
