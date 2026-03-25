import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../models/word.dart';
import 'sign_description_screen.dart';

class SignLibraryScreen extends StatefulWidget {
  const SignLibraryScreen({super.key});

  @override
  SignLibraryScreenState createState() => SignLibraryScreenState();
}

class SignLibraryScreenState extends State<SignLibraryScreen> {
  List<Word> words = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    fetchWords();
  }

  Future<void> fetchWords() async {
    try {
      final response =
          await http.get(Uri.parse('http://192.168.18.28:8000/words')); 
      if (response.statusCode == 200) {
        final List data = json.decode(response.body);
        setState(() {
          words = data.map((e) => Word.fromJson(e)).toList();
          loading = false;
        });
      } else {
        throw Exception('Failed to load words');
      }
    } catch (e) {
      print(e);
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign Library')),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search signs...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.grey[100],
                    ),
                  ),
                ),
                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 0.8,
                    ),
                    itemCount: words.length,
                    itemBuilder: (context, index) {
                      final word = words[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  SignDescriptionScreen(word: word),
                            ),
                          );
                        },
                        child: Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(12),
                                    ),
                                  ),
                                  child: const Icon(
                                    Icons.play_circle_outline,
                                    size: 50,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Text(
                                  word.word,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}













// import 'package:flutter/material.dart';
// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import '../../models/word.dart';
// import 'sign_description_screen.dart';

// class SignLibraryScreen extends StatefulWidget {
//   const SignLibraryScreen({super.key});

//   @override
//     SignLibraryScreenState createState() => SignLibraryScreenState();
// }

// class   SignLibraryScreenState extends State<SignLibraryScreen> {
//   List<Word> words = [];
//   bool loading = true;

//   @override
//   void initState() {
//     super.initState();
//     fetchWords();
//   }

// //   Future<void> fetchWords() async {
// //   setState(() {
// //     loading = true; // show loader while "fetching"
// //   });

// //   await Future.delayed(const Duration(seconds: 1)); // simulate network delay

// //   final data = [
// //     {
// //       "word": "A",
// //       "videos": [
// //       "http://127.0.0.1:8000/videos/a/01610.mp4",
// //       "http://127.0.0.1:8000/videos/a/01611.mp4",
// //       "http://127.0.0.1:8000/videos/a/01612.mp4",
// //       "http://127.0.0.1:8000/videos/a/01615.mp4",
// //       "http://127.0.0.1:8000/videos/a/66039.mp4"
// //       ]
// //     },
    
// //   ];

// //   setState(() {
// //     words = data.map((e) => Word.fromJson(e)).toList();
// //     loading = false;
// //   });
// // }

//   Future<void> fetchWords() async {
//     try {
//       final response = await http.get(Uri.parse('http://192.168.18.28:8000/words')); // Replace with your PC IP
//       if (response.statusCode == 200) {
//         final List data = json.decode(response.body);
//         setState(() {
//           words = data.map((e) => Word.fromJson(e)).toList();
//           loading = false;
//         });
//       } else {
//         throw Exception('Failed to load words');
//       }
//     } catch (e) {
//       print(e);
//       setState(() => loading = false);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Sign Library')),
//       body: loading
//           ? const Center(child: CircularProgressIndicator())
//           : Column(
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: TextField(
//                     decoration: InputDecoration(
//                       hintText: 'Search signs...',
//                       prefixIcon: const Icon(Icons.search),
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       filled: true,
//                       fillColor: Colors.grey[100],
//                     ),
//                   ),
//                 ),
//                 Expanded(
//                   child: GridView.builder(
//                     padding: const EdgeInsets.all(16),
//                     gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                       crossAxisCount: 2,
//                       crossAxisSpacing: 16,
//                       mainAxisSpacing: 16,
//                       childAspectRatio: 0.8,
//                     ),
//                     itemCount: words.length,
//                     itemBuilder: (context, index) {
//                       final word = words[index];
//                       return GestureDetector(
//                         onTap: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (_) => SignDescriptionScreen(word: word),
//                             ),
//                           );
//                         },
//                         child: Card(
//                           elevation: 2,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.stretch,
//                             children: [
//                               Expanded(
//                                 child: Container(
//                                   decoration: BoxDecoration(
//                                     color: Colors.grey[200],
//                                     borderRadius: const BorderRadius.vertical(
//                                       top: Radius.circular(12),
//                                     ),
//                                   ),
//                                   child: const Icon(
//                                     Icons.image,
//                                     size: 50,
//                                     color: Colors.grey,
//                                   ),
//                                 ),
//                               ),
//                               Padding(
//                                 padding: const EdgeInsets.all(12.0),
//                                 child: Text(
//                                   word.word,
//                                   style: const TextStyle(
//                                     fontWeight: FontWeight.bold,
//                                     fontSize: 16,
//                                   ),
//                                   textAlign: TextAlign.center,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//               ],
//             ),
//     );
//   }
// }
