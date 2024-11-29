String getBackgroundImage() {
  int hour = DateTime.now().hour;
  if (hour >= 6 && hour < 12) {
    return 'lib/assets/images/day.jpg';
  } else if (hour >= 12 && hour < 18) {
    return 'lib/assets/images/noon.jpg';
  } else {
    return 'lib/assets/images/night.jpg';
  }
}
