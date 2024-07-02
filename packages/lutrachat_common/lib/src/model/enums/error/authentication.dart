/// Errors that occur in authentication related components.
enum AuthenticationError {
  /// The name or mail is already being used by another user.
  credentialsAlreadyTaken,

  /// Incorrect email or password passed when logging in.
  invalidCredentials
}
