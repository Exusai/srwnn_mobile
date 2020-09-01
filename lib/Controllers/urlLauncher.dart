import 'package:url_launcher/url_launcher.dart';

Uri _emailLaunchUri = Uri(
  scheme: 'mailto',
  path: 'a.a.r.samuel99@gmail.com',
  queryParameters: {
    'subject': 'SRWNN'
  }
);

launchURL(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

launchMail() async {
  await launch(_emailLaunchUri.toString());
}

