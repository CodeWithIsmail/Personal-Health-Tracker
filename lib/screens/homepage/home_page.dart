import '../../ImportAll.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final newsProvider = Provider.of<NewsProvider>(context, listen: false);
      newsProvider.fetchHealthNews();
    });
  }

  @override
  Widget build(BuildContext context) {
    final newsProvider = Provider.of<NewsProvider>(context);
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: MediaQuery.of(context).size.height / 4,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                color: Colors.blue.shade100,
              ),
              child: Text(
                "My Latest Health Conditions",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.green.shade900),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(16),
            child: Text(
              'Stay Updated with the Latest Health News',
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Colors.green.shade900),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: newsProvider.isLoading
                ? Center(child: CircularProgressIndicator())
                : newsProvider.articles.isEmpty
                    ? Center(child: Text('No news available'))
                    : ListView.builder(
                        itemCount: newsProvider.articles.length,
                        itemBuilder: (context, index) {
                          final article = newsProvider.articles[index];
                          return Card(
                            margin: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 6),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            elevation: 3,
                            child: InkWell(
                              onTap: () => _showArticleDetail(context, article),
                              child: Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.horizontal(
                                        left: Radius.circular(12)),
                                    child: article['urlToImage'] != null
                                        ? Image.network(article['urlToImage'],
                                            height: 100,
                                            width: 100,
                                            fit: BoxFit.cover)
                                        : Container(
                                            height: 100,
                                            width: 100,
                                            color: Colors.grey.shade300,
                                            child: Icon(Icons.image,
                                                color: Colors.grey.shade700),
                                          ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: EdgeInsets.all(10),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            article['title'] ?? 'No Title',
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          SizedBox(height: 6),
                                          Text(
                                            article['description'] ??
                                                'No Description',
                                            style: TextStyle(
                                                color: Colors.grey.shade600),
                                            maxLines: 3,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }

  void _showArticleDetail(BuildContext context, dynamic article) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            article['urlToImage'] != null
                ? Image.network(article['urlToImage'])
                : Container(
                    height: 200,
                    color: Colors.grey.shade300,
                    child: Icon(Icons.image,
                        color: Colors.grey.shade700, size: 100),
                  ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                article['title'] ?? 'No Title',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Text(
                article['description'] ?? 'No Description',
                style: TextStyle(color: Colors.grey.shade600),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                String url = article['url'] ?? 'https://www.google.com';
                print(url);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WebViewPage(url),
                  ),
                );
              },
              child:
                  Text('View Details', style: TextStyle(color: Colors.green)),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Close', style: TextStyle(color: Colors.green)),
            )
          ],
        ),
      ),
    );
  }
}
