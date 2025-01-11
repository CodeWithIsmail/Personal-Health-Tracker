import '../ImportAll.dart';
import 'package:http/http.dart' as http;

class NewsProvider extends ChangeNotifier {
  final String _apiKey = newsApiKey;
  final String _baseUrl = 'https://newsapi.org/v2';
  bool _isLoading = false;
  List<dynamic> _articles = [];

  bool get isLoading => _isLoading;
  List<dynamic> get articles => _articles;

  Future<void> fetchHealthNews() async {
    _isLoading = true;
    notifyListeners();
    final url = Uri.parse('$_baseUrl/top-headlines?category=health&apiKey=$_apiKey');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        _articles = data['articles'];
      } else {
        _articles = [];
      }
    } catch (e) {
      print(e);
      _articles = [];
    }
    _isLoading = false;
    notifyListeners();
  }
}
