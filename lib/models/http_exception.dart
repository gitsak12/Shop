class HttpException implements Exception{
late final String message;
HttpException(this.message);

@override
  String toString() {
  return message;
    // TODO: implement toString
    //return super.toString();
  }
}
//Instance of