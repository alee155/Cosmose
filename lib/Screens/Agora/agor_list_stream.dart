import 'dart:convert';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cosmose/models/login_response.dart';
import 'package:cosmose/services/block_service.dart';
import 'package:cosmose/services/comment_service.dart';
import 'package:cosmose/services/dislike_service.dart';
import 'package:cosmose/services/leave_service.dart';
import 'package:cosmose/services/like_service.dart';
import 'package:cosmose/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';

class AgoraListStream extends StatefulWidget {
  final LoginResponse loginResponse;
  const AgoraListStream({super.key, required this.loginResponse});

  @override
  State<AgoraListStream> createState() => _AgoraListStreamState();
}

class _AgoraListStreamState extends State<AgoraListStream>
    with SingleTickerProviderStateMixin {
  List<dynamic> liveStreams = [];
  bool isLoading = true;
  late AnimationController _animationController;

  // Theme colors
  final Color primaryColor = const Color(0xFF6C63FF);
  final Color backgroundColor = const Color(0xFFF5F7FA);
  final Color cardColor = Colors.white;
  final Color textColor = const Color(0xFF2D3748);
  final Color accentColor = const Color(0xFFFFA500);

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    fetchLiveStreams();

    // Set status bar color
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );
  }

  Future<void> fetchLiveStreams() async {
    final url = Uri.parse("https://cosmoseworld.fr/api/list-live-stream");

    try {
      final response = await http.get(
        url,
        headers: {
          "Authorization": "Bearer ${widget.loginResponse.token}",
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          liveStreams = data['live_streams'];
          isLoading = false;
        });
      } else {
        print("Failed to fetch live streams.");
        setState(() => isLoading = false);
      }
    } catch (e) {
      print("Error fetching streams: $e");
      setState(() => isLoading = false);
    }
  }

  Future<void> joinLiveStream(String channelName) async {
    final url = Uri.parse("https://cosmoseworld.fr/api/live-stream/join");

    try {
      final response = await http.post(
        url,
        headers: {
          "Authorization": "Bearer ${widget.loginResponse.token}",
          "Content-Type": "application/json",
        },
        body: jsonEncode({"channel_name": channelName}),
      );
      print("*************************************************************");
      print("Viewer Response Data");
      print("Viewer Response body: ${response.body}");
      print("*************************************************************");

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final token = data['token'];
        final appId = data['app_id'];
        final userId = data['user_id'];
        final channel = data['channel_name'];

        // Debug token information
        print("Token received: $token");
        print("Token length: ${token.length}");
        print("App ID: $appId");
        print("User ID: $userId");
        print("Channel: $channel");
        print("Navigating to viewer screen...");

        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) => AgoraViewerScreen(
                  token: token,
                  channelName: channel,
                  appId: appId,
                  userId: userId,
                  loginResponse: widget.loginResponse,
                ),
          ),
        );
      } else {
        print("Failed to join live stream.");
        print("Status code: ${response.statusCode}");
        print("Response body: ${response.body}");
      }
    } catch (e) {
      print("Error joining stream: $e");
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // Helper method to get a placeholder image based on farm name
  String _getPlaceholderImageUrl(String? farmName) {
    // Use a placeholder based on the first letter of farm name if available
    if (farmName != null && farmName.isNotEmpty) {
      final initial = farmName[0].toLowerCase();
      return 'https://ui-avatars.com/api/?name=$initial&background=random&size=100';
    }
    return 'https://via.placeholder.com/150/6C63FF/FFFFFF?text=Live';
  }

  // Helper method to get stream status indicator
  Widget _getStatusIndicator() {
    return Container(
      width: 12,
      height: 12,
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(6),
        boxShadow: [
          BoxShadow(
            color: Colors.red.withOpacity(0.5),
            blurRadius: 4,
            spreadRadius: 1,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text(
          "Live Streams",
          style: TextStyle(fontWeight: FontWeight.bold, color: textColor),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: cardColor,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: AppColors.green),
            onPressed: () {
              setState(() {
                isLoading = true;
              });
              fetchLiveStreams();
            },
          ),
        ],
      ),
      body: SafeArea(
        child:
            isLoading
                ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SpinKitCircle(color: AppColors.green, size: 55.0),
                      const SizedBox(height: 16),
                      Text(
                        "Finding live streams...",
                        style: TextStyle(color: textColor.withOpacity(0.7)),
                      ),
                    ],
                  ),
                )
                : liveStreams.isEmpty
                ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.offline_bolt,
                        size: 80,
                        color: textColor.withOpacity(0.3),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "No live streams available",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: textColor.withOpacity(0.7),
                        ),
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            isLoading = true;
                          });
                          fetchLiveStreams();
                        },
                        child: const Text("Refresh"),
                      ),
                    ],
                  ),
                )
                : Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: ListView.builder(
                    itemCount: liveStreams.length,
                    itemBuilder: (context, index) {
                      final stream = liveStreams[index];
                      final farmName = stream['farm_name'] ?? "Live Stream";
                      final channelName = stream['channel_name'] ?? "";
                      final userId = stream['user_id'] ?? "";

                      // Create a staggered animation for each item
                      final animation = Tween(begin: 0.0, end: 1.0).animate(
                        CurvedAnimation(
                          parent: _animationController,
                          curve: Interval(
                            index / liveStreams.length,
                            1.0,
                            curve: Curves.easeOut,
                          ),
                        ),
                      );

                      _animationController.forward();

                      return FadeTransition(
                        opacity: animation,
                        child: SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(0, 0.2),
                            end: Offset.zero,
                          ).animate(animation),
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 16),
                            decoration: BoxDecoration(
                              color: cardColor,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(16),
                                onTap: () {
                                  // Haptic feedback on tap
                                  HapticFeedback.lightImpact();
                                  joinLiveStream(stream['channel_name']);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Thumbnail with live indicator
                                      Stack(
                                        children: [
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                            child: Container(
                                              width: 100,
                                              height: 100,
                                              color: primaryColor.withOpacity(
                                                0.1,
                                              ),
                                              child: CachedNetworkImage(
                                                imageUrl:
                                                    _getPlaceholderImageUrl(
                                                      farmName,
                                                    ),
                                                fit: BoxFit.cover,
                                                placeholder:
                                                    (context, url) => Center(
                                                      child: CircularProgressIndicator(
                                                        valueColor:
                                                            AlwaysStoppedAnimation<
                                                              Color
                                                            >(
                                                              primaryColor
                                                                  .withOpacity(
                                                                    0.5,
                                                                  ),
                                                            ),
                                                      ),
                                                    ),
                                                errorWidget:
                                                    (
                                                      context,
                                                      url,
                                                      error,
                                                    ) => const Icon(
                                                      Icons.image_not_supported,
                                                      color: Colors.grey,
                                                    ),
                                              ),
                                            ),
                                          ),
                                          // Live indicator badge
                                          Positioned(
                                            top: 8,
                                            left: 8,
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 8,
                                                    vertical: 4,
                                                  ),
                                              decoration: BoxDecoration(
                                                color: Colors.red,
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                              ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  _getStatusIndicator(),
                                                  const SizedBox(width: 4),
                                                  const Text(
                                                    "LIVE",
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 10,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(width: 16),
                                      // Stream information
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              farmName,
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: textColor,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            const SizedBox(height: 8),
                                            Row(
                                              children: [
                                                Icon(
                                                  Icons.perm_identity,
                                                  size: 16,
                                                  color: textColor.withOpacity(
                                                    0.6,
                                                  ),
                                                ),
                                                const SizedBox(width: 4),
                                                Expanded(
                                                  child: Text(
                                                    "ID: $userId",
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      color: textColor
                                                          .withOpacity(0.6),
                                                    ),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 4),
                                            Row(
                                              children: [
                                                Icon(
                                                  Icons.tag,
                                                  size: 16,
                                                  color: textColor.withOpacity(
                                                    0.6,
                                                  ),
                                                ),
                                                const SizedBox(width: 4),
                                                Expanded(
                                                  child: Text(
                                                    "Channel: $channelName",
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      color: textColor
                                                          .withOpacity(0.6),
                                                    ),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 12),
                                            // Join button
                                            Container(
                                              width: double.infinity,
                                              alignment: Alignment.centerRight,
                                              child: ElevatedButton(
                                                onPressed:
                                                    () => joinLiveStream(
                                                      stream['channel_name'],
                                                    ),
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      AppColors.green,
                                                  foregroundColor: Colors.white,
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        horizontal: 16,
                                                        vertical: 8,
                                                      ),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          20,
                                                        ),
                                                  ),
                                                ),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: const [
                                                    Icon(
                                                      Icons.visibility,
                                                      size: 16,
                                                    ),
                                                    SizedBox(width: 4),
                                                    Text("Join Stream"),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
      ),
    );
  }
}

class AgoraViewerScreen extends StatefulWidget {
  final String appId;
  final String token;
  final String channelName;
  final int userId;
  final LoginResponse loginResponse;

  const AgoraViewerScreen({
    super.key,
    required this.appId,
    required this.token,
    required this.channelName,
    required this.userId,
    required this.loginResponse,
  });

  // Custom debug info method instead of toString override
  String getDebugInfo() {
    return 'AgoraViewerScreen(appId: $appId, token: ${token.length > 10 ? "${token.substring(0, 10)}..." : token}, channelName: $channelName, userId: $userId)';
  }

  @override
  State<AgoraViewerScreen> createState() => _AgoraViewerScreenState();
}

class _AgoraViewerScreenState extends State<AgoraViewerScreen> {
  
  late RtcEngine _engine;
  bool isHostJoined = false;
  final List<int> _remoteUids = [];
  final TextEditingController _commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    initializeAgora();
    print("***************************************");
    print("User Token IN JOIN STREAM: ${widget.loginResponse.token}");
    print("***************************************");
  }

  Future<void> initializeAgora() async {
    await [Permission.microphone, Permission.camera].request();

    print("🔍 Viewer initializing with appId: ${widget.appId}");
    print("🔍 Viewer channel: ${widget.channelName}");
    print("🔍 Viewer userId: ${widget.userId}");

    _engine = createAgoraRtcEngine();
    await _engine.initialize(
      RtcEngineContext(
        appId: widget.appId,
        channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
      ),
    );

    await _engine.setClientRole(role: ClientRoleType.clientRoleAudience);

    _engine.registerEventHandler(
      RtcEngineEventHandler(
        onUserJoined: (connection, remoteUid, elapsed) {
          print("🎉 Host joined with UID: $remoteUid");
          print("🎉 Connection channel: ${connection.channelId}");
          setState(() {
            isHostJoined = true;
            _remoteUids.add(remoteUid);
          });
        },
        onUserOffline: (connection, remoteUid, reason) {
          print("👋 Host left: $remoteUid");
          setState(() {
            _remoteUids.remove(remoteUid);
            isHostJoined = _remoteUids.isNotEmpty;
          });
        },
        onRemoteVideoStateChanged: (
          connection,
          remoteUid,
          state,
          reason,
          elapsed,
        ) {
          print(
            "📹 Remote video state changed: UID=$remoteUid, State=$state, Reason=$reason",
          );
        },
        onRemoteAudioStateChanged: (
          connection,
          remoteUid,
          state,
          reason,
          elapsed,
        ) {
          print(
            "🔊 Remote audio state changed: UID=$remoteUid, State=$state, Reason=$reason",
          );
        },

        onConnectionStateChanged: (connection, state, reason) {
          print("🔌 Connection state changed: State=$state, Reason=$reason");
        },
        onTokenPrivilegeWillExpire: (connection, token) {
          print("⚠️ Token will expire soon");
        },
        onJoinChannelSuccess: (connection, elapsed) {
          print("Viewer joined channel: ${connection.channelId}");
        },
        onError: (ErrorCodeType err, String msg) {
          print("Agora error: $err, message: $msg");
        },
      ),
    );

    await _engine.enableVideo();

    // Set video encoder configuration for better viewing experience
    await _engine.setVideoEncoderConfiguration(
      const VideoEncoderConfiguration(
        dimensions: VideoDimensions(width: 640, height: 360),
        frameRate: 15,
        bitrate: 0, // Auto bitrate
      ),
    );

    // Clean up the token - remove any whitespace that might be causing issues
    final String cleanToken = widget.token.trim();
    print("🔑 Original token length: ${widget.token.length}");
    print("🔑 Cleaned token length: ${cleanToken.length}");

    // Make sure we have a valid token
    if (cleanToken.isEmpty) {
      print("❌ Error: Empty token provided");
      return;
    }

    if (cleanToken.length > 20) {
      print("🔑 Using token: ${cleanToken.substring(0, 20)}...");
    } else {
      print("🔑 Using token: $cleanToken");
    }

    // Set up event handlers before joining the channel
    _engine.registerEventHandler(
      RtcEngineEventHandler(
        onTokenPrivilegeWillExpire: (RtcConnection connection, String token) {
          print("⚠️ Token will expire soon, need to refresh");
        },
        onRequestToken: (RtcConnection connection) {
          print("⚠️ Token has expired, need a new token");
        },
      ),
    );

    try {
      print("🔌 Attempting to join channel: ${widget.channelName}");
      // Join with the provided userId
      await _engine.joinChannel(
        token: cleanToken,
        channelId: widget.channelName,
        uid: widget.userId,
        options: const ChannelMediaOptions(
          clientRoleType: ClientRoleType.clientRoleAudience,
          audienceLatencyLevel:
              AudienceLatencyLevelType.audienceLatencyLevelLowLatency,
          autoSubscribeVideo: true,
          autoSubscribeAudio: true,
        ),
      );

      print("✅ Successfully joined channel with UID: ${widget.userId}");
    } catch (e) {
      print("❌ Error joining channel: $e");

      // If the first attempt fails, try with a different approach
      try {
        print("🔄 Trying alternative approach with UID 0...");
        await _engine.joinChannel(
          token: cleanToken,
          channelId: widget.channelName,
          uid: 0, // Let Agora assign a UID
          options: const ChannelMediaOptions(
            clientRoleType: ClientRoleType.clientRoleAudience,
            audienceLatencyLevel:
                AudienceLatencyLevelType.audienceLatencyLevelLowLatency,
            autoSubscribeVideo: true,
            autoSubscribeAudio: true,
          ),
        );
      } catch (e2) {
        print("❌ Second attempt also failed: $e2");
        print("❓ Detailed error: $e2");

        // As a last resort, try without a token (if the app ID has App Certificate disabled)
        try {
          print("⚠️ Last resort: Trying to join without token...");
          await _engine.joinChannel(
            token: "",
            channelId: widget.channelName,
            uid: widget.userId,
            options: const ChannelMediaOptions(
              clientRoleType: ClientRoleType.clientRoleAudience,
              audienceLatencyLevel:
                  AudienceLatencyLevelType.audienceLatencyLevelLowLatency,
              autoSubscribeVideo: true,
              autoSubscribeAudio: true,
            ),
          );
        } catch (e3) {
          print(
            "❌ All attempts failed. Please check your Agora configuration.",
          );
        }
      }
    }

    print(
      "🔍 Viewer joined channel: ${widget.channelName} with UID: ${widget.userId}",
    );
  }

  @override
  void dispose() {
    _engine.leaveChannel();
    _engine.release();
    super.dispose();
  }

  // Control variables
  bool _isControlsVisible = true;
  bool _isMuted = false;
  final bool _isFullScreen = false;

  // Method to toggle controls visibility
  void _toggleControlsVisibility() {
    setState(() {
      _isControlsVisible = !_isControlsVisible;
    });
  }

  // Method to toggle audio mute
  void _toggleMute() {
    setState(() {
      _isMuted = !_isMuted;
      _engine.muteAllRemoteAudioStreams(_isMuted);
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_isFullScreen) {
          return false;
        }
        return true;
      },
      child: Scaffold(
        backgroundColor: AppColors.green,
        appBar:
            _isFullScreen
                ? null
                : AppBar(
                  backgroundColor: Colors.black.withOpacity(0.7),
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  title: Text(
                    "Watching: ${widget.channelName}",
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.refresh, color: Colors.white),
                      onPressed: () {
                        // Force refresh the remote video view
                        if (_remoteUids.isEmpty) {
                          setState(() {});
                        }
                      },
                    ),
                  ],
                  elevation: 0,
                ),

        body: GestureDetector(
          onTap: _toggleControlsVisibility,
          child: Stack(
            children: [
              // Main content - either video or waiting screen
              _remoteUids.isNotEmpty
                  ? Center(
                    child: AgoraVideoView(
                      controller: VideoViewController.remote(
                        rtcEngine: _engine,
                        canvas: VideoCanvas(uid: _remoteUids[0]),
                        connection: RtcConnection(
                          channelId: widget.channelName,
                        ),
                      ),
                    ),
                  )
                  : Container(
                    color: const Color(0xFF121212),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.live_tv,
                            color: AppColors.green,
                            size: 72,
                          ),
                          const SizedBox(height: 24),
                          Text(
                            "Joining the streams",
                            style: TextStyle(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 24),
                          SpinKitCircle(color: AppColors.green, size: 35.0),
                          const SizedBox(height: 24),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              "Channel: ${widget.channelName}",
                              style: const TextStyle(
                                color: Colors.white70,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

              // Additional remote videos (PiP style)
              if (_remoteUids.length > 1)
                Positioned(
                  top: 16,
                  right: 16,
                  child: GestureDetector(
                    onTap: () {
                      // Swap main view with PiP view
                      setState(() {
                        final temp = _remoteUids[0];
                        _remoteUids[0] = _remoteUids[1];
                        _remoteUids[1] = temp;
                      });
                    },
                    child: Container(
                      width: 120,
                      height: 160,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 5,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      clipBehavior: Clip.hardEdge,
                      child: AgoraVideoView(
                        controller: VideoViewController.remote(
                          rtcEngine: _engine,
                          canvas: VideoCanvas(uid: _remoteUids[1]),
                          connection: RtcConnection(
                            channelId: widget.channelName,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

              // Stream information banner (only show briefly or when controls visible)
              if (_remoteUids.isNotEmpty && _isControlsVisible)
                Positioned(
                  top: 16.h,
                  left: 16.w,
                  child: AnimatedOpacity(
                    opacity: _isControlsVisible ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 200),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            "LIVE",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            "${_remoteUids.length} viewer${_remoteUids.length > 1 ? 's' : ''}",
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 12,
                            ),
                          ),
                          Column(children: []),
                        ],
                      ),
                    ),
                  ),
                ),

              // Video controls (only show when _isControlsVisible is true)
              if (_remoteUids.isNotEmpty)
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: AnimatedOpacity(
                    opacity: _isControlsVisible ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 200),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            Colors.black.withOpacity(0.8),
                            Colors.transparent,
                          ],
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Text Field
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: TextField(
                              controller: _commentController,
                              style: const TextStyle(color: Colors.white),
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: "Type a message...",
                                hintStyle: TextStyle(color: Colors.white70),
                              ),
                              onSubmitted: (value) {
                                if (value.trim().isEmpty) return;
                                CommentService.sendComment(
                                  context: context,
                                  token: widget.loginResponse.token,
                                  channelName: widget.channelName,
                                  comment: value.trim(),
                                );
                                _commentController.clear();
                              },
                            ),
                          ),
                          const SizedBox(height: 10),
                          // Control Buttons
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              IconButton(
                                icon: Icon(
                                  _isMuted ? Icons.volume_off : Icons.volume_up,
                                  color: Colors.white,
                                  size: 28,
                                ),
                                onPressed: _toggleMute,
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.thumb_up,
                                  color: Colors.white,
                                  size: 28,
                                ),
                                onPressed: () {
                                  LikeService.likeStream(
                                    context: context,
                                    token: widget.loginResponse.token,
                                    channelName: widget.channelName,
                                  );
                                },
                              ),

                              IconButton(
                                icon: const Icon(
                                  Icons.thumb_down,
                                  color: Colors.white,
                                  size: 28,
                                ),
                                onPressed: () {
                                  DislikeService.dislikeStream(
                                    context: context,
                                    token: widget.loginResponse.token,
                                    channelName: widget.channelName,
                                  );
                                },
                              ),

                              IconButton(
                                icon: const Icon(
                                  Icons.call_end,
                                  color: Colors.red,
                                  size: 28,
                                ),
                                onPressed: () async {
                                  await LeaveService.leaveStream(
                                    context: context,
                                    token: widget.loginResponse.token,
                                    channelName: widget.channelName,
                                  );
                                  Navigator.pop(context);
                                },
                              ),

                              IconButton(
                                icon: const Icon(
                                  Icons.block,
                                  color: Colors.red,
                                  size: 28,
                                ),
                                onPressed: () {
                                  if (_remoteUids.isNotEmpty) {
                                    BlockService.blockUser(
                                      context: context,
                                      token: widget.loginResponse.token,
                                      channelName: widget.channelName,
                                      remoteUid: _remoteUids[0],
                                    );
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('⚠️ No user to block.'),
                                        backgroundColor: Colors.orange,
                                      ),
                                    );
                                  }
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
