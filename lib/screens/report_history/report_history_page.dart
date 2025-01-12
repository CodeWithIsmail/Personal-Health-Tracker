import '../../ImportAll.dart';

class ReportListScreen extends StatefulWidget {
  const ReportListScreen({Key? key}) : super(key: key);

  @override
  State<ReportListScreen> createState() => _ReportListScreenState();
}

class _ReportListScreenState extends State<ReportListScreen> {
  final List<String> dateOptions = [
    "All", // Added the "All" option
    "Last Week",
    "Last 15 Days",
    "Last Month",
    "Last Year",
    "Custom"
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider =
          Provider.of<AuthenticationProvider>(context, listen: false);
      final username = authProvider.currentUserName ?? "";

      // Initially fetch all reports
      Provider.of<ReportProvider>(context, listen: false)
          .fetchReports(username);
    });
  }

  void _onDateOptionChanged(String option) {
    final authProvider =
        Provider.of<AuthenticationProvider>(context, listen: false);
    final username = authProvider.currentUserName ?? "";
    final reportProvider = Provider.of<ReportProvider>(context, listen: false);

    final now = DateTime.now();
    DateTime startDate;

    switch (option) {
      case "All":
        // Fetch all reports if "All" is selected
        reportProvider.fetchReports(username);
        return;
      case "Last Week":
        startDate = now.subtract(const Duration(days: 7));
        break;
      case "Last 15 Days":
        startDate = now.subtract(const Duration(days: 15));
        break;
      case "Last Month":
        startDate = now.subtract(const Duration(days: 30));
        break;
      case "Last Year":
        startDate = now.subtract(const Duration(days: 365));
        break;
      case "Custom":
        _selectCustomDateRange(context);
        return;
      default:
        return;
    }

    reportProvider.filterReportsByDateRange(username, startDate, now);
  }

  @override
  Widget build(BuildContext context) {
    final reportProvider = Provider.of<ReportProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Reports"),
        actions: [
          DropdownButton<String>(
            value: reportProvider.selectedDateOption,
            items: dateOptions
                .map((option) =>
                    DropdownMenuItem(value: option, child: Text(option)))
                .toList(),
            onChanged: (value) {
              if (value != null) {
                reportProvider.setSelectedDateOption(value);
                _onDateOptionChanged(value);
              }
            },
          ),
        ],
      ),
      body: reportProvider.isLoading
          ? const Center(child: defaultSpinKitDoubleBounce)
          : reportProvider.reports.isEmpty
              ? const Center(
                  child: Text(
                    "No reports found.",
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                )
              : RefreshIndicator(
                  onRefresh: () async {
                    final authProvider = Provider.of<AuthenticationProvider>(
                        context,
                        listen: false);
                    final username = authProvider.currentUserName ?? "";
                    await reportProvider.fetchReports(username);
                  },
                  child: ListView.builder(
                    itemCount: reportProvider.reports.length,
                    itemBuilder: (context, index) {
                      final report = reportProvider.reports[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 16),
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(16),
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  ReportDetailScreen(report: report),
                            ));
                          },
                          child: Container(
                            height: MediaQuery.of(context).size.height / 4,
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(12)),
                                  child: Image.network(
                                    report.image,
                                    width:
                                        MediaQuery.of(context).size.width / 3,
                                    height: double.infinity,
                                    fit: BoxFit.cover,
                                    loadingBuilder: (context, child, progress) {
                                      if (progress == null) return child;
                                      return const Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    },
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            const Icon(Icons.error,
                                                color: Colors.red),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          formatDate(report.date),
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                            color: Colors.black87,
                                          ),
                                        ),
                                        Text(
                                          report.summary,
                                          maxLines: 5,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.black54,
                                          ),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'View More',
                                              style: TextStyle(
                                                color: Colors.blue.shade700,
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const Icon(Icons.arrow_forward_ios,
                                                size: 16, color: Colors.grey),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
    );
  }

  Future<void> _selectCustomDateRange(BuildContext context) async {
    final pickedRange = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return SafeArea(
          child: Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.light(
                primary: Colors.blue, // Header background color
                onPrimary: Colors.white, // Header text color
                onSurface: Colors.black, // Body text color
              ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  foregroundColor: Colors.blue, // Button text color
                ),
              ),
            ),
            child: child!,
          ),
        );
      },
    );

    // Ensure pickedRange is not null before using it
    if (pickedRange != null) {
      final authProvider =
          Provider.of<AuthenticationProvider>(context, listen: false);
      final username = authProvider.currentUserName ?? "";

      Provider.of<ReportProvider>(context, listen: false)
          .filterReportsByDateRange(
              username, pickedRange.start, pickedRange.end);
    }
  }
}
