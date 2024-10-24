class Surah {
  final int number; 
  final String nameArabic;
  final String englishName;
  final int numberOfAyahs;
  final String audioUrl; 

  Surah({
    required this.number,
    required this.nameArabic,
    required this.englishName,
    required this.numberOfAyahs,
    required this.audioUrl, 
  });

  factory Surah.fromJson(Map<String, dynamic> json) {
    return Surah(
      number: json['number'] ?? 0,
      nameArabic: json['name'] ?? '',
      englishName: json['englishName'] ?? '',
      numberOfAyahs: json['numberOfAyahs'] ?? 0,
      audioUrl: json['audio'] ?? '', 
    );
  }
}
