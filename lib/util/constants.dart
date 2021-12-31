class AppConstants {
  static const String sendbirdAppID = '7B3D3223-0109-4478-8461-62731F2D1AD2';
  static const String sendbirdApiToken =
      'e7d3659fe2eb0c5bad9468a66eb77b30e6408223';

  static const String unknownException = 'An unknown exception occurred.';
  static const String signinSuccess = 'Welcome back ';
  static const String signupSuccess = 'Signup Successfully';
  static const String signOutSuccess = 'Goodbye!';

  static const String hintUsername = 'username';
  static const String hintEmail = "youremail@abc.xyz";
  static const String hintPassword = "********";

  static const String textSignin = "Signin";
  static const String textSignup = "Signup";
  static const String textForgotPassword = 'Forgot?';

  static const String errorAuthSendbird = "Can't connect to Sendbird...";
  static const String errorGetChatList = "Can't load the chat list...";

  static const String textMessage = "Message";
  static const String textContact = "Contact";
  static const String textSetting = "Setting";
  static const String textAllChat = 'All Chat';
  static const String textReceivedNewMessage = 'You have new messages!';
}

class SignInConstants {
  static const String emailIsEmpty = 'Email cannot be empty!';
  static const String passwordIsEmpty = 'Password cannot be empty';
  static const String emailNotValid = 'Email is not valid';
  static const String passwordNotValid = 'Password is not valid';
  static const String submissionInProgress = 'Signing you in...';
  static const String submissionSuccess = '';
  static const String submissionFailure = 'Something wrong...';
}

class SignupConstants {
  static const String usernameIsEmpty = 'Username cannot be empty';

  static const String submissionInProgress = 'Creating your account...';
}

class SendbirdConstants {
  static const String textIdentifierChatList = 'chat-list-bloc';
  static const String textIdentifierChatDetail = 'chat-detail-bloc';
  static const String textDefaultUsername = 'someone';
}

class ChatConstants {
  static const String textNewFileMessage = 'file message';
  static const String textDefaultGroupChatName = 'Group chat';
}
