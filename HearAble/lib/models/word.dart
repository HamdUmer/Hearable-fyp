class Word {
  final String word;
  final String video;

  Word({required this.word, required this.video});

  factory Word.fromJson(Map<String, dynamic> json) {
    return Word(word: json['word'], video: json['video']);
  }
}
