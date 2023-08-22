import 'package:xueba/utils/app_constants.dart';
import 'package:share_plus/share_plus.dart';

void ShareEvent(videoId) {
  Share.share('${AppConstants.URL}${AppConstants.VIDEO}/$videoId/');
}
