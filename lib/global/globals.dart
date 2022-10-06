library rentalapp_pos.globals;

import 'package:rentalapp_pos/model/view_model/merchant.dart';
import 'package:rentalapp_pos/model/view_model/notification_item.dart';
import 'package:rentalapp_pos/model/view_model/order_item.dart';
import 'package:rentalapp_pos/model/view_model/user.dart';

UserRentalApp currentLoginUser;

String id;

OrderItem order;

List<NotificationsItem> notifications = [];

Merchant merchant;

double dailyRate = 0.7;
double weeklyRate = 0.5;
double halfMonthlyRate = 0.3;
double monthlyRate = 0.1;

double tax = 0.06;
