import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:codsoft_music_player/gradient_fab.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:just_audio/just_audio.dart';
import 'colors.dart';
import 'main_controller.dart';

class PlaySongPage extends StatefulWidget {
  const PlaySongPage({super.key, required this.index, required this.songs});
  final List<SongModel> songs;
  final int index;

  @override
  _PlaySongPageState createState() => _PlaySongPageState();
}

class _PlaySongPageState extends State<PlaySongPage> {

  late AudioPlayer _player;
  var controller = Get.put(MainController());
  int index = 0;
  @override
  void initState() {
    super.initState();
     index = widget.index;
    _player = AudioPlayer();
    _player.positionStream.listen((position) {
      controller.setPosition(position);
    });
    _init(index);
  }

  Future<void> _init(int i) async {
    await _player.setFilePath(widget.songs[i].data);
    _player.play();
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(
            Icons.arrow_back,
            color: AppColors.white,
          ),
        ),
        backgroundColor: AppColors.primary,
        // title: Text(
        //   'Music Player',
        //   style: TextStyle(
        //     color: AppColors.white,
        //   ),
        // ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(50.0),
            child: Container(
              height: MediaQuery.of(context).size.width - 100,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.bLight,
                    AppColors.secondary,
                  ],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: QueryArtworkWidget(
                  artworkBorder: BorderRadius.circular(0),
                  // controller: _audioQuery,
                  id: widget.songs[index].id,
                  type: ArtworkType.AUDIO,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 20),
            child: Column(
              children: [
                GetBuilder<MainController>(
                  init: MainController(),
                  builder: (controller)=>ProgressBar(
                    progress: controller.position,
                    total: Duration(milliseconds: widget.songs[index].duration!),
                    barHeight: 2,
                    progressBarColor: AppColors.secondary,
                    baseBarColor: AppColors.white,
                    thumbColor: AppColors.secondary,
                    thumbGlowColor: AppColors.white,
                    thumbGlowRadius: 12,
                    timeLabelTextStyle: TextStyle(
                      color: AppColors.white,
                    ),
onSeek: (duration) {
                      _player.seek(duration);
                    },
                  ),
                ),
                Text(
                  widget.songs[index].title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 20,
                  ),
                ),
                Text(
                  widget.songs[index].artist ?? 'No Artist',
                  style: TextStyle(
                    color: AppColors.bDark,
                    fontSize: 15,
                  ),
                ),
              ],
            )
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Divider(),
              IconButton(
                onPressed: () {
                  setState(() {
                    if(index>0){
                      index--;
                      controller.isPlaying = true;
                      _player.stop();
                      _init(index);
                    }
                  });
                },
                icon: Icon(
                  Icons.skip_previous,
                  size: 30,
                  color: AppColors.white,
                ),
              ),
              GetBuilder(
                init: MainController(),
                builder: (controller) {
                  return GradientFloatingActionButton(
                    onPressed: (){
                      controller.togglePlaying();
                      if (controller.isPlaying) {
                        _player.play();
                      } else {
                        _player.pause();
                      }

                    },
                    isPlaying: controller.isPlaying,
                    gradient: LinearGradient(
                      colors: [
                        AppColors.bLight,
                        AppColors.secondary,
                      ],
                    ),
                  );
                },
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    if(index<widget.songs.length-1){
                      index++;
                      controller.isPlaying = true;
                      _player.stop();
                      _init(index);
                    }
                  });
                },
                icon: Icon(
                  Icons.skip_next,
                  size: 30,
                  color: AppColors.white,
                ),
              ),
              const Divider(),
            ],
          ),
        ],
      ),
    );
  }
}
