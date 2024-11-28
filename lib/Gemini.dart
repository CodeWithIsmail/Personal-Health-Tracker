import 'package:flutter/services.dart';
import 'ImportAll.dart';

class ChatScreen extends StatefulWidget {
  ChatScreen();

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ChatWidget(),
    );
  }
}

class ChatWidget extends StatefulWidget {
  ChatWidget();

  @override
  State<ChatWidget> createState() => _ChatWidgetState();
}

class _ChatWidgetState extends State<ChatWidget> {
  File? selectedMedia;
  final ImagePicker _picker = ImagePicker();
  late final ChatSession _chat;
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _textController = TextEditingController();
  final FocusNode _textFieldFocus = FocusNode();
  final List<({Image? image, String? text, bool fromUser})> _generatedContent =
      <({Image? image, String? text, bool fromUser})>[];
  bool _loading = false;

  Future<File?> _cropImage(File imageFile) async {
    try {
      CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: imageFile.path,
      );
      return croppedFile != null ? File(croppedFile.path) : null;
    } catch (e) {
      print("Error cropping image: $e");
    }
    return null;
  }

  Future<void> _getImage(ImageSource source) async {
    try {
      final pickedFile = await _picker.pickImage(source: source);
      if (pickedFile != null) {
        File? croppedFile = await _cropImage(File(pickedFile.path));
        if (croppedFile != null) {
          setState(() {
            selectedMedia = croppedFile;
          });
          //   await _uploadImage(croppedFile);
          //  await _processImage(croppedFile);
        }
      } else {
        print("No image selected.");
      }
    } catch (e) {
      print("Error picking image: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    _chat = GeminiModel.startChat();
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

  @override
  Widget build(BuildContext context) {
    return Padding(
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
                            String prompt =
                                'Analyze the following medical report and provide a summary of the key findings. Are there any abnormal test results that require further investigation? Are there any specific instructions for the patient to follow?';
                            await _getImage(ImageSource.gallery);
                            _sendImagePrompt(prompt);
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
    );
  }

  Future<void> _sendImagePrompt(String prompt) async {
    setState(() {
      _loading = true;
    });
    try {
      _generatedContent.add(
          (image: Image.file(selectedMedia!), text: "Analyze report", fromUser: true));
      String text = await sendImagePromptToGemini(prompt, selectedMedia!,_chat);

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

  Future<void> _sendChatMessage(String prompt) async {
    setState(() {
      _loading = true;
    });

    try {
      _generatedContent.add((image: null, text: prompt, fromUser: true));

      String text = await sendChatMessage(prompt, _chat);

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

// class MessageWidget extends StatelessWidget {
//   const MessageWidget({
//     super.key,
//     this.image,
//     this.text,
//     required this.isFromUser,
//   });
//
//   final Image? image;
//   final String? text;
//   final bool isFromUser;
//
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisAlignment:
//           isFromUser ? MainAxisAlignment.end : MainAxisAlignment.start,
//       children: [
//         Flexible(
//             child: Container(
//                 constraints: const BoxConstraints(maxWidth: 500),
//                 decoration: BoxDecoration(
//                   color: isFromUser
//                       ? Theme.of(context).colorScheme.primaryContainer
//                       : Theme.of(context).colorScheme.surfaceContainerHighest,
//                   borderRadius: BorderRadius.circular(18),
//                 ),
//                 padding: const EdgeInsets.symmetric(
//                   vertical: 15,
//                   horizontal: 20,
//                 ),
//                 margin: const EdgeInsets.only(bottom: 8),
//                 child: Column(children: [
//                   if (text case final text?) MarkdownBody(data: text),
//                   if (image case final image?) image,
//                 ]))),
//       ],
//     );
//   }
// }
