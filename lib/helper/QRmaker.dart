import 'dart:typed_data';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:ui' as ui;
import '../ImportAll.dart';

class QRCodeGenerator extends StatefulWidget {
  @override
  _QRCodeGeneratorState createState() => _QRCodeGeneratorState();
}

class _QRCodeGeneratorState extends State<QRCodeGenerator> {
  TextEditingController _controller = TextEditingController();
  String _qrImageUrl = '';

  Future<void> generateAndUploadQRCode() async {
    String text = _controller.text.trim();
    if (text.isEmpty) return;
    Uint8List imageBytes = await _generateImageFromQrCode(text);
    String imageUrl = await uploadImageToCloudinary(imageBytes);
    await saveQRToFirestore(imageUrl);

    setState(() {
      _qrImageUrl = imageUrl;
    });
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
      filename: 'qr_code.png',
    ));

    final response = await request.send();

    if (response.statusCode == 200) {

      final responseData = await response.stream.toBytes();
      final responseString = String.fromCharCodes(responseData);
      final jsonMap = jsonDecode(responseString);

      print(jsonMap);
      print(jsonMap['url']);
      String imgUrl = jsonMap['url'];
      // setState(() {
      //   imageURL = imgUrl;
      // });
      //
      // final responseBody = await response.stream.bytesToString();
      return imgUrl;
    } else {
      throw Exception('Failed to upload image');
    }
  }

  Future<void> saveQRToFirestore(String imageUrl) async {
    try {
      String docId =
          FirebaseFirestore.instance.collection('users').doc("ismail99").id;
      final docRef = FirebaseFirestore.instance.collection('users').doc(docId);
      await docRef.update({
        'qr': imageUrl, // Add new field and its value
      });
      print('Field added successfully!');
    } catch (e) {
      print('Error adding field: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Generate QR Code')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(labelText: 'Enter text for QR Code'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: generateAndUploadQRCode,
              child: Text('Generate QR Code'),
            ),
            SizedBox(height: 20),
            _qrImageUrl.isNotEmpty
                ? Image.network(_qrImageUrl)
                : Container(), // Display uploaded QR code
          ],
        ),
      ),
    );
  }
}
