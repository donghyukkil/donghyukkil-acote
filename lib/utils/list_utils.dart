import '../models/github_user.dart';

// Utility to determine if an ad should be inserted at the given index.
bool shouldInsertAd(int index, int adInterval) {
  return index != 0 && (index + 1) % (adInterval + 1) == 0;
}

// Utility to calculate total item count, including ads.
int calculateTotalItemCount(int usersLength, int adInterval) {
  return usersLength + (usersLength ~/ adInterval);
}
