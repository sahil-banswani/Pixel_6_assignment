

import 'package:project_pixel_6/models/app_state.dart';
import 'package:project_pixel_6/reducer/custom_reducer.dart';

AppState appReducer(AppState state, dynamic action) {
  return AppState(
    customers: customerReducer(state.customers, action),
  );
}
