import 'package:quran/quran.dart' as quran;

void main() {
  print('Page 603 Data: ${quran.getPageData(603)}');
  print('Page 604 Data: ${quran.getPageData(604)}');
  print('Page of Surah 114: ${quran.getPageNumber(114, 1)}');
}
