class Endpoints {
  static const String apiVersion = '/api/v1';

  // Auth endpoints
  static const String authLogin = '$apiVersion/auth/login';
  static const String authSignup = '$apiVersion/auth/signup';
  static const String authRefresh = '$apiVersion/auth/refresh';
  static const String authLogout = '$apiVersion/auth/logout';

  // User endpoints
  static const String userProfile = '$apiVersion/users/me';

  // Course endpoints
  static const String courses = '$apiVersion/courses';
  static String courseByCode(String code) => '$courses/$code';
  static const String coursesImport = '$courses/import';

  // Wishlist endpoints
  static const String wishlist = '$apiVersion/wishlist';
  static String wishlistCheck(int courseId) => '$wishlist/check/$courseId';
  static String wishlistRemove(int courseId) => '$wishlist/$courseId';

  // Timetable endpoints
  static const String timetables = '$apiVersion/timetables';
  static String timetable(int id) => '$timetables/$id';
  static String timetableAlternatives(int id) => '$timetables/$id/alternatives';
  static String timetableAddCourse(int id) => '$timetables/$id/courses';
  static String timetableRemoveCourse(int timetableId, int courseId) =>
      '$timetables/$timetableId/courses/$courseId';

  // Scenario endpoints
  static const String scenarios = '$apiVersion/scenarios';
  static String scenario(int id) => '$scenarios/$id';
  static String scenarioTree(int id) => '$scenarios/$id/tree';
  static String scenarioChildren(int id) => '$scenarios/$id/children';
  static String scenarioAlternative(int parentId) =>
      '$scenarios/$parentId/alternatives';
  static String scenarioNavigate(int id) => '$scenarios/$id/navigate';

  // Registration endpoints
  static const String registrations = '$apiVersion/registrations';
  static String registration(int id) => '$registrations/$id';
  static String registrationSteps(int id) => '$registrations/$id/steps';
  static String registrationComplete(int id) => '$registrations/$id/complete';
  static String registrationSucceededCourses(int id) =>
      '$registrations/$id/succeeded-courses';
}
