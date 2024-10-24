class Ayah {
  final int number;
  final String text;
  late final String audioUrl; 

  Ayah({required this.number, required this.text, required this.audioUrl});

  factory Ayah.fromJson(Map<String, dynamic> json) {
    return Ayah(
      number: json['number'] ?? 0,
      text: json['text'] ?? '',
      
      audioUrl: json['audio'] ?? '',  
    );
  }
}
