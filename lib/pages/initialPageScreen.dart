import 'dart:math';
import 'dart:convert'; // Importa la librería para trabajar con JSON
import 'dart:async'; // Importa la librería para trabajar con Timer
import 'package:flutter/material.dart';
import 'package:soundpool/soundpool.dart';
import 'package:flutter/services.dart' show ByteData, rootBundle;
import 'package:flutter_background/flutter_background.dart';
import 'package:camera/camera.dart'; 


class LluviaPageScreen extends StatefulWidget {
  const LluviaPageScreen({super.key});

  @override
  _LluviaPageScreenState createState() => _LluviaPageScreenState();
}

class _LluviaPageScreenState extends State<LluviaPageScreen> {

  late List<CameraDescription> cameras; 
  late CameraController _controllerCamera; 
  Color _bgColor = Colors.white; 

  late Soundpool _soundpoolSonidoFondo;
  late Soundpool _soundpoolTrueno;  
  late Soundpool _soundpoolTrein;
  int _soundId = 0;
  late int _streamId;
  int _treinSoundId = 0;
  int _thunderSoundId = 0;  
  List<String> _images = [];
  String _selectedImage = '';
  bool _isPlaying = true;
  double _volume = 1.0;
  int _thunderLevel = 0;
  
  Timer? _thunderTimer;
  Timer? _treinTimer;

  List<String> _rainSounds = [];
  String _selectedRainSound = 'lib/assets/sounds/lluvia-Estandar.mp3';
  bool _isFlashEnabled = false;
  bool _isTreinEnabled = false;
  Timer? _timer;
  int _timerDuration = 0;
  int _remainingTime = 0;
  bool _isTimerActive = false;

  @override
  void initState() {
    super.initState();
    _initializeBackgroundMode();    
    _loadImages();
    _loadRainSounds();    
    _playSound();
    _loadThunderSound();    
    _loadTrainSound();
     initializeCamera(); 
  }


