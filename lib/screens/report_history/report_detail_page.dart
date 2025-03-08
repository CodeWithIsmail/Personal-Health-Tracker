import '../../ImportAll.dart';

class ReportDetailScreen extends StatelessWidget {
  final Report report;
  final int reportIndex;

  const ReportDetailScreen({Key? key, required this.report, required this.reportIndex}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Report Details'),
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
                  'Analysis & Summary',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: MarkdownBody(
                  data: report.summary, // Now renders Markdown properly
                  selectable: true, // Enables text selection
                ),
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
