import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quran_app/models/surah_model.dart';
import 'package:quran_app/screens/surah_details.dart';
import 'package:quran_app/widgets/bottom_nav_bar.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class SurahPage extends StatefulWidget {
  const SurahPage({super.key});

  @override
  _SurahPageState createState() => _SurahPageState();
}

class _SurahPageState extends State<SurahPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late Future<List<Surah>> surahs;

  String selectedSurahName = 'Al-Fatihah';
  String selectedSurahNumber = 'Ayat No: 1';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    surahs = fetchSurahs();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<List<Surah>> fetchSurahs() async {
    final response =
        await http.get(Uri.parse('https://api.alquran.cloud/v1/surah'));
    if (response.statusCode == 200) {
      if (response.headers['content-type']?.contains('application/json') ==
          true) {
        final List<dynamic> data = json.decode(response.body)['data'];
        return data.map((json) => Surah.fromJson(json)).toList();
      } else {
        throw Exception('Response is not JSON');
      }
    } else {
      throw Exception('Failed to load surahs: ${response.reasonPhrase}');
    }
  }

  @override
  Widget build(BuildContext context) {
    TextStyle tabTextStyle = TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.bold,
    );

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: Image.asset('assets/menuIcon.png'),
        title: Text(
          'Quran App',
          style: GoogleFonts.poppins(
            color: Colors.purple,
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset('assets/searchIcon.png'),
          ),
        ],
      ),
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(top: 5, left: 25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Assalamualaikum',
                        style: TextStyle(color: Colors.grey, fontSize: 17)),
                    Text(
                      'Reem Merheb',
                      style: GoogleFonts.poppins(
                        color: const Color.fromARGB(255, 0, 0, 0),
                        fontWeight: FontWeight.w600,
                        fontSize: 28,
                      ),
                    ),
                    SizedBox(height: 19),
                    Stack(
                      children: [
                        Image.asset(
                          'assets/frame2.png',
                          width: 360,
                          height: 140,
                          fit: BoxFit.cover,
                        ),
                        Positioned(
                          bottom: 50,
                          left: 20,
                          child: Text(
                            selectedSurahName,
                            style: GoogleFonts.poppins(
                              color: const Color.fromARGB(255, 233, 228, 228),
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 29,
                          left: 20,
                          child: Text(
                            selectedSurahNumber,
                            style: GoogleFonts.poppins(
                              color: const Color.fromARGB(255, 233, 228, 228),
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    TabBar(
                      controller: _tabController,
                      indicatorColor: Colors.purple,
                      indicatorWeight: 5.0,
                      labelColor: Colors.purple,
                      unselectedLabelColor: Colors.grey,
                      tabs: [
                        Tab(child: Text('Surah', style: tabTextStyle)),
                        Tab(child: Text('Para', style: tabTextStyle)),
                        Tab(child: Text('Page', style: tabTextStyle)),
                        Tab(child: Text('Hijb', style: tabTextStyle)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ];
        },
        body: Container(
          color: Colors.white,
          padding: EdgeInsets.only(top: 15),
          child: TabBarView(
            controller: _tabController,
            children: [
              FutureBuilder<List<Surah>>(
                future: surahs,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (snapshot.hasData) {
                    final surahs = snapshot.data!;
                    return ListView.separated(
                      itemCount: surahs.length,
                      separatorBuilder: (context, index) => Divider(
                          thickness: 1,
                          color: const Color.fromARGB(255, 233, 228, 228)),
                      itemBuilder: (context, index) {
                        final surah = surahs[index];

                        print(
                            'Name: ${surah.englishName}, Verses: ${surah.numberOfAyahs}');
                        return ListTile(
                            contentPadding: EdgeInsets.only(
                              left: 27,
                              right: 16,
                            ),
                            tileColor: Colors.grey.shade200,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            title: Text(
                              surah.englishName,
                              style: GoogleFonts.lato(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: const Color.fromARGB(255, 52, 10, 64),
                              ),
                            ),
                            subtitle: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '${surah.numberOfAyahs} VERSES',
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    color:
                                        const Color.fromARGB(221, 85, 84, 84),
                                  ),
                                ),
                                Text(
                                  surah.nameArabic,
                                  style: GoogleFonts.poppins(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.purple,
                                  ),
                                ),
                              ],
                            ),
                            leading: Stack(
                              alignment: Alignment.center,
                              children: [
                                Image.asset(
                                  'assets/Group 18 (2).png',
                                  width: 36,
                                  height: 36,
                                  fit: BoxFit.cover,
                                ),
                                Positioned(
                                  child: Text(
                                    surah.number.toString(),
                                    style: TextStyle(
                                      color:
                                          const Color.fromARGB(255, 52, 10, 64),
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            onTap: () {
                              setState(() {
                                selectedSurahName = surah.englishName;
                                selectedSurahNumber =
                                    'Ayat No: ${surah.numberOfAyahs}';
                              });

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      SurahDetails(surah: surah),
                                ),
                              );
                            });
                      },
                    );
                  } else {
                    return Center(child: Text('No Surahs found'));
                  }
                },
              ),
              Center(child: Text('')),
              Center(child: Text('')),
              Center(child: Text('')),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavBar(),
    );
  }
}
