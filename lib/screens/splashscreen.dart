import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:music_player/db/songsmodel.dart';
import 'package:music_player/screens/bottomnanigation.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../db/box.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    fetchSongs();
   // toHomeScreen();
    super.initState();
    
  }
  final box = Boxes.getInstance();
  final assetAudioPlayer = AssetsAudioPlayer.withId("0");
  List<Audio> audiosongs = [];
  final _audioQuery = OnAudioQuery();
  List<Songsdb> mappedSongs = [];
  List<Songsdb> dbSongs = [];
  List<SongModel> fetchedSongs = [];
  List<SongModel> allsong = [];
  fetchSongs() async {
    bool permissionStatus = await _audioQuery.permissionsStatus();
    if (!permissionStatus) {
      await _audioQuery.permissionsRequest();
    }
    allsong = await _audioQuery.querySongs();

    mappedSongs = allsong
        .map((e) => Songsdb(
            title: e.title,
            id: e.id.toString(),
            image: e.uri!,
            duration: e.duration.toString(),
            artist: e.artist))
        .toList();
    await box.put("musics", mappedSongs);
    dbSongs = box.get("musics") as List<Songsdb>;

    for (var element in dbSongs) {
      audiosongs.add(Audio.file(element.image.toString(),
          metas: Metas(
              title: element.title,
              id: element.id.toString(),
              artist: element.artist)));
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 24, 3, 18),
              Color.fromARGB(255, 2, 34, 34)
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: ClipRRect(
           
            child: Image.asset(
              
              'assets/Android Large - 1.png', fit: BoxFit.cover,
              //color: Colors.transparent,
              height: MediaQuery.of(context).size.height,
              // width: MediaQuery.of(context).size.width,
            ),
          ),
        ),
      ),
    );
  }

  Future<void> toHomeScreen() async {             
    await Future.delayed(
      // ignore: prefer_const_constructors
      Duration(seconds: 3),
      () {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) {
              return MyStatefulWidget(allsong: audiosongs);
            },
          ),
        );
      },
    );
  }
}
