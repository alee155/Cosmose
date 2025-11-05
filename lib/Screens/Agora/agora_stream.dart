import 'dart:async';
import 'dart:convert';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:cosmose/models/login_response.dart';
import 'package:cosmose/utils/app_colors.dart';
import 'package:cosmose/widgets/CustomElevatedButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';

class AgoraStreamStart extends StatefulWidget {
  final LoginResponse loginResponse;
  const AgoraStreamStart({super.key, required this.loginResponse});

  @override
  State<AgoraStreamStart> createState() => _AgoraStreamStartState();
}

class _AgoraStreamStartState extends State<AgoraStreamStart> {
  final TextEditingController _titleController = TextEditingController();
  String title = '';
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    print("***************************************");
    print("User Token: ${widget.loginResponse.token}");
    print("***************************************");
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  Future<void> generateAgoraToken() async {
    if (title.trim().isEmpty) {
      print("Title is required.");
      return;
    }

    setState(() {
      isLoading = true;
    });

    final url = Uri.parse("https://cosmoseworld.fr/api/live-stream/start");

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${widget.loginResponse.token}',
      },
      body: jsonEncode({'channel_name': title}),
    );

    setState(() {
      isLoading = false;
    });

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print(
        "===================================================================================",
      );
      print("✅ API Response: $data");

      print(
        "===================================================================================",
      );
      if (data['app_id'] != null &&
          data['token'] != null &&
          data['channel_name'] != null &&
          data['user_id'] != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) => StreamingScreen(
                  appId: data['app_id'],
                  token: data['token'],
                  channelName: data['channel_name'],
                  uid: data['user_id'],
                  loginResponse: widget.loginResponse,
                ),
          ),
        );
      } else {
        print("❌ One or more required fields are missing from the response:");
        print("app_id: ${data['app_id']}");
        print("token: ${data['token']}");
        print("channelName: ${data['channel_name']}");
        print("user_id: ${data['user_id']}");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: Missing streaming credentials.')),
        );
      }
    } else {
      print("❌ Error: ${response.statusCode}");
      print("❌ Response body: ${response.body}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Start Stream'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            50.h.verticalSpace,
            TextField(
              controller: _titleController,
              onChanged: (value) {
                setState(() {
                  title = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Enter your stream title',
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
              ),
            ),
            50.h.verticalSpace,
            isLoading
                ? const CircularProgressIndicator()
                : CustomElevatedButton(
                  text: "Start Stream",
                  onPressed: generateAgoraToken,
                  color: AppColors.green,
                  borderRadius: 12.r,
                  height: 50.h,
                  width: MediaQuery.of(context).size.width,
                ),
          ],
        ),
      ),
    );
  }
}

class StreamingScreen extends StatefulWidget {
  final String appId;
  final String token;
  final String channelName;
  final int uid;
  final LoginResponse loginResponse;

  const StreamingScreen({
    super.key,
    required this.appId,
    required this.token,
    required this.channelName,
    required this.uid,
    required this.loginResponse,
  });

  @override
  State<StreamingScreen> createState() => _StreamingScreenState();
}

