class Prompt{
 static  String similarCheckPrompt(String exist, String notun) {
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
     return prompt;
   }
}