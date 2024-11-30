import '../ImportAll.dart';

Future<String> sendImagePromptToGemini(
    String prompt, File selectedMedia,ChatSession? chat) async {
  try {
    final imageBytes = await selectedMedia.readAsBytes();
    final content = [
      Content.multi([
        TextPart(prompt),
        DataPart('image/jpeg', imageBytes),
      ])
    ];

    var response = await GeminiModel.generateContent(content);
    var text = response.text;

    final sudo_response = await chat?.sendMessage(
      Content.text(text!),
    );
    final sudo_text = response.text;
    print(sudo_text);

    if (text == null) {
      return "something wrong!";
    } else {
      print(text);
      return text;
    }
  } catch (e) {
    print(e);
    return "something wrong!";
  }
}

Future<String> sendChatMessage(String message,ChatSession chat) async {
  try {
    final response = await chat.sendMessage(
      Content.text(message),
    );
    final text = response.text;

    if (text == null) {
      return "something wrong!";
    } else {
      print(text);
      return text;
    }
  } catch (e) {
    print(e);
    return "something wrong!";
  }
}
