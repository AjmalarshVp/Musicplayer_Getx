// ignore_for_file: unnecessary_const

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:music_player/screens/custum/playlistscreen.dart';
import 'package:music_player/screens/main_page_design_page.dart';
import 'package:music_player/screens/playlist.dart';
import 'package:music_player/screens/search.dart';
import 'package:music_player/screens/settings_page.dart';
import 'package:on_audio_query/on_audio_query.dart';

import 'now_playing.dart';

// ignore: must_be_immutable
class MyStatefulWidget extends StatefulWidget {
   List<Audio> allsong;
   MyStatefulWidget({Key? key,required this.allsong}): super(key: key);

  @override
  State<MyStatefulWidget> createState() => MyStatefulWidgetState();
}

class MyStatefulWidgetState extends State<MyStatefulWidget> {
  final AssetsAudioPlayer assetAudioPlayer = AssetsAudioPlayer.withId("0");
 
  final maincolor =const Color(0xff181c27);
  int _selectedIndex = 0;
  Audio find(List<Audio> source, String fromPath) {
    return source.firstWhere((element) => element.path == fromPath);
  }
  

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final pages =[design_main_paage(
    allsong: widget.allsong,
  ),SearchScreen(fullSongs: widget.allsong),
   PlaylistScreen(playlistName: 'favorites'),
   play_List(playListname: '',),const settings()];
     double screenwidth=MediaQuery.of(context).size.width;
    return Scaffold(
     //appBar: AppBar(title: Text('ajmal'),backgroundColor: maincolor,),
      
      backgroundColor:const Color.fromARGB(255, 2, 36, 41),
      body: 
       pages[_selectedIndex],
          bottomNavigationBar: ClipRRect(
           borderRadius: const BorderRadius.only(topLeft: const Radius.circular(30),topRight: const Radius.circular(30)),

            child: BottomNavigationBar(
           backgroundColor: const Color.fromARGB(255, 3, 17, 19),
        items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
           icon: Icon(Icons.home),
           label: 'Home',
           backgroundColor: Colors.red,
            ),
             BottomNavigationBarItem(
           icon: Icon(Icons.search_outlined),
           label: 'search',
           backgroundColor: Colors.red,
            ),
            BottomNavigationBarItem(
           
           icon: Icon(Icons.library_music_rounded, ),
           label: 'Favorite',
           backgroundColor: Colors.green,
           
            ),
            BottomNavigationBarItem(
           icon: Icon(Icons.local_fire_department_rounded),
           label: 'library',
           backgroundColor: Colors.purple,
            ),
            BottomNavigationBarItem(
           icon: Icon(Icons.settings),
           label: 'Settings',
           backgroundColor: Colors.purple,
            ),
         
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.red,
        
        onTap: _onItemTapped ,
        type: BottomNavigationBarType.fixed,unselectedItemColor: const Color.fromARGB(255, 13, 116, 93),
    iconSize: screenwidth*0.07,
      ),
          ),
//down player
bottomSheet: SizedBox(
  height: 75,
  child: assetAudioPlayer.builderCurrent(builder: (BuildContext context,Playing? playing) {
    final myAudio =find(widget.allsong,playing!.audio.assetAudioPath);
    return Column(
      children: [
        GestureDetector(
          onTap:  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NowPlaying(
                           index: 0,
                           allsong: widget.allsong,
                        ),
                      ),
                    );
                  },
                 child: Container(
                    height: 75,
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(121, 4, 61, 66),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          SizedBox(
                            height: 55,
                            width: 55,
                            child: QueryArtworkWidget(
                              id: int.parse(myAudio.metas.id!),
                              type: ArtworkType.AUDIO,
                              artworkBorder: const BorderRadius.only(
                                  bottomLeft: Radius.circular(20),
                                      topLeft: Radius.circular(20),
                                      bottomRight: Radius.circular(20),
                                      topRight: Radius.circular(20)),
                              artworkFit: BoxFit.cover,
                              nullArtworkWidget: Container(
                                height: 55,
                                width: 55,
                                decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(20),
                                      topLeft: Radius.circular(20),
                                      bottomRight: Radius.circular(20),
                                      topRight: Radius.circular(20)),
                                  image: DecorationImage(
                                    image: AssetImage("assets/forallimages.jpg"),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                left: 12,
                                top: 12,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    myAudio.metas.title!,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 7),
                                  Text(
                                    myAudio.metas.artist!,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 20),
                          Row(
                            children: [
                               GestureDetector(
                                onTap: () {
                                  assetAudioPlayer.previous();
                                },
                                child: const Icon(
                                  Icons.skip_previous,
                                  size: 35,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(width: 10),
                              PlayerBuilder.isPlaying(
                                  player: assetAudioPlayer,
                                  builder: (context, isPlaying) {
                                    
                                    
                                    return 
                                    GestureDetector(
                                      onTap: () async {
                                        await assetAudioPlayer.playOrPause();
                                      },
                                      child: Icon(
                                        isPlaying
                                            ? Icons.pause_rounded
                                            : Icons.play_arrow_rounded,
                                        size: 45,
                                        color: Colors.white,
                                      ),
                                    );
                                  }),

                              const SizedBox(width: 10),
                              GestureDetector(
                                onTap: () {
                                  assetAudioPlayer.next();
                                },
                                child: const Icon(
                                  Icons.skip_next_rounded,
                                  size: 35,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(width: 15),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
        )
      ],
    );

  }
),


      ),
    );
  }
}