class _StreamingScreenState extends State<StreamingScreen>
    with TickerProviderStateMixin {
  RtcEngine? _engine;
  final List<int> _remoteUids = [];

  bool _isMuted = false;
  bool _isFrontCamera = true;
  bool _isVideoEnabled = true;
  final bool _isFullscreen = false;
  bool _showControls = true;
  final int _viewerCount = 0;
  late AnimationController _fadeController;
  StreamSubscription? _controlsTimer;

  @override
  void initState() {
    super.initState();
    print("***************************************");
    print("User Token: ${widget.loginResponse.token}");
    print("***************************************");
    initializeAgora();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _fadeController.forward();
    _startControlsTimer();
  }

  void _startControlsTimer() {
    _controlsTimer?.cancel();
    _controlsTimer = Stream.periodic(const Duration(seconds: 5)).listen((_) {
      if (_showControls) {
        setState(() {
          _showControls = false;
          _fadeController.reverse();
        });
      }
    });
  }

  void _handleTap() {
    setState(() {
      _showControls = !_showControls;
      if (_showControls) {
        _fadeController.forward();
        _startControlsTimer();
      } else {
        _fadeController.reverse();
      }
    });
  }

  Future<void> initializeAgora() async {
    await [Permission.camera, Permission.microphone].request();

    final engine = createAgoraRtcEngine();
    await engine.initialize(
      RtcEngineContext(
        appId: widget.appId,
        channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
      ),
    );

    // Set client role as broadcaster
    await engine.setClientRole(role: ClientRoleType.clientRoleBroadcaster);

    await engine.enableVideo();
    await engine.startPreview();

    engine.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          print("✅ Local user joined: ${connection.localUid}");
        },
        onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
          setState(() {
            _remoteUids.add(remoteUid);
          });
        },
        onUserOffline: (
          RtcConnection connection,
          int remoteUid,
          UserOfflineReasonType reason,
        ) {
          setState(() {
            _remoteUids.remove(remoteUid);
          });
        },
      ),
    );

    await engine.joinChannel(
      token: widget.token,
      channelId: widget.channelName,
      uid: widget.uid,
      options: const ChannelMediaOptions(
        clientRoleType: ClientRoleType.clientRoleBroadcaster,
        publishMicrophoneTrack: true,
        publishCameraTrack: true,
      ),
    );

    print("✅ Streamer joined with UID: ${widget.uid}");

    setState(() {
      _engine = engine;
    });
  }

  void _toggleMute() {
    if (_engine != null) {
      _engine!.muteLocalAudioStream(!_isMuted);
      setState(() {
        _isMuted = !_isMuted;
      });
      _startControlsTimer();
    }
  }

  void _switchCamera() {
    if (_engine != null) {
      _engine!.switchCamera();
      setState(() {
        _isFrontCamera = !_isFrontCamera;
      });
      _startControlsTimer();
    }
  }

  void _toggleVideo() {
    if (_engine != null) {
      if (_isVideoEnabled) {
        _engine!.disableVideo();
      } else {
        _engine!.enableVideo();
        _engine!.startPreview();
      }
      setState(() {
        _isVideoEnabled = !_isVideoEnabled;
      });
      _startControlsTimer();
    }
  }

  @override
  void dispose() {
    _controlsTimer?.cancel();
    _fadeController.dispose();
    _engine?.leaveChannel();
    _engine?.release();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_engine == null) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.green),
              ),
              const SizedBox(height: 20),
              Text(
                'Initializing stream...',
                style: TextStyle(color: Colors.white, fontSize: 16.sp),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,

      body: GestureDetector(
        onTap: _handleTap,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Main video view
            _isVideoEnabled
                ? AgoraVideoView(
                  controller: VideoViewController(
                    rtcEngine: _engine!,
                    canvas: const VideoCanvas(uid: 0),
                  ),
                )
                : Container(
                  color: Colors.black87,
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.videocam_off,
                          size: 64.sp,
                          color: Colors.white54,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Camera is off',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 16.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

            // Stream info overlay
            FadeTransition(
              opacity: _fadeController,
              child: Visibility(
                visible: _showControls,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.center,
                      colors: [
                        Colors.black.withOpacity(0.7),
                        Colors.transparent,
                      ],
                    ),
                  ),
                  child: SafeArea(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 16.h,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Top bar with channel name and viewer count
                          Row(
                            children: [
                              _buildStatusIndicator(),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  widget.channelName,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.black54,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.remove_red_eye,
                                      color: Colors.white,
                                      size: 16,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      '$_viewerCount',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Remote videos
            if (_remoteUids.isNotEmpty)
              FadeTransition(
                opacity: _fadeController,
                child: Visibility(
                  visible: _showControls || _isFullscreen,
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: EdgeInsets.only(right: 16.w, top: 70.h),
                      child: SizedBox(
                        height: _isFullscreen ? 240.h : 200.h,
                        width: _isFullscreen ? 160.w : 120.w,
                        child: ListView.builder(
                          itemCount: _remoteUids.length,
                          itemBuilder: (_, index) {
                            return Container(
                              height: 120.h,
                              width: _isFullscreen ? 160.w : 100.w,
                              margin: EdgeInsets.all(_isFullscreen ? 8 : 5),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: AppColors.green,
                                  width: 2,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.3),
                                    blurRadius: 5,
                                    spreadRadius: 1,
                                  ),
                                ],
                              ),
                              clipBehavior: Clip.antiAlias,
                              child: AgoraVideoView(
                                controller: VideoViewController.remote(
                                  rtcEngine: _engine!,
                                  canvas: VideoCanvas(uid: _remoteUids[index]),
                                  connection: RtcConnection(
                                    channelId: widget.channelName,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ),

            // Controls overlay
            FadeTransition(
              opacity: _fadeController,
              child: Visibility(
                visible: _showControls,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.center,
                      colors: [
                        Colors.black.withOpacity(0.7),
                        Colors.transparent,
                      ],
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // Bottom controls
                      Padding(
                        padding: EdgeInsets.only(
                          bottom: 40.h,
                          left: 30.w,
                          right: 30.w,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildControlButton(
                              icon: _isMuted ? Icons.mic_off : Icons.mic,
                              color: _isMuted ? Colors.red : Colors.white,
                              onTap: _toggleMute,
                            ),
                            _buildControlButton(
                              icon:
                                  _isVideoEnabled
                                      ? Icons.videocam
                                      : Icons.videocam_off,
                              color:
                                  _isVideoEnabled ? Colors.white : Colors.red,
                              onTap: _toggleVideo,
                            ),
                            _buildControlButton(
                              icon: Icons.cameraswitch,
                              color: Colors.white,
                              onTap: _switchCamera,
                            ),
                            _buildControlButton(
                              icon: Icons.call_end,
                              color: Colors.white,
                              onTap: () async {
                                try {
                                  final response = await http.get(
                                    Uri.parse(
                                      'https://cosmoseworld.fr/api/end-live-stream',
                                    ),
                                    headers: {
                                      'Authorization':
                                          'Bearer ${widget.loginResponse.token}',
                                    },
                                  );

                                  print(
                                    '🔚 ======================End stream response====================: ${response.body}',
                                  );

                                  if (response.statusCode == 200) {
                                    _engine?.leaveChannel();

                                    if (!mounted) return;
                                    Navigator.pop(context);

                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'Stream ended successfully',
                                        ),
                                        backgroundColor: Colors.green,
                                      ),
                                    );
                                  } else {
                                    if (!mounted) return;
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'Failed to end stream: ${response.statusCode}',
                                        ),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                  }
                                } catch (e) {
                                  print('❌ Error ending stream: $e');
                                  if (!mounted) return;
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Error ending stream'),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                              },

                              isEndCall: true,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
    bool isEndCall = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 56.w,
        height: 56.h,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isEndCall ? Colors.red : Colors.black.withOpacity(0.6),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 5,
              spreadRadius: 1,
            ),
          ],
          border: Border.all(
            color: isEndCall ? Colors.red.shade300 : Colors.white24,
            width: 1,
          ),
        ),
        child: Icon(icon, color: color, size: 28),
      ),
    );
  }

  Widget _buildStatusIndicator() {
    return Container(
      width: 12,
      height: 12,
      decoration: BoxDecoration(
        color: Colors.red,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.red.withOpacity(0.5),
            blurRadius: 4,
            spreadRadius: 2,
          ),
        ],
      ),
    );
  }
}
