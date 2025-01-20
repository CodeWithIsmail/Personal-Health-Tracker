import '../../ImportAll.dart';

class HistoryVisualization extends StatefulWidget {
  @override
  _HistoryVisualizationState createState() => _HistoryVisualizationState();
}

class _HistoryVisualizationState extends State<HistoryVisualization> {
  String? _selectedDateRange = 'All';
  DateTimeRange? _selectedDateRangeCustom;
  String? _selectedTestName;
  late String username;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider =
          Provider.of<AuthenticationProvider>(context, listen: false);
      username = authProvider.currentUserName ?? "";
      Provider.of<TestNamesProvider>(context, listen: false).fetchTestNames();
    });
  }

  @override
  Widget build(BuildContext context) {
    final reportAttributeProvider =
        Provider.of<ReportAttributeProvider>(context);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTestNameDropdown(),
              SizedBox(height: 20),
              _buildDateRangeDropdown(),
              if (_selectedDateRange == 'Custom' &&
                  _selectedDateRangeCustom != null)
                _buildSelectedDateRangeInfo(),
              SizedBox(height: 20),
              _buildVisualizeButton(context),
              SizedBox(height: 20),
              if (reportAttributeProvider.isLoading)
                Center(child: defaultSpinKitWave),
              if (reportAttributeProvider.chartData.isNotEmpty &&
                  !reportAttributeProvider.isLoading)
                _buildChart(reportAttributeProvider.chartData),
              if (reportAttributeProvider.chartData.isEmpty &&
                  !reportAttributeProvider.isLoading)
                Center(
                  child: Text("No Record found within the date range"),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTestNameDropdown() {
    return Consumer<TestNamesProvider>(
      builder: (context, provider, child) {
        if (provider.testNames.isEmpty) {
          return Center(child: CircularProgressIndicator());
        }
        return DropdownButtonFormField<String>(
          decoration: visualizationDropdownDecoration,
          items: provider.testNames.map((String testName) {
            return DropdownMenuItem<String>(
              value: testName,
              child: Text(testName),
            );
          }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              _selectedTestName = newValue;
            });
          },
          hint: Text('Select Test Name'),
          icon: Icon(Icons.arrow_drop_down, color: Colors.teal),
        );
      },
    );
  }

  Widget _buildDateRangeDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedDateRange,
      decoration: visualizationDropdownDecoration,
      items: dateOptions.map((String dateRange) {
        return DropdownMenuItem<String>(
          value: dateRange,
          child: Text(dateRange),
        );
      }).toList(),
      onChanged: (String? newValue) {
        setState(() {
          _selectedDateRange = newValue;
          if (_selectedDateRange == 'Custom') {
            _openDateRangePicker();
          }
        });
      },
      hint: Text('Select Date Range'),
      icon: Icon(Icons.arrow_drop_down, color: Colors.teal),
    );
  }

  Widget _buildSelectedDateRangeInfo() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        'Selected Range: ${formatDate(_selectedDateRangeCustom!.start)} to ${formatDate(_selectedDateRangeCustom!.end)}',
        style: TextStyle(fontSize: 16, color: Colors.teal),
      ),
    );
  }

  Widget _buildVisualizeButton(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.teal,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: EdgeInsets.symmetric(vertical: 16.0),
          elevation: 5,
        ),
        onPressed: () async {
          if (_selectedTestName != null && _selectedDateRange != null) {
            await context.read<ReportAttributeProvider>().fetchReportData(
                  username: username,
                  testName: _selectedTestName!,
                  dateRange: _selectedDateRange!,
                  startDate: _selectedDateRangeCustom?.start,
                  endDate: _selectedDateRangeCustom?.end,
                );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Please select a test and date range')),
            );
          }
        },
        child: Text(
          'Visualize',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildChart(List<ChartDataTimewise> chartData) {
    return Column(
      children: [
        CustomColumnChart(
            "${_selectedTestName ?? ""} Column Chart", username, chartData),
        SizedBox(height: 20),
        CustomLineChart(
            "${_selectedTestName ?? ""} Line Chart", username, chartData),
      ],
    );
  }

  Future<void> _openDateRangePicker() async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _selectedDateRangeCustom = picked;
      });
    }
  }
}
