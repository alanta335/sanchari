import 'package:flutter/material.dart';
import 'package:news_api_flutter_package/model/article.dart';
import 'package:news_api_flutter_package/model/error.dart';
import 'package:news_api_flutter_package/model/source.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:news_api_flutter_package/news_api_flutter_package.dart';

class News2 extends StatefulWidget {
  var locality;
  News2({required this.locality});

  @override
  _News2State createState() => _News2State(loc: locality);
}

class _News2State extends State<News2> {
  var loc;
  _News2State({required this.loc});
  final NewsAPI _newsAPI = NewsAPI("907069a2ed944b1990928eaa4b57081d");
  @override
  Widget build(BuildContext context) {
    return _buildEverythingTabView();
  }

  Widget _buildTopHeadlinesTabView() {
    return FutureBuilder<List<Article>>(
        future: _newsAPI.getTopHeadlines(country: "in", category: 'general'),
        builder: (BuildContext context, AsyncSnapshot<List<Article>> snapshot) {
          return snapshot.connectionState == ConnectionState.done
              ? snapshot.hasData
                  ? _buildArticleListView(snapshot.data!)
                  : _buildError(snapshot.error as ApiError)
              : _buildProgress();
        });
  }

  Widget _buildEverythingTabView() {
    return FutureBuilder<List<Article>>(
        future: _newsAPI.getEverything(
          query:
              "(covid OR travel OR tourism OR tourist) AND (india OR kerala OR $loc)",
        ),
        builder: (BuildContext context, AsyncSnapshot<List<Article>> snapshot) {
          return snapshot.connectionState == ConnectionState.done
              ? snapshot.hasData
                  ? _buildArticleListView(snapshot.data!)
                  : _buildError(snapshot.error as ApiError)
              : _buildProgress();
        });
  }

  Widget _buildArticleListView(List<Article> articles) {
    return ListView.builder(
      itemCount: articles.length,
      itemBuilder: (context, index) {
        Article article = articles[index];
        String _url = article.url!;
        return ListTile(
            title: Padding(
                padding: const EdgeInsets.only(
                    top: 8, bottom: 8, left: 20, right: 20),
                child: GestureDetector(
                  onTap: () async {
                    await launch(_url);
                  },
                  child: Container(
                      child: Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              article.title!,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600),
                            ),
                            SizedBox(height: 15),
                            Text(
                              article.description!,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontFamily: 'SFProDisplay'),
                              maxLines: 2,
                            ),
                            SizedBox(height: 10),
                            Center(
                              child: Row(
                                children: [
                                  Text(
                                    'Find More',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 10,
                                    ),
                                  ),
                                  Icon(
                                    Icons.arrow_forward_ios_sharp,
                                    size: 10,
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Color.fromRGBO(0, 0, 0, .2),
                              blurRadius: 10.0,
                            )
                          ],
                          borderRadius: BorderRadius.circular(25))),
                )));
      },
    );
  }

  Widget _buildProgress() {
    return Center(child: CircularProgressIndicator());
  }

  Widget _buildError(ApiError error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              error.code ?? "",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 4),
            Text(error.message!, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
