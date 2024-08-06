/// Error codes that may occur during authentication.
enum AuthenticationErrorCode {
  /// Incorrect email or password passed when logging in.
  invalidCredentials,

  /// The name or mail is already being used by another user.
  credentialsAlreadyTaken
}
