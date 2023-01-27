import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:audioplayer/audioplayer.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';

typedef void OnError(Exception exception);
/*
const kUrl = "http://www.rxlabz.com/labz/audio2.mp3";
const kUrl2 = "http://www.rxlabz.com/labz/audio.mp3";

void main() {
  runApp(new MaterialApp(home: new Scaffold(body: new AudioApp())));
}
*/
enum PlayerState { stopped, playing, paused }

class AudioApp extends StatefulWidget {
  AudioApp(this.url);
  String url;

  @override
  _AudioAppState createState() => new _AudioAppState();
}

class _AudioAppState extends State<AudioApp> {
  Duration duration;
  Duration position;

  AudioPlayer audioPlayer;

  String localFilePath;

  PlayerState playerState = PlayerState.stopped;

  get isPlaying => playerState == PlayerState.playing;

  get isPaused => playerState == PlayerState.paused;

  get durationText =>
      duration != null ? duration.toString().split('.').first : '';

  get positionText =>
      position != null ? position.toString().split('.').first : '';

  bool isMuted = false;

  StreamSubscription _positionSubscription;
  StreamSubscription _audioPlayerStateSubscription;

  @override
  void initState() {
    super.initState();
    initAudioPlayer();
  }

  @override
  void dispose() {
    _positionSubscription.cancel();
    _audioPlayerStateSubscription.cancel();
    audioPlayer.stop();
    super.dispose();
  }

  void initAudioPlayer() {


    audioPlayer = new AudioPlayer();
    _positionSubscription = audioPlayer.onAudioPositionChanged
        .listen((p) => setState(() => position = p));
    _audioPlayerStateSubscription =
        audioPlayer.onPlayerStateChanged.listen((s) {
      if (s == AudioPlayerState.PLAYING) {
        setState(() => duration = audioPlayer.duration);
      } else if (s == AudioPlayerState.STOPPED) {
        onComplete();
        setState(() {
          position = duration;
        });
      }
    }, onError: (msg) {
      setState(() {
        playerState = PlayerState.stopped;
        duration = new Duration(seconds: 0);
        position = new Duration(seconds: 0);
      });
    });
  }

  Future play() async {
    await initAudioPlayer();
    await audioPlayer.play(widget.url);
    setState(() {
      playerState = PlayerState.playing;
    });
  }

  Future _playLocal() async {
    await audioPlayer.play(localFilePath, isLocal: true);
    setState(() => playerState = PlayerState.playing);
  }

  Future pause() async {
    await audioPlayer.pause();
    setState(() => playerState = PlayerState.paused);
  }

  Future stop() async {
    await audioPlayer.stop();
    setState(() {
      playerState = PlayerState.stopped;
      position = new Duration();
    });
  }

  Future mute(bool muted) async {
    await audioPlayer.mute(muted);
    setState(() {
      isMuted = muted;
    });
  }

  void onComplete() {
    setState(() => playerState = PlayerState.stopped);
  }

  Future<Uint8List> _loadFileBytes(String url, {OnError onError}) async {
    Uint8List bytes;
    try {
      bytes = await readBytes(url);
    } on ClientException {
      rethrow;
    }
    return bytes;
  }

  Future _loadFile() async {
    final bytes = await _loadFileBytes(widget.url,
        onError: (Exception exception) =>
            print('_loadFile => exception $exception'));

    final dir = await getApplicationDocumentsDirectory();
    final file = new File('${dir.path}/audio.mp3');

    await file.writeAsBytes(bytes);
    if (await file.exists())
      setState(() {
        localFilePath = file.path;
      });
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
        child: new Material(
            elevation: 2.0,
            color: Colors.grey[200],
            child: new Center(
              child: new Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    new Material(child: _buildPlayer()),


                  ]),
            )));
  }

  Widget _buildPlayer() => new Container(
      padding: new EdgeInsets.all(16.0),
      child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
        new Row(
          mainAxisAlignment: MainAxisAlignment.center,
            children: [
              new InkWell(
                onTap: isPlaying ? null : () => play(),
                child: new Icon(
                  Icons.play_arrow,
                  color: Colors.blue,
                  size: 24.0,
                ),
              ),
              Container(width: 4.0,),
              new InkWell(
                  onTap: isPlaying ? () => pause() : null,
                  child: new Icon(
                    Icons.pause,
                    color: Colors.blue,
                    size: 24.0,
                  )),
              Container(width: 4.0,),
              new InkWell(
                  onTap: isPlaying || isPaused ? () => stop() : null,
                  child: new Icon(
                    Icons.stop,
                    color: Colors.blue,
                    size: 24.0,
                  )),
              duration == null
                  ? new Container()
                  :Container(width:100.0,child:new Slider(
                  value: position?.inMilliseconds?.toDouble() ?? 0.0,
                  onChanged: (double value) =>
                      audioPlayer.seek((value / 1000).roundToDouble()),
                  min: 0.0,
                  max: duration.inMilliseconds.toDouble())),

              new InkWell(
                onTap: () => mute(true),
                child: new Icon(Icons.headset_off,size: 24.0,color: Colors.blue),
              ),
              Container(width: 4.0,)
              ,new InkWell(
                onTap: () => mute(false),
                child: new Icon(Icons.headset,size: 24.0, color: Colors.blue),
              ),
            ]),

        new Row(mainAxisSize: MainAxisSize.min, children: [
          /*new Padding(
              padding: new EdgeInsets.all(8.0),
              child: new Stack(children: [
                /*Container(width: 26.0,height: 26.0,child:new CircularProgressIndicator(
                    value: 1.0,
                    valueColor: new AlwaysStoppedAnimation(Colors.grey[300]))),*/
                new CircularProgressIndicator(
                  value: position != null && position.inMilliseconds > 0
                      ? (position?.inMilliseconds?.toDouble() ?? 0.0) /
                          (duration?.inMilliseconds?.toDouble() ?? 0.0)
                      : 0.0,
                  valueColor: new AlwaysStoppedAnimation(Colors.cyan),
                  backgroundColor: Colors.yellow,
                ),
              ])),*/
          new Text(
              position != null
                  ? "${positionText ?? ''} / ${durationText ?? ''}"
                  : duration != null ? durationText : '',
              style: new TextStyle(fontSize: 14.0))
        ])
      ]));
}
