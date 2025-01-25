import '../ImportAll.dart';
import 'package:http/http.dart' as http;

class CloudinaryService {
  Future<String> uploadImage(File imageFile) async {
    String imgUrl = "";
    final url =
        Uri.parse("https://api.cloudinary.com/v1_1/ismailCloud/image/upload");
    final request = http.MultipartRequest('POST', url)
      ..fields['upload_preset'] = 'healthTracker'
      ..files.add(await http.MultipartFile.fromPath('file', imageFile.path));
    final response = await request.send();
    if (response.statusCode == 200) {
      final responseData = await response.stream.toBytes();
      final responseString = String.fromCharCodes(responseData);
      final jsonMap = jsonDecode(responseString);

      print(jsonMap);
      print(jsonMap['url']);
      imgUrl = jsonMap['url'];
    }
    return imgUrl;
  }
}
