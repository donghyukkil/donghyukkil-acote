import 'package:url_launcher/url_launcher.dart';

Future<void> launchUrlHelper(String url) async {
  final urlParse = Uri.parse(url);

  if (await canLaunchUrl(urlParse)) {
    await launchUrl(urlParse);
  } else {
    throw 'Could not launch $url';
  }
}
