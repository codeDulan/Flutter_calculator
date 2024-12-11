
//IM/2021/025 - Samarasingha D.A


import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'dart:async';

import 'buttons.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
      ),
      home: const MyHomePage(title: 'Calculator'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var userQuestion = '';
  var userAnswer = '';
  bool isResultDisplayed = false;
  bool showCursor = true;
  String errorMessage = '';
  final List<String> history = [];
  bool isEvaluated = false;

  final List<dynamic> buttons = [
    'C',
    Icons.backspace,
    '%',
    '÷',
    '7',
    '8',
    '9',
    'x',
    '4',
    '5',
    '6',
    '-',
    '1',
    '2',
    '3',
    '+',
    '0',
    '.',
    '√',
    '='
  ];

  //This is where the blinking cursor handled
  @override
  void initState() {
    super.initState();
    Timer.periodic(const Duration(milliseconds: 500), (timer) {
      setState(() {
        showCursor = !showCursor;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text("Calculator"), // this is where the main app bar handled
        actions: [

          //history button functionality
          IconButton(
            icon: const Icon(Icons.history), // this is the history button and it's design
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    backgroundColor: Colors.grey[900],
                    title: const Text(
                      "History",
                      style: TextStyle(color: Colors.white),
                    ),
                    content: SizedBox(
                      width: double.maxFinite,
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: history.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(
                              history[index],
                              style: const TextStyle(color: Colors.white),
                            ),
                          );
                        },
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text(
                          "Close",
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            history.clear();
                          });
                          Navigator.of(context).pop();
                        },
                        child: const Text(
                          "Clear History",
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  );
                },
              );
            },
          ),


          //additional math operations like ^, ()
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: (value) {
              setState(() {
                userQuestion += value;
              });
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: '(', child: Text('(')),
              const PopupMenuItem(value: ')', child: Text(')')),
              const PopupMenuItem(value: '^', child: Text('^')),
            ],
          ),
        ],
      ),



      body: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(20),
                    alignment: Alignment.centerRight,
                    child: Stack(
                      alignment: Alignment.centerRight,
                      children: [

                        //this is where that seamless user input handled
                        AutoSizeText(
                          userQuestion,
                          style: const TextStyle(
                              fontSize: 40, color: Colors.white),
                          maxLines: 1,
                        ),


                        if (showCursor)
                          Positioned(
                            right: 0,
                            child: Container(
                              width: 2,
                              height: 40,
                              color: Colors.grey[600],
                            ),
                          ),
                      ],
                    ),
                  ),

                  //this is the place that showes the answer of a operation
                  Container(
                    padding: const EdgeInsets.all(20),
                    alignment: Alignment.centerRight,
                    child: Flexible(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: AutoSizeText(
                          userAnswer,
                          style: TextStyle(
                            fontSize: 25,
                            color:
                                isResultDisplayed ? Colors.white : Colors.grey,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow
                              .ellipsis, // Ensure it truncates if still too long
                        ),
                      ),
                    ),
                  ),

                  //=============this is where invalid operation shows=====================
                  if (errorMessage.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Text(
                        errorMessage,
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),


          //======================this is where the number pad designed======================
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: GridView.builder(
                itemCount: buttons.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  mainAxisSpacing: 0,
                  crossAxisSpacing: 0,
                ),
                itemBuilder: (BuildContext context, int index) {

                  //========this is the place that button functionalities handled=================
                  if (buttons[index] == 'C') {
                    return MyButton(
                      buttonTapped: () {
                        setState(() {
                          userQuestion = '';
                          userAnswer = '';
                          errorMessage = '';
                          isResultDisplayed = false;
                        });
                      },
                      color: Colors.grey[900],
                      textColor: Colors.redAccent,
                      content: buttons[index],
                    );


                  } else if (buttons[index] == Icons.backspace) {
                    return MyButton(
                      buttonTapped: () {
                        setState(() {
                          errorMessage = '';
                          if (userQuestion.isNotEmpty) {
                            userQuestion = userQuestion.substring(
                                0, userQuestion.length - 1);
                          }
                          userAnswer = calculateAnswer(userQuestion);
                        });
                      },
                      color: Colors.grey[900],
                      textColor: Colors.redAccent,
                      content: buttons[index],
                    );


                  } else {

                    return MyButton(
                      buttonTapped: () {
                        setState(() {

                          if (buttons[index] == '=') {
                            equalPressed();
                            isEvaluated = true;


                          } else if (buttons[index] == '√') {
                            setState(() {
                              if (userQuestion.isEmpty) {
                                // Allow square root at the start
                                userQuestion += '√(';
                              } else {
                                String lastChar =
                                    userQuestion[userQuestion.length - 1];

                                if (lastChar == '√') {
                                  // Avoid consecutive square roots
                                  return;
                                }

                                if (isOperator(lastChar)) {
                                  // Allow square root after operators or '('
                                  userQuestion += '√(';
                                } else if (RegExp(r'\d|\)')
                                    .hasMatch(lastChar)) {
                                  // Insert multiplication before square root if preceded by a number or ')'
                                  userQuestion += 'x√(';
                                }
                              }
                            });


                          } else if (buttons[index] == '.') {
                            // Validate the placement of the decimal point
                            if (userQuestion.isNotEmpty &&
                                !userQuestion.endsWith('.') &&
                                !isOperator(
                                    userQuestion[userQuestion.length - 1])) {
                              userQuestion += '.';
                            } else if (userQuestion.isEmpty) {
                              // Allow starting a number with '0.'
                              userQuestion += '0.';
                            }

                          //=================place where handle after = button new number press, star as a fresh operation
                          }else if (isEvaluated) {
                            if (RegExp(r'^\d+$').hasMatch(buttons[index].toString())) {
                              // If a number is pressed after '=', start fresh
                              userQuestion = buttons[index].toString();
                              userAnswer = '';
                              isEvaluated = false;
                            } else if (isOperator(buttons[index])) {
                              // If an operator is pressed after '=', continue with the result
                              if (userAnswer.isNotEmpty) {
                                userQuestion = userAnswer + buttons[index].toString();
                              } else if (userQuestion.isNotEmpty) {
                                userQuestion += buttons[index].toString(); // Handle edge case
                              }
                              userAnswer = '';
                              isEvaluated = false;
                            }
                          }
                          else {



                            if (isOperator(buttons[index])) {
                              // Allow '-' at the very start or after '('
                              if (buttons[index] == '-' &&
                                  (userQuestion.isEmpty ||
                                      userQuestion.endsWith('('))) {
                                userQuestion += buttons[index];
                                return;
                              }


                              // Prevent consecutive operators
                              if (userQuestion.isEmpty ||
                                  isOperator(
                                      userQuestion[userQuestion.length - 1])) {
                                return;
                              }
                            }

                            userQuestion += buttons[index].toString();
                          }
                          userAnswer = calculateAnswer(userQuestion);
                        });
                      },
                      content: buttons[index],
                      color: isOperator(buttons[index])
                          ? Colors.grey[850]
                          : Colors.grey[800],
                      textColor: isOperator(buttons[index])
                          ? Colors.white
                          : Colors.grey[300],
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool isOperator(dynamic x) {
    return x == '%' || x == 'x' || x == '-' || x == '+' || x == '÷' || x == '=' || x == '√';
  }

  String calculateAnswer(String question) {
    if (question.isEmpty || isOperator(question[question.length - 1])) {
      return '';
    }

    String finalQuestion = question
        .replaceAll('x', '*') // Replace 'x' with '*'
        .replaceAll('÷', '/') // Replace '÷' with '/'
        .replaceAllMapped(RegExp(r'√\(([^)]+)\)'), (match) {
      // Replace '√(...)' with 'sqrt(...)'
      return 'sqrt(${match.group(1)})';
    });

    //================this is where dividing 0 valdiations happend=================
    if (finalQuestion.contains('/0')) {
      if (finalQuestion.contains('0/0')) {
        return "Can't divide by 0";
      }else {
        return "Can't divide by 0";
      }

    }

    try {
      Parser p = Parser();
      Expression exp = p.parse(finalQuestion);
      ContextModel cm = ContextModel();
      double eval = exp.evaluate(EvaluationType.REAL, cm);
      return _formatAnswer(eval);
    } catch (e) {
      return '';
    }
  }

  //=============this is where the answer clears the .0 in answer===========
  String _formatAnswer(double eval) {
    String result = eval.toString();
    if (result.contains('.')) {
      result = result.replaceAll(RegExp(r"([.]*0)(?!.*\d)"), "");
    }
    return result;
  }

  void equalPressed() {
    if (userQuestion.isEmpty || isOperator(userQuestion[userQuestion.length - 1])) {
      return;
    }

    String finalQuestion = userQuestion
        .replaceAll('x', '*') // Replace 'x' with '*'
        .replaceAll('÷', '/') // Replace '÷' with '/'
        .replaceAllMapped(RegExp(r'√\(([^)]+)\)'), (match) {
      // Replace '√(...)' with 'sqrt(...)'
      return 'sqrt(${match.group(1)})';
    });

    // Check for division by zero
    if (finalQuestion.contains('/0')) {
      setState(() {
        if (finalQuestion.contains('0/0')) {
          userAnswer = "Can't divide by 0"; // Handle 0/0
        } else {
          userAnswer = "Can't divide by 0"; // Handle number/0
        }
        errorMessage = ''; // Clear any previous error messages
      });
      return;
    }

    try {
      Parser p = Parser();
      Expression exp = p.parse(finalQuestion);
      ContextModel cm = ContextModel();
      double eval = exp.evaluate(EvaluationType.REAL, cm);
      setState(() {
        userAnswer = _formatAnswer(eval);
        history.add('$userQuestion = $userAnswer');
        userQuestion = userAnswer; // Set the result as the new input
        isResultDisplayed = true;

        // Clear the answer after a short delay
        Timer(const Duration(milliseconds: 0), () {
          setState(() {
            userAnswer = ''; // Clear the answer
          });
        });
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Invalid Expression';
        userAnswer = '';
      });
    }
  }

}
