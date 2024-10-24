import 'dart:async'; // Add this line
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:quran_app/models/surah_model.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:quran_app/models/surah_provider.dart';

class SurahDetails extends StatefulWidget {
  final Surah surah;

  const SurahDetails({super.key, required this.surah});

  @override
  _SurahDetailsState createState() => _SurahDetailsState();
}

class _SurahDetailsState extends State<SurahDetails>
    with WidgetsBindingObserver {
  List<String> arabicAyahTexts = [];
  List<String> englishAyahTexts = [];
  bool isLoading = true;
  AudioPlayer audioPlayer = AudioPlayer();
  int? currentlyPlayingAyah;
  bool isDebouncing = false;
  Timer? _nextAyahTimer; // Timer for next ayah playback

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchSurahText();
    });

    audioPlayer.onPlayerStateChanged.listen((state) {
      if (state == PlayerState.completed) {
        // Reset currentlyPlayingAyah when audio completes
        if (mounted) {
          setState(() {
            currentlyPlayingAyah = null;
          });
        }
        // Automatically play the next ayah if available
        if (currentlyPlayingAyah != null) {
          playNextAyah();
        }
      }
    });
  }

  Future<void> fetchSurahText() async {
    final provider = Provider.of<SurahProvider>(context, listen: false);
    await provider.fetchSurahText(widget.surah.number);

    if (mounted) {
      setState(() {
        arabicAyahTexts = provider.arabicAyahTexts;
        englishAyahTexts = provider.englishAyahTexts;
        isLoading = false;
      });
    }
  }

  Future<void> playAudio(int ayahNumber) async {
    if (widget.surah.number <= 0 ||
        ayahNumber <= 0 ||
        ayahNumber > widget.surah.numberOfAyahs) {
      return;
    }

    String audioUrl =
        'https://quranaudio.pages.dev/1/${widget.surah.number}_$ayahNumber.mp3';

    if (isDebouncing) return;
    isDebouncing = true;

    final playerState = audioPlayer.state;
    if (playerState == PlayerState.playing) {
      await audioPlayer.pause();
      if (mounted) {
        setState(() {
          currentlyPlayingAyah = null;
        });
      }
    } else {
      try {
        await audioPlayer.play(UrlSource(audioUrl));
        if (mounted) {
          setState(() {
            currentlyPlayingAyah = ayahNumber;
          });
        }
      } catch (e) {
        if (mounted) {
          setState(() {
            currentlyPlayingAyah = null;
          });
        }
      }
    }

   
    isDebouncing = false;

    // Cancel any existing timer before starting a new one
  ;
  }

  void playNextAyah() {
    if (currentlyPlayingAyah != null && currentlyPlayingAyah! < widget.surah.numberOfAyahs) {
      playAudio(currentlyPlayingAyah! + 1);
    }
  }

  @override
  void dispose() {
    audioPlayer.pause();
    audioPlayer.dispose();
    _nextAyahTimer?.cancel(); // Cancel the timer
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      audioPlayer.pause();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Image.asset('assets/backIcon.png'),
        ),
        title: Text(
          widget.surah.englishName,
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
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 15.0),
                    child: Stack(
                      children: [
                        Image.asset(
                          'assets/frame3.png',
                          width: double.infinity,
                          height: 350,
                          fit: BoxFit.cover,
                        ),
                        Positioned(
                          bottom: 250,
                          left: 130,
                          child: Text(
                            widget.surah.englishName,
                            style: GoogleFonts.poppins(
                              color: const Color.fromARGB(255, 233, 228, 228),
                              fontWeight: FontWeight.w600,
                              fontSize: 22,
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 140,
                          left: 100,
                          child: Image.asset(
                            'assets/Divider.png',
                            width: 210,
                            height: 170,
                          ),
                        ),
                        Positioned(
                          bottom: 190,
                          left: 150,
                          child: Text(
                            '${widget.surah.numberOfAyahs} VERSES',
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontWeight: FontWeight.w400,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 29,
                          left: 60,
                          child: Image.asset(
                            'assets/group.png',
                            width: 280,
                            height: 230,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ListView.builder(
                      itemCount: arabicAyahTexts.length,
                      itemBuilder: (context, index) {
                        bool isCurrentPlaying =
                            currentlyPlayingAyah == index + 1;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: double.infinity,
                              height: 40.0,
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 233, 229, 238),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: CircleAvatar(
                                      backgroundColor:
                                          Color.fromRGBO(134, 62, 213, 1.0),
                                      radius: 25,
                                      child: Text(
                                        '${index + 1}',
                                        style: GoogleFonts.poppins(
                                          color: Colors.white,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Spacer(),
                                  IconButton(
                                    icon: Icon(
                                      Icons.share_outlined,
                                      color: Color.fromRGBO(134, 62, 213, 1.0),
                                    ),
                                    onPressed: () {},
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      isCurrentPlaying
                                          ? Icons.stop
                                          : Icons.play_arrow_outlined,
                                      color: Color.fromRGBO(134, 62, 213, 1.0),
                                    ),
                                    onPressed: () {
                                      playAudio(index + 1);
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.bookmark_border,
                                        color:
                                            Color.fromRGBO(134, 62, 213, 1.0)),
                                    onPressed: () {},
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 8.0),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: Text(
                                    arabicAyahTexts[index],
                                    style: GoogleFonts.poppins(
                                      color: Colors.black87,
                                      fontSize: 16,
                                    ),
                                    textAlign: TextAlign.right,
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: Text(
                                    englishAyahTexts[index],
                                    style: GoogleFonts.poppins(
                                      color: Colors.black87,
                                      fontSize: 16,
                                    ),
                                    textAlign: TextAlign.right,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
