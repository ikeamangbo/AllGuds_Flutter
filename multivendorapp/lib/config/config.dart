class Config {
  static const String cloudinaryUploadUrl =
      'https://api.cloudinary.com/v1_1/dkqxlkrld/image/upload';
  static const String cloudinaryCloudName = 'dkqxlkrld';
  static const String cloudinaryApiKey =
      '123456789012345'; // Replace with your API key
  static const String cloudinaryUploadPreset =
      'allguds'; // Replace with your upload preset

  static Future<String> generateSignature(int timestamp, String folder) async {
    // Implement signature generation if needed
    return '';
  }
}
