import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

//Making the localhost ip easily accessible
const String host = "10.0.2.2:8888";

class Question{


  Future<String> getQuestionText() async {
    Uri url = Uri.http(host, '/question');
    var response = await http.get(url);
    //We are grabbing the question text from the api
    //and returning it
    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body) as Map<String, dynamic>;
      String question = jsonResponse['question'];
      return question;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to get question');
    }
  }
  Future<int> getQuestionAnswer() async{
    Uri url = Uri.http(host, '/answer');
    var response = await http.get(url);
    //We are grabbing the answer from the api
    //and returning it
    if(response.statusCode == 200){
      var jsonResponse = convert.jsonDecode(response.body) as Map<String, dynamic>;
      int answer = jsonResponse['answer'];
      return answer;
    }
    return 0;
  }

  Future<bool> isFinished() async {
    Uri url = Uri.http(host, '/finished');
    var response = await http.get(url);
    //If the api is finished, it will return a
    //{"success": true} response, meaning the app is finished
    //otherwise, its not
    if(response.statusCode == 200){
      var jsonResponse = convert.jsonDecode(response.body) as Map<String, dynamic>;
      bool isFinished = jsonResponse['success'];
      return isFinished;
    }
    return true;
    }

  Future<void> reset() async {
    //Sending the "reset" to the api
    Uri url = Uri.http(host, '/reset');
    var response = await http.get(url);
  }

  Future<void> nextQuestion() async {
    //Sending the "nextQuestion" command to the api
    Uri url = Uri.http(host, '/next');
    var response = await http.get(url);
  }
}

