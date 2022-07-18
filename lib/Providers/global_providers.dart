import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gyroscope_card/Providers/gyroscope_data_provider.dart';

final gyroscopeDataproviderProvider =
    ChangeNotifierProvider<GyroscopeDataProvider>((ref) {
  return GyroscopeDataProvider();
});
