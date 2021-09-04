//In the end, we'll throw this exception when we have some problems with our HTTP requests.

class HttpException implements Exception{
  final String message;

  HttpException(this.message);

  @override
  String toString() {
    return message; //here we want o return our custom exception. That's why we return our message here.
    //return super.toString(); //Instance of HttpException
  }
}