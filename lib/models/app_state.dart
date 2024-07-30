
import 'package:project_pixel_6/models/customer.dart';

class AppState {
  final List<Customer> customers;

  AppState({required this.customers});

  factory AppState.initial() {
    return AppState(customers: []);
  }
}
