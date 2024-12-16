import 'dart:math';
import 'dart:convert'; // Importa la librería para trabajar con JSON
import 'dart:async'; // Importa la librería para trabajar con Timer
import 'package:flutter/material.dart';
import 'package:soundpool/soundpool.dart';
import 'package:flutter/services.dart' show ByteData, rootBundle;
import 'package:flutter_background/flutter_background.dart';
import 'package:camera/camera.dart'; 


class VentiladorPageScreen extends StatefulWidget {
  const VentiladorPageScreen({super.key});

  @override
  _VentiladorPageScreenState createState() => _VentiladorPageScreenState();
}

class _VentiladorPageScreenState extends State<VentiladorPageScreen> {

  late List<CameraDescription> cameras; 
  Color _bgColor = Colors.white; 

  late Soundpool _soundpoolSonidoFondo;
  int _soundId = 0;
  late int _streamId;
  bool _isPlaying = true;
  double _volume = 1.0;
  
  Timer? _thunderTimer;
  Timer? _treinTimer;

  List<String> _rainSounds = [];
  String _selectedRainSound = 'lib/assets/sounds/ventilador-de-mesa.wav';
  Timer? _timer;
  int _timerDuration = 0;
  int _remainingTime = 0;
  bool _isTimerActive = false;

  @override
  void initState() {
    super.initState();
    _initializeBackgroundMode();    
    _loadRainSounds();    
    _playSound();
  }





  Future<void> _initializeBackgroundMode() async {
    var androidConfig = const FlutterBackgroundAndroidConfig(
      notificationTitle: "Rain Sounds",
      notificationText: "Playing rain sounds in the background",
      notificationIcon: AndroidResource(name: 'background_icon', defType: 'drawable'),
    );
    bool hasPermissions = await FlutterBackground.hasPermissions;
//    if (!hasPermissions) {
      hasPermissions = await FlutterBackground.initialize(androidConfig: androidConfig);
//    }
    if (hasPermissions) {
      FlutterBackground.enableBackgroundExecution();
    }

  }
  

  void _loadRainSounds() async {
    final manifestContent = await rootBundle.loadString('AssetManifest.json');
    final Map<String, dynamic> manifestMap = json.decode(manifestContent);
    final rainSounds = manifestMap.keys
        .where((String key) => key.contains('lib/assets/sounds/') && key.contains('ventilador'))
        .toList();
    setState(() {
      _rainSounds = rainSounds;
    });
  }

  void _playSound() async {
    _soundpoolSonidoFondo = Soundpool(streamType: StreamType.music);
    _soundId = await rootBundle.load('lib/assets/sounds/ventilador-de-mesa.wav').then((ByteData soundData) {
      return _soundpoolSonidoFondo.load(soundData);
    });
    _streamId = await _soundpoolSonidoFondo.play(_soundId, repeat: -1);
  }



  void _togglePlayPause() {
    if (
      _isPlaying) {
      _soundpoolSonidoFondo.pause(_streamId);
      stopTimer;

    } else {
      _soundpoolSonidoFondo.resume(_streamId);
    }
    setState(() {
      _isPlaying = !_isPlaying;
    });
  }

  void _setVolume(double volume) {
    _soundpoolSonidoFondo.setVolume(streamId: _streamId, volume: volume);
    setState(() {
      _volume = volume;
    });
  }

  @override
  void dispose() {
    _soundpoolSonidoFondo.release();
    _timer?.cancel();     
    FlutterBackground.disableBackgroundExecution();    
    super.dispose();
  }

  void _changeRainSound(String sound) async {
    _soundpoolSonidoFondo.stop(_streamId);
    _soundId = await rootBundle.load(sound).then((ByteData soundData) {
      return _soundpoolSonidoFondo.load(soundData);
    });
    _streamId = await _soundpoolSonidoFondo.play(_soundId, repeat: -1);
    setState(() {
      _selectedRainSound = sound;
    });
  }

