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
        stream: firestoreService.getEntry("12"),
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
                String report_id =documentSnapshot.id ;
                String imgLink = data['image_link'];
                String reportSummery = data['report_summery'];

                print(user_id + " " + report_id + " " + imgLink);

                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        gradient: gradientMain,
                        // color: Color(0xFF6C5B7B),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      height: MediaQuery.of(context).size.height / 4,
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Report id: '+report_id),
                              IconButton(
                                onPressed: () {},
                                icon: Icon(Icons.delete),
                              ),
                              IconButton(
                                onPressed: () {},
                                icon: Icon(Icons.share),
                              )
                            ],
                          ),
                          Row(
                            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Image.network(
                                imgLink,
                                width: MediaQuery.of(context).size.width / 3,
                                height: MediaQuery.of(context).size.height / 6,
                              ),
                              Container(
                                // decoration: BoxDecoration(color: Colors.blue
                                // ),
                                width: MediaQuery.of(context).size.width / 2,
                                height: MediaQuery.of(context).size.height / 6,
                                child: Text(
                                  textAlign: TextAlign.start,
                                  reportSummery,
                                  style: TextStyle(color: Colors.white,),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
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
