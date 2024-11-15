import '../ImportAll.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  FirestoreService firestoreService = new FirestoreService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: firestoreService.getEntry("123"),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('An error occurred!'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData) {
            return Center(child: Text('No records found.'));
          }
          List entryList = snapshot.data!.docs;
          print(entryList);
          return Padding(
            padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
            child: ListView.builder(
              itemCount: entryList.length,
              itemBuilder: (BuildContext context, int index) {
                DocumentSnapshot documentSnapshot = entryList[index];
                Map<String, dynamic> data =
                    documentSnapshot.data() as Map<String, dynamic>;

                String user_id = data['user_id'];
                String report_id = data['report_id'];
                String imgLink = data['image_link'];

                print(user_id + " " + report_id + " " + imgLink);

                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.network(
                      imgLink,
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.width,
                    ),
                  ],
                );
              },
            ),
          );
        },
      ),
    );
  }
}
