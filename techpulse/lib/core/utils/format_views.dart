String formatViews(int views) {
  if (views >= 1000000) {
    return '${(views / 1000000).toStringAsFixed(1)}M';
  } else if (views >= 1000) {
    return '${(views / 1000).toStringAsFixed(1)}K';
  }
  return '$views';
}
