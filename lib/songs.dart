import 'package:codsoft_music_player/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart';

import 'play_song_page.dart';

class Songs extends StatefulWidget {
  const Songs({super.key});

  @override
  _SongsState createState() => _SongsState();
}

class _SongsState extends State<Songs> {
  final OnAudioQuery _audioQuery = OnAudioQuery();

  bool _hasPermission = false;

  @override
  void initState() {
    super.initState();
    LogConfig logConfig = LogConfig(logType: LogType.DEBUG);
    _audioQuery.setLogConfig(logConfig);

    checkAndRequestPermissions();
  }

  checkAndRequestPermissions({bool retry = false}) async {
    _hasPermission = await _audioQuery.checkAndRequest(
      retryRequest: retry,
    );

    _hasPermission ? setState(() {}) : null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Text(
          "Your Library",
          style: TextStyle(color: AppColors.white),
        ),
        elevation: 2,
      ),
      body: Center(
        child: !_hasPermission
            ? noAccessToLibraryWidget()
            : FutureBuilder<List<SongModel>>(
                // Default values:
                future: _audioQuery.querySongs(
                  sortType: null,
                  orderType: OrderType.ASC_OR_SMALLER,
                  uriType: UriType.EXTERNAL,
                  ignoreCase: true,
                ),
                builder: (context, item) {
                  if (item.hasError) {
                    return Text(item.error.toString());
                  }

                  if (item.data == null) {
                    return const CircularProgressIndicator();
                  }

                  if (item.data!.isEmpty) return const Text("Nothing found!");

                  List<SongModel> songs = item.data!.reversed.toList();
                  return ListView.builder(
                    itemCount: item.data!.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Get.to(PlaySongPage(index: index, songs: songs));
                        },
                        child: ListTile(
                          title: Text(songs[index].title,
                              style: TextStyle(color: AppColors.white),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis),
                          subtitle: Text(songs[index].artist ?? "No Artist",
                              style: TextStyle(color: AppColors.bDark),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis),
                          trailing: Icon(
                            Icons.arrow_forward_rounded,
                            color: AppColors.white,
                          ),
                          leading: QueryArtworkWidget(
                            controller: _audioQuery,
                            id: songs[index].id,
                            type: ArtworkType.AUDIO,
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
      ),
    );
  }

  Widget noAccessToLibraryWidget() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.redAccent.withOpacity(0.5),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text("Application doesn't have access to the library"),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () => checkAndRequestPermissions(retry: true),
            child: const Text("Allow"),
          ),
        ],
      ),
    );
  }
}
