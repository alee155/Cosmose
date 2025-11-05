import 'package:cosmose/models/login_response.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';

class WebViewScreen extends StatelessWidget {
  final LoginResponse loginResponse;

  WebViewScreen({super.key, required this.loginResponse}) {

    final controller = Get.put(WebViewGetXController());
    controller.setToken(loginResponse.token);
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<WebViewGetXController>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text("Cosmose Relay Point"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Obx(() => controller.progress.value < 1.0
              ? LinearProgressIndicator(
                  value: controller.progress.value, minHeight: 3)
              : SizedBox.shrink()),
          Expanded(
            child: InAppWebView(
              initialUrlRequest: URLRequest(url: WebUri(controller.url)),
              onWebViewCreated: (webController) {
                controller.setWebViewController(webController);
              },
              onProgressChanged: (webController, newProgress) {
                controller.updateProgress(newProgress);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class WebViewGetXController extends GetxController {
  late InAppWebViewController webViewController;

  var progress = 0.0.obs;
  late String url;

  void setToken(String token) {
    url = "https://cosmoseworld.fr/relaypoint/$token";
    print("**********************🚀 Token**********************: $token");
    print("**********************🌍 URL**********************: $url");
  }

  void setWebViewController(InAppWebViewController controller) {
    webViewController = controller;
  }

  void updateProgress(int newProgress) {
    progress.value = newProgress / 100;
  }
}
