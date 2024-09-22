import '../models/github_user.dart';

List<dynamic> addAdsToUserList(List<GitHubUser> users) {
  List<dynamic> userListWithAds = [];
  int userCount = 0;

  for (int i = 0; i < users.length; i++) {
    userListWithAds.add(users[i]);
    userCount++;

    if (userCount == 9) {
      userListWithAds.add('ad');
      userCount = 0;
    }
  }

  return userListWithAds;
}