  void _startTimer(int minutes) {
    if (_isTimerActive) {
      _timer?.cancel();
      setState(() {
        _isTimerActive = false;
        _timerDuration = 0;
        _remainingTime = 0;
      });
    } else {
      _timer?.cancel();
      setState(() {
        _timerDuration = minutes * 60;
        _remainingTime = _timerDuration;
        _isTimerActive = true;
      });
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        _updateTimer();
      });
    }
  }

  void _updateTimer() {
    setState(() {
      if (_remainingTime > 0) {
        _remainingTime--;
      } else {
        setState(() {
//          _timer?.cancel();
           stopTimer();
          _soundpoolSonidoFondo.pause(_streamId);          
          _thunderTimer?.cancel();
          _treinTimer?.cancel();
          _isPlaying = false;

        });
      }
    });
  }

  stopTimer() {
    _timer?.cancel();
    setState(() {
      _isTimerActive = false;
      _timerDuration = 0;
      _remainingTime = 0;
    });
  }

  String _formatSoundName(String sound) {
    // Remove the path and extension
    String fileName = sound.split('/').last.split('.').first;
    // Remove the first word (lluvia)
    List<String> parts = fileName.split('-');
    parts.removeAt(0);
    // Capitalize the first letter of the first word
    String formattedName = parts.map((part) => part[0].toUpperCase() + part.substring(1)).join(' ');
    return 'Ventilador $formattedName';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
               Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('lib/assets/imagesFan/venti.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
          Positioned(
            top: 100,
            right: 10,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _popup_sonido_fondo(),
                  ],
                ),

              ],
            ),
          ),
          Positioned(
            bottom: 180,
            right: 20,
            child: Column(
              children: [
                _boton_timer(), 
              ],
            ),
          ),
          Positioned(
            bottom: 100,
            left: 20,
            right: 20,
            child: Column(
              children: [
                _boton_play_pause(),
                _slider_volume(),
                if (_timerDuration > 0 && _isPlaying)
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Text(
                      "Time remaining: ${(_remainingTime / 60).floor()} mins ${_remainingTime % 60} secs",
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
              ],
            ),
          ),

        ],
      ),
    );
  }

  Widget _boton_timer() {
    if(_isPlaying){
        return !_isTimerActive 
                    ?Stack(
                      alignment: Alignment.center,
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: const Color.fromARGB(255, 34, 31, 31).withOpacity(0.6),
                          ),
                          PopupMenuButton<int>(
                            icon: const Icon(Icons.timer, color:  Colors.white, size: 35),
                            onSelected: _startTimer,
                            itemBuilder: (BuildContext context) {
                              return [
                                 PopupMenuItem<int>(value: 1, 
                                                    child: ListTile(
                                                          leading: const Icon(Icons.timer, color: Colors.blue),
                                                          title: Text("1 minute", style: TextStyle(color: Colors.grey[600])),
                                                          trailing: const Icon(Icons.arrow_forward_sharp,color: Colors.blue),
                                                        ),
                                                    ),
                                 PopupMenuItem<int>(value: 5, 
                                                    child: ListTile(
                                                          leading: const Icon(Icons.timer, color: Colors.blue),
                                                          title: Text("5 mins", style: TextStyle(color: Colors.grey[600])),
                                                          trailing: const Icon(Icons.arrow_forward_sharp,color: Colors.blue),
                                                        ),
                                                    ),
                                 PopupMenuItem<int>(value: 15, 
                                                    child: ListTile(
                                                          leading: const Icon(Icons.timer, color: Colors.blue),
                                                          title: Text("25 mins", style: TextStyle(color: Colors.grey[600])),
                                                          trailing: const Icon(Icons.arrow_forward_sharp,color: Colors.blue),
                                                        ),
                                                    ),
                                 PopupMenuItem<int>(value: 30, 
                                                    child: ListTile(
                                                          leading: const Icon(Icons.timer, color: Colors.blue),
                                                          title: Text("30 mins", style: TextStyle(color: Colors.grey[600])),
                                                          trailing: const Icon(Icons.arrow_forward_sharp,color: Colors.blue),
                                                        ),
                                                    ),
                                 PopupMenuItem<int>(value: 60, 
                                                    child: ListTile(
                                                          leading: const Icon(Icons.timer, color: Colors.blue),
                                                          title: Text("60 mins", style: TextStyle(color: Colors.grey[600])),
                                                          trailing: const Icon(Icons.arrow_forward_sharp,color: Colors.blue),
                                                        ),
                                                    ),
                                PopupMenuItem<int>(value: 120, 
                                                    child: ListTile(
                                                          leading: const Icon(Icons.timer, color: Colors.blue),
                                                          title: Text("120 mins", style: TextStyle(color: Colors.grey[600])),
                                                          trailing: const Icon(Icons.arrow_forward_sharp,color: Colors.blue),
                                                        ),
                                                    ),
                                 PopupMenuItem<int>(value: 180, 
                                                    child: ListTile(
                                                          leading: const Icon(Icons.timer, color: Colors.blue),
                                                          title: Text("180 mins", style: TextStyle(color: Colors.grey[600])),
                                                          trailing: const Icon(Icons.arrow_forward_sharp,color: Colors.blue),
                                                        ),
                                                    ),
                              ];
                            },
                        ),
                      ],
                    )
                    : Stack(
                      alignment: Alignment.center,
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: const Color.fromARGB(255, 34, 31, 31).withOpacity(0.6),
                          ),
                          IconButton(
                              icon:  Icon(Icons.timer, color: _isTimerActive ? Colors.orange[600] : Colors.white, size: 35) ,
                              onPressed: stopTimer,
                              iconSize: 35,
                          ),
                      ],
                    );
      }
      else{
        return Container();
      }
  }

  Stack _popup_sonido_fondo() {
    return  Stack(
                alignment: Alignment.center,
                children: [
                CircleAvatar(
                          radius: 30,
                          backgroundColor: const Color.fromARGB(255, 34, 31, 31).withOpacity(0.6),
                          ),
                PopupMenuButton<String>(
                                icon: const Icon(Icons.wind_power, color: Colors.white, size: 30),
                                onSelected: _changeRainSound,
                                itemBuilder: (BuildContext context) {
                                  return _rainSounds.map((String sound) {
                                    return PopupMenuItem<String>(
                                      value: sound,
                                              child: ListTile(
                                                      leading: const Icon(Icons.music_note, color: Colors.blue),
                                                      title: Text(_formatSoundName(sound), style: TextStyle(color: Colors.grey[600])),
                                                      trailing: _selectedRainSound == sound 
                                                                ? const Icon(Icons.check,color: Colors.green,) 
                                                                : const Icon(Icons.arrow_forward_sharp,color: Colors.blue),
                                                    ),
                                    );
                                  }).toList();
                                },
                              ),
                ],
              );
  }

  Slider _slider_volume() {
    return Slider(
                value: _volume,
                min: 0.0,
                max: 1.0,
                onChanged: _setVolume,
                activeColor: Colors.blue,
                inactiveColor: Colors.white54,
              );
  }

  Row _boton_play_pause() {
    return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      CircleAvatar(
                        radius: 35,
                        backgroundColor: const Color.fromARGB(255, 34, 31, 31).withOpacity(0.6),
                        ),
                      IconButton(
                        icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
                        onPressed: _togglePlayPause,
                        color: Colors.white,
                        iconSize: 40,
                      ),
                    ],
                  ),

                ],
              );
  }
}