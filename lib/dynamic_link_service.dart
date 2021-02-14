import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';

class DynamicLinkService {
  Future handleDynamicLinks() async {
    // get inital dynamic
    final PendingDynamicLinkData data =
        await FirebaseDynamicLinks.instance.getInitialLink();
    _handleDeepLink(data);

    FirebaseDynamicLinks.instance.onLink(
        onSuccess: (PendingDynamicLinkData dynamicLinkData) async {},
        onError: (OnLinkErrorException e) async {
          print('Dynamic Link Faild ${e.message}');
        });
  }

  void _handleDeepLink(PendingDynamicLinkData data) {
    final Uri deepLink = data?.link;
    if (deepLink != null) {
      print("_handleDeepLink | deepLink : $deepLink");
    }
  }
}


