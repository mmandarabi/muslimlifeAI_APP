
import 'package:muslim_mind/services/mushaf_layout_engine.dart';

Future<void> main() async {
  final engine = MushafLayoutEngine();
  final pageHeight = 1050.0;
  final positions = await engine.calculateLinePositions(604, pageHeight);
  
  print('--- Debug Layout Math (Page 604) ---');
  for (int i = 0; i < positions.length; i++) {
    final pos = positions[i];
    print('Line ${i+1}: $pos');
    
    if (i > 0) {
      final prev = positions[i-1];
      if (pos.top < prev.bottom - 0.01) {
        print('!!! OVERLAP DETECTED !!! Line ${i+1} Top (${pos.top}) < Line $i Bottom (${prev.bottom})');
      }
    }
  }
}
