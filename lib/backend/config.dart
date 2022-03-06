class Config {
  static const String apiScheme = "https";
  static const String apiHost = "gdsc-issue-tracker-api.herokuapp.com";

  static Uri uri(String path) => Uri(
        scheme: apiScheme,
        host: apiHost,
        path: path,
      );
}
