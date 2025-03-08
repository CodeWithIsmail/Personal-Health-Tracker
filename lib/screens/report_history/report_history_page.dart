import '../../ImportAll.dart';

class ReportListScreen extends StatefulWidget {
  String? targetName;

  ReportListScreen(this.targetName);

  @override
  State<ReportListScreen> createState() => _ReportListScreenState();
}

class _ReportListScreenState extends State<ReportListScreen> {
  String username = "";

  // final AuthenticationProvider authProvider = AuthenticationProvider();
  @override
  void initState() {
    super.initState();
    // username = widget.targetName ?? authProvider.currentUserName ?? "";
    String username = "";

    setState(() {
      username = widget.targetName ??
          FirebaseAuth.instance.currentUser!.email!.split('@')[0];
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // final authProvider =
      // Provider.of<AuthenticationProvider>(context, listen: false);
      // username = authProvider.currentUserName ?? "";
      Provider.of<ReportProvider>(context, listen: false)
          .fetchReports(username);
    });

    //
    // if (widget.targetName != null) {
    //    username = widget.targetName??"";
    // } else {
    //   WidgetsBinding.instance.addPostFrameCallback((_) {
    //     final authProvider =
    //         Provider.of<AuthenticationProvider>(context, listen: false);
    //      username = authProvider.currentUserName ?? "";
    //     Provider.of<ReportProvider>(context, listen: false)
    //         .fetchReports(username);
    //   });
    // }

    print("target user get: " + username);
  }

  @override
  Widget build(BuildContext context) {
    final reportProvider = Provider.of<ReportProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Report History"),
        centerTitle: true,
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
                    // final authProvider = Provider.of<AuthenticationProvider>(
                    //     context,
                    //     listen: false);
                    // final username = authProvider.currentUserName ?? "";
                    // setState(() {
                    //   username=widget.targetName??FirebaseAuth.instance.currentUser!.email!.split('@')[0];
                    // });
                    setState(() {
                      username = widget.targetName ??
                          FirebaseAuth.instance.currentUser!.email!
                              .split('@')[0];
                    });

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
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => ReportDetailScreen(
                                  report: report,
                                  reportIndex: index + 1,
                                ),
                              ),
                            );
                          },
                          child: CustomHistoryContainerWidget(report: report),
                        ),
                      );
                    },
                  ),
                ),
    );
  }

  void _onDateOptionChanged(String option) {
    // final authProvider =
    //     Provider.of<AuthenticationProvider>(context, listen: false);
    // final username = authProvider.currentUserName ?? "";
    setState(() {
      username = widget.targetName ??
          FirebaseAuth.instance.currentUser!.email!.split('@')[0];
    });

    final reportProvider = Provider.of<ReportProvider>(context, listen: false);

    final now = DateTime.now();
    DateTime startDate;

    switch (option) {
      case "All":
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
        reportProvider.fetchReports(username);
        return;
    }

    reportProvider.filterReportsByDateRange(username, startDate, now);
  }

  Future<void> _selectCustomDateRange(BuildContext context) async {
    final pickedRange = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return CustomDateRangeWidget(context, child!);
      },
    );
    if (pickedRange != null) {
      // final authProvider =
      // Provider.of<AuthenticationProvider>(context, listen: false);
      // final username = authProvider.currentUserName ?? "";

      setState(() {
        username = widget.targetName ??
            FirebaseAuth.instance.currentUser!.email!.split('@')[0];
      });

      Provider.of<ReportProvider>(context, listen: false)
          .filterReportsByDateRange(
              username, pickedRange.start, pickedRange.end);
    }
  }
}
