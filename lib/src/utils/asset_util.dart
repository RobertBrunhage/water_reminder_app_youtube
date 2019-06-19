class AssetUtil {
  static String assetImage(int amount) {
    switch (amount) {
      case 100:
        return 'assets/100ml.png';
      case 200:
        return 'assets/200ml.png';
      case 300:
        return 'assets/300ml.png';
      case 400:
        return 'assets/400ml.png';
      case 500:
        return 'assets/500ml.png';
      default:
        return 'assets/custom_ml.png';
    }
  }
}