    Future<void> initializeCamera() async { 
        cameras = await availableCameras(); 
        _controllerCamera = CameraController(cameras[0], ResolutionPreset.low); 
        await _controllerCamera.initialize(); 
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
  
  void _loadImages() async {
    final manifestContent = await rootBundle.loadString('AssetManifest.json');
    final Map<String, dynamic> manifestMap = json.decode(manifestContent);
    final images = manifestMap.keys
        .where((String key) => key.contains('lib/assets/images/'))
        .toList();
    setState(() {
      _images = images;
      _selectedImage = _images[Random().nextInt(_images.length)];
    });
  }

  void _loadRainSounds() async {
    final manifestContent = await rootBundle.loadString('AssetManifest.json');
    final Map<String, dynamic> manifestMap = json.decode(manifestContent);
    final rainSounds = manifestMap.keys
        .where((String key) => key.contains('lib/assets/sounds/') && key.contains('lluvia'))
        .toList();
    setState(() {
      _rainSounds = rainSounds;
    });
  }

  void _playSound() async {
    _soundpoolSonidoFondo = Soundpool(streamType: StreamType.music);
    _soundId = await rootBundle.load('lib/assets/sounds/lluvia-Estandar.mp3').then((ByteData soundData) {
      return _soundpoolSonidoFondo.load(soundData);
    });
    _streamId = await _soundpoolSonidoFondo.play(_soundId, repeat: -1);
  }

  void _loadThunderSound() async {
    _soundpoolTrueno = Soundpool(streamType: StreamType.music);
    _thunderSoundId = await rootBundle.load('lib/assets/sounds/thunder2.mp3').then((ByteData soundData) {
      return _soundpoolTrueno.load(soundData);
    });
  }

  void _loadTrainSound() async {
    _soundpoolTrein = Soundpool(streamType: StreamType.music);
    _treinSoundId = await rootBundle.load('lib/assets/sounds/tren.mp3').then((ByteData soundData) {
    return _soundpoolTrein.load(soundData);
    });
  }

  void _togglePlayPause() {
    if (
      _isPlaying) {
      _soundpoolSonidoFondo.pause(_streamId);
      _thunderTimer?.cancel();
      _treinTimer?.cancel();
      stopTimer;

    } else {
      _soundpoolSonidoFondo.resume(_streamId);
      _playThunder();
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

  void _toggleThunder() {
    setState(() {
      _thunderLevel = (_thunderLevel + 1) % 4;
    });
    _playThunder();
  }

  void _toggleTrein() {
    setState(() {
      _isTreinEnabled = !_isTreinEnabled;
    });
    _playTrein();
  }

  void _playTrein() {
    _treinTimer?.cancel();

    if (!_isTreinEnabled) return;

    int minInterval, maxInterval;
    minInterval = 45;
    maxInterval = 90;

    _treinTimer = Timer.periodic(Duration(seconds: Random().nextInt(maxInterval - minInterval) + minInterval), (timer) {
            if (_isPlaying) {
                _soundpoolTrein.play(_treinSoundId);
           }
    });


  }



  void _playThunder() {
    _thunderTimer?.cancel();
    if (_thunderLevel == 0) return;

    int minInterval, maxInterval;
    switch (_thunderLevel) {
      case 1:
        minInterval = 45;
        maxInterval = 60;
        break;
      case 2:
        minInterval = 30;
        maxInterval = 45;
        break;
      case 3:
        minInterval = 15;
        maxInterval = 30;
        break;
      default:
        return;
           }

    _thunderTimer = Timer.periodic(Duration(seconds: Random().nextInt(maxInterval - minInterval) + minInterval), (timer) {
            if (_isPlaying) {
                _soundpoolTrueno.play(_thunderSoundId);
                if (_isFlashEnabled) {
                  _flashLight();
                }
           }
    });
  }

  void _toggleFlash() {
    setState(() {
      _isFlashEnabled = !_isFlashEnabled;
    });
  }

  Future<void> _flashLight() async {
        if (_controllerCamera.value.isInitialized) { 
               await _controllerCamera.setFlashMode(FlashMode.torch); 
               await Future.delayed(const Duration(milliseconds: 50));
               await _controllerCamera.setFlashMode(FlashMode.off); 
               await _controllerCamera.setFlashMode(FlashMode.torch); 
               await Future.delayed(const Duration(milliseconds: 50));
               await _controllerCamera.setFlashMode(FlashMode.off); 
               await _controllerCamera.setFlashMode(FlashMode.torch); 
               await Future.delayed(const Duration(milliseconds: 200));
               await _controllerCamera.setFlashMode(FlashMode.off); 
               await _controllerCamera.setFlashMode(FlashMode.torch); 
               await Future.delayed(const Duration(milliseconds: 50));
               await _controllerCamera.setFlashMode(FlashMode.off); 
        } 

  }
  
  void _changeBackgroundImage() {
    setState(() {
      _selectedImage = _images[Random().nextInt(_images.length)];
    });
  }

  @override
  void dispose() {
    _soundpoolSonidoFondo.release();
    _soundpoolTrueno.release();
    _thunderTimer?.cancel();   
    _treinTimer?.cancel();
    _timer?.cancel();     
    FlutterBackground.disableBackgroundExecution();    
    _controllerCamera.dispose();     
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
          _thunderLevel = 0;
          _isFlashEnabled = false;

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
    return 'Sonido de lluvia: "$formattedName"';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _selectedImage.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(_selectedImage),
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
                    _boton_trueno(), 
                    const SizedBox(width: 10),
                    _boton_tren(), 
                    const SizedBox(width: 10),
                    _boton_cambio_foto(),
                    const SizedBox(width: 10),                    
                    _popup_sonido_fondo(),
                    const SizedBox(width: 10),
                    _botron_flash(),  
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

  Stack _botron_flash() {
    return Stack(
                alignment: Alignment.center,
                children: [
                CircleAvatar(
                          radius: 30,
                          backgroundColor: const Color.fromARGB(255, 34, 31, 31).withOpacity(0.6),
                          ),
                IconButton(
                                icon: const Icon(Icons.lightbulb),
                                onPressed: _toggleFlash,
                                color: _isFlashEnabled ? Colors.orange[600]  : Colors.white,
                                iconSize: 30,
                              ),
                ],
              );
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
                                icon: const Icon(Icons.water_drop, color: Colors.white, size: 30),
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

  Stack _boton_cambio_foto() {
    return Stack(
                alignment: Alignment.center,
                children: [
                CircleAvatar(
                          radius: 30,
                          backgroundColor: const Color.fromARGB(255, 34, 31, 31).withOpacity(0.6),
                          ),
                IconButton(
                    icon: const Icon(Icons.photo),
                    onPressed: _changeBackgroundImage,
                    color: Colors.white,
                    iconSize: 30,
                  )
                ],
              );
  }

  Stack _boton_trueno() {
    return Stack(
                alignment: Alignment.center,
                children: [
                CircleAvatar(
                          radius: 30,
                          backgroundColor: const Color.fromARGB(255, 34, 31, 31).withOpacity(0.6),
                          ),
                IconButton(
                    icon: _thunderLevel == 0 ? const Icon(Icons.flash_off,size: 35,) 
                                             : const Icon(Icons.flash_on,size: 35),
                    onPressed: _toggleThunder,
                    color: _thunderLevel == 0
                        ? Colors.white
                        : _thunderLevel == 1
                            ? Colors.yellow
                            : _thunderLevel == 2
                                ? Colors.orange
                                : Colors.red,
                    iconSize: 40,
                  ) 
                ],
              );
  }

 Stack _boton_tren(){
  return Stack(
                alignment: Alignment.center,
                children: [
                CircleAvatar(
                          radius: 30,
                          backgroundColor: const Color.fromARGB(255, 34, 31, 31).withOpacity(0.6),
                          ),
                IconButton(
                    icon: const Icon(Icons.train),
                    onPressed: _toggleTrein,
                    color: _isTreinEnabled ? Colors.orange[600] : Colors.white,
                    iconSize: 30,
                  )
                ],
              );
}


  Slider _slider_volume() {
    return Slider(
                value: _volume,
                min: 0.0,
                max: 1.0,
                onChanged: _setVolume,
                activeColor: Colors.white,
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