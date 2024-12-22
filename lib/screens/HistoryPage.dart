import '../ImportAll.dart';

class SummaryData {
  String date;
  String imageLink;
  String summary;

  SummaryData(this.date, this.imageLink, this.summary);
}

class HistoryAnalysisScreen extends StatefulWidget {
  const HistoryAnalysisScreen({Key? key}) : super(key: key);

  @override
  _HistoryAnalysisScreenState createState() => _HistoryAnalysisScreenState();
}

class _HistoryAnalysisScreenState extends State<HistoryAnalysisScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<SummaryData> _summaryData = [];
  String uname = "";
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    String? email = FirebaseAuth.instance.currentUser?.email;
    uname = email!.substring(0, email.indexOf('@'));
    _fetchSummaryData();
  }

  Future<void> _fetchSummaryData() async {
    setState(() {
      _isLoading = true;
      _summaryData = [];
    });

    try {
      DocumentSnapshot snapshot =
          await _firestore.collection('report_summery').doc(uname).get();
      if (snapshot.exists) {
        List<dynamic> summaryList = snapshot['summery'];
        print(summaryList);
        List<SummaryData> data = summaryList.map((summaryItem) {
          DateTime dateTime = summaryItem['date'].toDate();
          String formattedDate = DateFormat('dd MMM yyyy').format(dateTime);
          String imageLink = summaryItem['image_link'] ?? '';
          String summary = summaryItem['summery'] ?? '';
          return SummaryData(formattedDate, imageLink, summary);
        }).toList();

        setState(() {
          _summaryData = data;
        });
      } else {
        print('No summary data found for the user.');
      }
    } catch (e) {
      print('Error fetching summary data: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Widget _buildSummaryList() {
    return ListView.builder(
      itemCount: _summaryData.length,
      itemBuilder: (context, index) {
        SummaryData summary = _summaryData[index];
        return Card(
          color: Colors.brown.shade100,
          margin: const EdgeInsets.symmetric(vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          elevation: 5,
          child: ListTile(
            contentPadding: const EdgeInsets.all(10),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  summary.date,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                if (summary.imageLink.isNotEmpty)
                  Image.network(summary.imageLink,
                      height: 100, fit: BoxFit.cover),
                SizedBox(height: 5),
                Text(
                  summary.summary,
                  style: TextStyle(fontSize: 14, color: Colors.black87),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            _isLoading
                ? SpinKitFadingFour(
                    size: 50,
                    color: Colors.deepPurple,
                  )
                : _summaryData.isEmpty
                    ? Text('No data available')
                    : Expanded(
                        child: _buildSummaryList(),
                      ),
          ],
        ),
      ),
    );
  }
}
