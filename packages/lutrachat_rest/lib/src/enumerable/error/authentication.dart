/// Error codes that may occur during authentication.
enum AuthenticationErrorCode {
  /// The name or mail is already being used by another user.
  credentialsAlreadyTaken,

  /// Incorrect email or password passed when logging in.
  invalidCredentials
}
