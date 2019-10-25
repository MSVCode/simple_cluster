// class UnableToConnectException implements Exception {
//   String message() => "Unable to connect. Please check your internet.";
// }

// void main(){
//   try {
//     run();
//   } catch (e){
//     print(e.message());
//   }
// }

// void run(){
//   throw Exception("waaa");
// }

// class CustomException implements Exception {
//   String _message;

//   String get message {
//     return _message;
//   }

//   CustomException([this._message = "Error message."]);
// }

// class UnableToConnectException extends CustomException {
//   String _message = "Unable to connect. Please check your internet.";
// }

// void main(){
//   try {
//     run();
//   } catch (e){
//     print(e.message);
//   }
// }

// void run(){
//   throw UnableToConnectException();//work, show Unable to connect. Please check your internet.
//   throw UnableToConnectException("wa");//not
//   throw CustomException();//work, show Error message.
//   throw CustomException("wa");//work, show wa
// }

void main(){
  String img = '<img src="https://github.com/flutter/website/raw/master/src/images/homepage/reflectly-hero-600px.png" alt="Reflectly hero image" style="max-width:100%;">';

  RegExp regExp = RegExp(r'<img.*src="(.*?)".*>');

  Match match = regExp.firstMatch(img);
  print(match.group(1));
}
