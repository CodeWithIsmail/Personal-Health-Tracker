import '../ImportAll.dart';

Future<String> sendImagePromptToGemini(
    String prompt, File selectedMedia, ChatSession? chat) async {
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

Future<String> sendChatMessage(String message, ChatSession chat) async {
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

Future<String> similar(String exist, String notun) async {
  String prompt = '''
Here are two comma-separated string:

    Predefined Test Names: $exist
    User Input Test Names: $notun

Your task is to:

    Map each user-input test name to the most relevant predefined test name based on similarity and context.
    If a user-input test name cannot be matched to any predefined test name, map it to itself.

Output Format:
[User Input Test Name] : [Mapped Predefined Test Name]

Example:
ESR (Westergren method) : ESR
CBC (Complete Blood Count) : CBC (Complete Blood Count)

Provide the mappings for all user-input test names in the specified format. dont give any additional text.

''';

  String? text = "0";
  try {
    final response = await GeminiModel.startChat().sendMessage(
      Content.text(prompt),
    );
    text = response.text;

    if (text == null) {
      text = "0";
    }
  } catch (e) {
    text = "0";
    print(e);
  }
  return text;
}
