import '../../ImportAll.dart';

class ConnectionPage extends StatefulWidget {
  @override
  _ConnectionPageState createState() => _ConnectionPageState();
}

class _ConnectionPageState extends State<ConnectionPage>
    with SingleTickerProviderStateMixin {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _viewerController = TextEditingController();
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  Future<void> _deleteViewer(String currentUserName, String viewerName) async {
    try {
      // Remove viewer from "viewers" array (they can't view me anymore)
      DocumentReference userDocRef =
          _firestore.collection("connection").doc(currentUserName);
      await userDocRef.update({
        "viewers": FieldValue.arrayRemove([viewerName])
      });

      // Remove myself from their "connections" array (I disappear from their view)
      DocumentReference viewerDocRef =
          _firestore.collection("connection").doc(viewerName);
      await viewerDocRef.update({
        "connections": FieldValue.arrayRemove([currentUserName])
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("$viewerName removed successfully")),
      );

      setState(() {}); // Refresh UI after deletion
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error removing $viewerName")),
      );
    }
  }

  Future<void> _addViewer(String currentUserName) async {
    String newViewer = _viewerController.text.trim();

    if (newViewer.isEmpty || newViewer == currentUserName) return;

    try {
      DocumentReference userDocRef =
          _firestore.collection("connection").doc(currentUserName);
      DocumentReference viewerDocRef =
          _firestore.collection("connection").doc(newViewer);

      // Ensure current user's document exists & update "viewers"
      await userDocRef.set({
        "viewers": FieldValue.arrayUnion([newViewer])
      }, SetOptions(merge: true));

      // Ensure the new viewer's document exists & update their "connections"
      await viewerDocRef.set({
        "connections": FieldValue.arrayUnion([currentUserName])
      }, SetOptions(merge: true));

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("$newViewer added successfully")),
      );

      _viewerController.clear();
      setState(() {}); // Refresh UI after addition
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error adding viewer")),
      );
    }
  }

  void _showAddViewerDialog(String currentUserName) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Add Viewer"),
          content: TextField(
            controller: _viewerController,
            decoration: InputDecoration(hintText: "Enter username"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog
                _viewerController.clear();
              },
              child: Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog
                _addViewer(currentUserName);
              },
              child: Text("Save"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider =
        Provider.of<AuthenticationProvider>(context, listen: false);
    final currentUserName = authProvider.currentUserName;

    if (currentUserName == null) {
      return Scaffold(
        appBar: AppBar(title: Text("Connections")),
        body: Center(child: Text("No user logged in")),
      );
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Connections"),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: "My Access"), // Who I can view (connections)
            Tab(text: "My Viewers"), // Who can view me (viewers)
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.person_add),
            onPressed: () => _showAddViewerDialog(currentUserName),
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildList("connections", currentUserName, false),
          _buildList("viewers", currentUserName, true),
        ],
      ),
    );
  }

  Widget _buildList(String field, String currentUserName, bool isViewersList) {
    return StreamBuilder<DocumentSnapshot>(
      stream:
          _firestore.collection("connection").doc(currentUserName).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data?.data() == null) {
          return Center(child: Text("No data found"));
        }

        var data = snapshot.data!.data() as Map<String, dynamic>;
        List<String> list = List<String>.from(data[field] ?? []);

        if (list.isEmpty) {
          return Center(child: Text("No users found"));
        }

        return ListView.builder(
          itemCount: list.length,
          itemBuilder: (context, index) {
            String name = list[index];

            return Card(
              margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              elevation: 4,
              child: ListTile(
                contentPadding: EdgeInsets.all(12),
                title: Text(name,
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                trailing: isViewersList
                    ? IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _deleteViewer(currentUserName, name),
                      )
                    : null,
              ),
            );
          },
        );
      },
    );
  }
}
