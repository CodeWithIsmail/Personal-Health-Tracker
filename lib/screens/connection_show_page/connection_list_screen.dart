import '../../ImportAll.dart';

class ConnectionPage extends StatefulWidget {
  @override
  _ConnectionPageState createState() => _ConnectionPageState();
}

class _ConnectionPageState extends State<ConnectionPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _connectionController = TextEditingController();

  Future<void> _deleteConnection(
      String currentUserName, String connectionName) async {
    try {
      DocumentReference docRef =
      _firestore.collection("connection").doc(currentUserName);
      await docRef.update({
        "connections": FieldValue.arrayRemove([connectionName])
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("$connectionName removed successfully")),
      );

      setState(() {}); // Refresh UI after deletion
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error removing $connectionName")),
      );
    }
  }

  Future<void> _addConnection(String currentUserName) async {
    String newConnection = _connectionController.text.trim();

    if (newConnection.isEmpty) return;

    try {
      DocumentReference docRef =
      _firestore.collection("connection").doc(currentUserName);

      // Check if the document exists
      DocumentSnapshot docSnapshot = await docRef.get();

      if (!docSnapshot.exists) {
        // Create the document if it doesn't exist
        await docRef.set({
          "connections": [],
        });
      }

      // Now update the array
      await docRef.update({
        "connections": FieldValue.arrayUnion([newConnection])
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("$newConnection added successfully")),
      );

      _connectionController.clear();
      setState(() {}); // Refresh UI after addition
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error adding connection")),
      );
    }
  }

  void _showAddConnectionDialog(String currentUserName) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Add Connection"),
          content: TextField(
            controller: _connectionController,
            decoration: InputDecoration(hintText: "Enter username"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog
                _connectionController.clear();
              },
              child: Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog
                _addConnection(currentUserName);
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
        appBar: AppBar(title: Text("My Connections")),
        body: Center(child: Text("No user logged in")),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("My Connections"),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => _showAddConnectionDialog(currentUserName),
          ),
        ],
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: _firestore
            .collection("connection")
            .doc(currentUserName)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data?.data() == null) {
            return Center(child: Text("No connections found"));
          }

          var data = snapshot.data!.data() as Map<String, dynamic>;
          List<String> connections =
          List<String>.from(data["connections"] ?? []);

          if (connections.isEmpty) {
            return Center(child: Text("No connections found"));
          }

          return ListView.builder(
            itemCount: connections.length,
            itemBuilder: (context, index) {
              String connectionName = connections[index];

              return Card(
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                elevation: 4,
                child: ListTile(
                  contentPadding: EdgeInsets.all(12),
                  title: Text(connectionName,
                      style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () =>
                        _deleteConnection(currentUserName, connectionName),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
