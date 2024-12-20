import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'dart:ui' as ui;
import '../ImportAll.dart';

class QRCodeGenerator {
  String text;

  QRCodeGenerator(this.text);

  Future<String> generateAndUploadQRCode() async {
    Uint8List imageBytes = await _generateImageFromQrCode(this.text);
    String imageUrl = await uploadImageToCloudinary(imageBytes);
    return imageUrl;
  //  await saveQRToFirestore(imageUrl);
  }

  Future<Uint8List> _generateImageFromQrCode(String data) async {
    final qrPainter = QrPainter(
      data: data,
      version: QrVersions.auto,
      color: Colors.black,
      emptyColor: Colors.white,
    );

    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    final Size size = Size(300, 300);
    qrPainter.paint(canvas, size);

    final ui.Image qrImage = await pictureRecorder
        .endRecording()
        .toImage(size.width.toInt(), size.height.toInt());

    ByteData? byteData =
        await qrImage.toByteData(format: ui.ImageByteFormat.png);
    return byteData!.buffer.asUint8List();
  }

  Future<String> uploadImageToCloudinary(Uint8List imageBytes) async {
    final uri =
        Uri.parse("https://api.cloudinary.com/v1_1/ismailCloud/image/upload");

    final request = http.MultipartRequest('POST', uri);
    request.fields['upload_preset'] = 'healthTracker';
    request.files.add(http.MultipartFile.fromBytes(
      'file',
      imageBytes,
      filename: this.text + '_qr_code.png',
    ));

    final response = await request.send();

    if (response.statusCode == 200) {
      final responseData = await response.stream.toBytes();
      final responseString = String.fromCharCodes(responseData);
      final jsonMap = jsonDecode(responseString);
      print(jsonMap);
      print(jsonMap['url']);
      String imgUrl = jsonMap['url'];
      return imgUrl;
    } else {
      throw Exception('Failed to upload image');
    }
  }

  Future<void> saveQRToFirestore(String imageUrl) async {
    try {
      String docId =
          FirebaseFirestore.instance.collection('users').doc(this.text).id;
      final docRef = FirebaseFirestore.instance.collection('users').doc(docId);
      await docRef.update({
        'qr': imageUrl,
      });
      print('Field added successfully!');
    } catch (e) {
      print('Error adding field: $e');
    }
  }
}
