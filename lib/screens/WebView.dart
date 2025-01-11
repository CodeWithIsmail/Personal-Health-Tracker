import '../ImportAll.dart';

class WebViewPage extends StatefulWidget {
  final String url;

  WebViewPage(this.url);

  @override
  _WebViewPageState createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  late WebViewController _controller;
  bool _isLoading = true;
  String uname = "";
  String imgLink = "";

  Future<void> setImageLink() async {
    try {
      DocumentSnapshot docSnapshot =
          await FirebaseFirestore.instance.collection('users').doc(uname).get();

      if (docSnapshot.exists) {
        imgLink = docSnapshot.get('image');
      } else {
        imgLink =
            "https://res.cloudinary.com/ismailcloud/image/upload/v1734184215/defaultProfilePic_vtfdj1.png";
      }
    } catch (e) {
      print("Error fetching image link: $e");
      imgLink =
          "https://res.cloudinary.com/ismailcloud/image/upload/v1734184215/defaultProfilePic_vtfdj1.png"; // Default image in case of error
    }
  }

  @override
  void initState() {
    super.initState();
    _initializeWebViewController();
    String? email = FirebaseAuth.instance.currentUser?.email;
    uname = email!.substring(0, email.indexOf('@'));
    setImageLink();
  }

  void _initializeWebViewController() {
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            debugPrint('Loading progress: $progress%');
          },
          onPageStarted: (String url) {
            setState(() {
              _isLoading = true;
            });
            debugPrint('Page started loading: $url');
          },
          onPageFinished: (String url) {
            setState(() {
              _isLoading = false;
            });
            debugPrint('Page finished loading: $url');
          },
          onWebResourceError: (WebResourceError error) {
            setState(() {
              _isLoading = false;
            });
            debugPrint('Web resource error: ${error.description}');
          },
          onHttpError: (HttpResponseError error) {
            setState(() {
              _isLoading = false;
            });
            debugPrint('HTTP error: ${error.response}');
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'HealthTracker\n$uname',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w400,
          ),
        ),
        // centerTitle: true,
        leading: Padding(
          padding: EdgeInsets.all(5),
          child: ClipOval(
            child: Image.network(
              imgLink,
              fit: BoxFit.cover,
            ),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) => ScanCodePage(),
              //   ),
              // );
              Navigator.pushNamed(context, '/scanCodePage');
            },
            icon: Icon(Icons.qr_code_scanner),
          ),
          IconButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) => LoginOrRegistration(),
              //   ),
              // );
              Navigator.pushNamed(context, '/loginOrRegistration');
            },
            icon: Icon(Icons.logout),
          ),
        ],
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFFA1FFCE),
                Color(0xFFFAFFD1),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}
