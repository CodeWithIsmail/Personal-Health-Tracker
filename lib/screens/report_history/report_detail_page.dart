import '../../ImportAll.dart';

class ReportDetailScreen extends StatelessWidget {
  final Report report;

  const ReportDetailScreen({Key? key, required this.report}) : super(key: key);

  void _showViewerDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) {
        return Consumer<ReportProvider>(
          builder: (context, reportProvider, child) {
            return AlertDialog(
              title: const Text('Viewer List'),
              content: SizedBox(
                width: double.maxFinite,
                child: ListView.builder(
                  itemCount: report.viewer.length,
                  itemBuilder: (context, index) {
                    final viewer = report.viewer[index];
                    return ListTile(
                      title: Text(viewer),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: const Text('Delete Viewer'),
                              content: Text(
                                  'Are you sure you want to remove $viewer?'),
                              actions: [
                                TextButton(
                                  child: const Text('Cancel'),
                                  onPressed: () => Navigator.of(ctx).pop(),
                                ),
                                TextButton(
                                  child: const Text('Delete'),
                                  onPressed: () {
                                    reportProvider.removeViewer(
                                        report.username, viewer);
                                    Navigator.of(ctx).pop();
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
              actions: [
                TextButton(
                  child: const Text('Close'),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final reportProvider = Provider.of<ReportProvider>(context);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Report Details'),
          actions: [
            IconButton(
              tooltip: 'Delete',
              icon: const Icon(Icons.delete_rounded),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('Delete Report'),
                    content: const Text(
                        'Are you sure you want to delete this report?'),
                    actions: [
                      ElevatedButton(
                        child: const Text('Cancel'),
                        onPressed: () => Navigator.of(ctx).pop(),
                      ),
                      ElevatedButton(
                        child: const Text('Delete'),
                        onPressed: () {
                          Navigator.of(ctx).pop();
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
            IconButton(
              tooltip: 'Privacy',
              icon: const Icon(Icons.privacy_tip),
              onPressed: () => _showViewerDialog(context),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Image.network(
                report.image,
                fit: BoxFit.cover,
                width: double.infinity,
                height: 200,
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'Summary',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Text(report.summary),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  formatDate(report.date),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.black87,
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
