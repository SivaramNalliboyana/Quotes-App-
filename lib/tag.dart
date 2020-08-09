import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as parser;

class TagPage extends StatefulWidget {
  final String name;
  TagPage(this.name);
  @override
  _TagPageState createState() => _TagPageState();
}

class _TagPageState extends State<TagPage> {
  bool dataIsthere = false;
  List<String> quotes = List();
  List<String> author = List();
  @override
  void initState() {
    super.initState();
    getdata();
  }

  getdata() async {
    print("getting data");
    var url = 'http://quotes.toscrape.com/tag/${widget.name}/';
    var response = await http.get(url);
    dom.Document document = parser.parse(response.body);
    final mainclass = document.getElementsByClassName('quote');

    setState(() {
      quotes = mainclass
          .map((element) => element.getElementsByClassName('text')[0].innerHtml)
          .toList();
      author = mainclass
          .map((element) =>
              element.getElementsByClassName('author')[0].innerHtml)
          .toList();
      dataIsthere = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SingleChildScrollView(
        physics: ScrollPhysics(),
        child: Column(
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(top: 30.0),
              child: Text(
                "${widget.name} quotes",
                style: GoogleFonts.montserrat(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            dataIsthere == false
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: quotes.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        padding: EdgeInsets.all(10.0),
                        child: Card(
                          elevation: 10.0,
                          child: Column(
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.only(
                                    top: 20.0, left: 20.0, bottom: 20.0),
                                child: Text(
                                  quotes[index],
                                  style: GoogleFonts.montserrat(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(bottom: 10.0),
                                child: Text(
                                  author[index],
                                  style: GoogleFonts.montserrat(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    })
          ],
        ),
      ),
    );
  }
}
