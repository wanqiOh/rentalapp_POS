import 'package:easy_localization/easy_localization.dart';
import 'package:rentalapp_pos/global/globals.dart' as globals;
import 'package:rentalapp_pos/model/view_model/address.dart';
import 'package:rentalapp_pos/model/view_model/customer.dart';
import 'package:rentalapp_pos/model/view_model/machine_item.dart';
import 'package:rentalapp_pos/model/view_model/merchant.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class OrderItem {
  String id;
  MachineItem machine;
  Customer customer;
  Position pinPosition;
  Merchant merchant;
  AddressDes destination;
  String paymentStatus;
  String orderStatus;
  DateTime createdDate;
  String totalDistance;
  DateTime startDate;
  DateTime endDate;
  int orderQuantity;
  DateTime sendTime;
  bool clicked;
  String title;
  String notifTitle;
  String content;
  double amountPaid;
  // double balance;
  String fileUrl;
  String reply;

  OrderItem(
      {this.id,
      this.machine,
      this.customer,
      this.pinPosition,
      this.createdDate,
      this.merchant,
      this.destination,
      this.paymentStatus,
      this.totalDistance,
      this.orderStatus,
      this.startDate,
      this.endDate,
      this.orderQuantity,
      this.clicked,
      this.sendTime,
      this.title,
      this.content,
      this.amountPaid,
      this.notifTitle,
      // this.balance,
      this.fileUrl,
      this.reply});

  getDifference() {
    return (endDate.difference(startDate).inDays) + 1;
  }

  getPriceRate() {
    int days = getDifference();
    if (days < 7)
      return globals.dailyRate;
    else if (days >= 7 && days < 15)
      return globals.weeklyRate;
    else if (days >= 15 && days < 25)
      return globals.halfMonthlyRate;
    else
      return globals.monthlyRate;
  }

  getProfit() {
    double rateCharge = getPriceRate();
    return rateCharge * machine.price.dailyRate;
  }

  getRentingPrice() {
    double rateCharge = getPriceRate();
    return (rateCharge + 1) * machine.price.dailyRate;
  }

  getDeliveryCharge() {
    return double.parse(totalDistance) * machine.price.deliveryCharge;
  }

  getTotalRentingPrice() {
    double rentingPrice = getRentingPrice() * orderQuantity;
    double deliveryCharge = getDeliveryCharge();

    return rentingPrice + deliveryCharge;
  }

  getDate() {
    return '${DateFormat('dd/MM/yy').format(startDate)}-${DateFormat('dd/MM/yy').format(endDate)}';
  }

  getTaxCharge() {
    return globals.tax * getTotalRentingPrice();
  }

  getTotalRentCharge() {
    return getTotalRentingPrice() + getTaxCharge();
  }

  // getMinDeposit() {
  //   return getTotalRentCharge() * 0.5;
  // }

  getUpdateQnt() {
    return machine.quantity - orderQuantity;
  }

  getTotalRentingPriceForMerchant() {
    double rentingPrice = machine.price.dailyRate * orderQuantity;
    double deliveryCharge = getDeliveryCharge();

    return rentingPrice + deliveryCharge;
  }

  getTaxChargeForMerchant() {
    return globals.tax * getTotalRentingPriceForMerchant();
  }

  getTotalRentChargeForMerchant() {
    return getTotalRentingPriceForMerchant() + getTaxChargeForMerchant();
  }

// static List<RecommendItem> setPromotionItemList(List<Highlights> list) {
//   list.asMap().forEach((index, item) {
//     promotionItemList.add(
//         PromotionItem(imagePath: item.image, url: item.uri, index: index));
//   });
//
//   return promotionItemList;
// }
}
