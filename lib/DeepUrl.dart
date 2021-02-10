import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';

class DPUrl{
  static  Future<Uri> buildUrl(String type,String p_id,String desc,String title,String url) async{
    DynamicLinkParameters parameter = DynamicLinkParameters(
        uriPrefix: 'https://poshaqin.page.link',
        link:Uri.parse('https://www.saffronitsystems.com/post?title=$title'),
        androidParameters: AndroidParameters(
          packageName: 'com.poshaq.customer',
          minimumVersion:0,
        ),
        iosParameters:  IosParameters(
          bundleId: 'com.saffronitsystems.com',
          minimumVersion: '0',
        ),
        socialMetaTagParameters: SocialMetaTagParameters(
            description: desc,
            title: title,
            imageUrl: Uri.parse(url),
        )
    );
    var u = await parameter.buildShortLink();
    return u.shortUrl;
  }
}
