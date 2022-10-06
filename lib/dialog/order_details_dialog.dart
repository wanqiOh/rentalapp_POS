import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:rentalapp_pos/base_helper/app_utils.dart';
import 'package:rentalapp_pos/global/globals.dart' as globals;
import 'package:rentalapp_pos/model/view_model/order_item.dart';

class OrderDetailsDialog extends StatefulWidget {
  OrderItem order;
  OrderDetailsDialog({this.order});

  @override
  _OrderDetailsDialogState createState() => _OrderDetailsDialogState();
}

class _OrderDetailsDialogState extends State<OrderDetailsDialog> {
  // @override
  // void initState() {
  //   getInvoiceUrl(widget.order);
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    // print('url: ${widget.order.fileUrl}');
    return WillPopScope(
      onWillPop: () async => true,
      child: AlertDialog(
        elevation: 10,
        content: SingleChildScrollView(
          reverse: true,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                  globals.currentLoginUser.role == 'Merchant'
                      ? widget.order.customer.name.toUpperCase()
                      : widget.order.id.toUpperCase(),
                  style: TextStyle(
                      fontSize:
                          globals.currentLoginUser.role == 'Merchant' ? 20 : 15,
                      fontWeight: FontWeight.bold)),
              globals.currentLoginUser.role == 'Merchant'
                  ? Text(
                      widget.order.customer.phoneNo,
                      style:
                          TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                    )
                  : Container(),
              globals.currentLoginUser.role == 'Merchant'
                  ? Center(
                      child: Text(
                        '${widget.order.destination.address1}, ${widget.order.destination.address2}',
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                    )
                  : Container(),
              globals.currentLoginUser.role == 'Merchant'
                  ? Center(
                      child: Text(
                        '${widget.order.destination.city}, ${widget.order.destination.postcode}, ${widget.order.destination.state}',
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                    )
                  : Container(),
              SizedBox(
                  height:
                      globals.currentLoginUser.role == 'Merchant' ? 30 : 10),
              Text(
                  formatPrice(globals.currentLoginUser.role == 'Merchant'
                      ? widget.order.getTotalRentChargeForMerchant()
                      : widget.order.getProfit()),
                  style: TextStyle(fontSize: 15)),
              SizedBox(
                  height:
                      globals.currentLoginUser.role == 'Merchant' ? 20 : 10),
              globals.currentLoginUser.role == 'Merchant'
                  ? Text('Order ID: ${widget.order.id}',
                      style: TextStyle(fontSize: 10))
                  : Container(),
              Text(DateFormat('dd-MMM-yyyy').format(widget.order.createdDate),
                  style: TextStyle(fontSize: 10)),
              Text('Order Status: ${widget.order.orderStatus}',
                  style: TextStyle(fontSize: 10)),
              SizedBox(
                  height:
                      globals.currentLoginUser.role == 'Merchant' ? 20 : 10),
              globals.currentLoginUser.role == 'Admin'
                  ? Row(children: [
                      Expanded(
                        child: Text('Customer',
                            style: TextStyle(
                                fontSize: 13, fontWeight: FontWeight.bold)),
                      ),
                      Expanded(
                        child: Text(
                          '${widget.order.title} ${widget.order.customer.name}',
                          style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ])
                  : Container(),
              globals.currentLoginUser.role == 'Admin'
                  ? SizedBox(height: 5)
                  : Container(),
              globals.currentLoginUser.role == 'Admin'
                  ? Row(children: [
                      Expanded(
                        flex: 1,
                        child: Text('Contact No',
                            style: TextStyle(
                                fontSize: 13, fontWeight: FontWeight.bold)),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(
                          widget.order.customer.phoneNo,
                          style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ])
                  : Container(),
              globals.currentLoginUser.role == 'Admin'
                  ? SizedBox(height: 5)
                  : Container(),
              globals.currentLoginUser.role == 'Admin'
                  ? Row(children: [
                      Expanded(
                          child: Text('Destination',
                              style: TextStyle(
                                  fontSize: 13, fontWeight: FontWeight.bold))),
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            '${widget.order.destination.address1}, ${widget.order.destination.address2}, ${widget.order.destination.city}, ${widget.order.destination.postcode}, ${widget.order.destination.state}',
                            style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ])
                  : Container(),
              SizedBox(
                  height:
                      globals.currentLoginUser.role == 'Merchant' ? 20 : 10),
              globals.currentLoginUser.role == 'Admin'
                  ? Row(children: [
                      Expanded(
                        child: Text('Merchant',
                            style: TextStyle(
                                fontSize: 13, fontWeight: FontWeight.bold)),
                      ),
                      Expanded(
                        child: Text(
                          widget.order.merchant.companyName,
                          style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ])
                  : Container(),
              globals.currentLoginUser.role == 'Admin'
                  ? SizedBox(height: 5)
                  : Container(),
              globals.currentLoginUser.role == 'Admin'
                  ? Row(children: [
                      Expanded(
                        flex: 1,
                        child: Text('Contact No',
                            style: TextStyle(
                                fontSize: 13, fontWeight: FontWeight.bold)),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(
                          widget.order.merchant.phoneNo,
                          style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ])
                  : Container(),
              globals.currentLoginUser.role == 'Admin'
                  ? SizedBox(height: 5)
                  : Container(),
              globals.currentLoginUser.role == 'Admin'
                  ? Row(children: [
                      Expanded(
                          child: Text('Location',
                              style: TextStyle(
                                  fontSize: 13, fontWeight: FontWeight.bold))),
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            '${widget.order.merchant.address.address1}, ${widget.order.merchant.address.address2}, ${widget.order.merchant.address.city}, ${widget.order.merchant.address.postcode}, ${widget.order.merchant.address.state}',
                            style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ])
                  : Container(),
              SizedBox(
                  height:
                      globals.currentLoginUser.role == 'Merchant' ? 20 : 10),
              Row(children: [
                Text('Renting Date',
                    style:
                        TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      widget.order.getDate(),
                      style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ]),
              SizedBox(height: 10),
              Row(children: [
                Text('Renting Days',
                    style:
                        TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      '${widget.order.getDifference()} days',
                      style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ]),
              SizedBox(height: 10),
              Row(children: [
                Text('Renting Machine',
                    style:
                        TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      widget.order.machine.machineCategory,
                      style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ]),
              SizedBox(height: 10),
              Row(children: [
                Text('Machine Model',
                    style:
                        TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      widget.order.machine.machineName,
                      style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ]),
              SizedBox(height: 10),
              Row(children: [
                Text('Renting Quantity',
                    style:
                        TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      widget.order.orderQuantity.toString(),
                      style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ]),
              SizedBox(height: 10),
              Row(children: [
                Text('Renting Price',
                    style:
                        TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      formatPrice(widget.order.machine.price.dailyRate),
                      style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ]),
              SizedBox(height: 10),
              Row(children: [
                Text('Total Delivery Distance',
                    style:
                        TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      '${widget.order.totalDistance} km',
                      style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ]),
              SizedBox(height: 10),
              Row(children: [
                Text('Delivery Charge',
                    style:
                        TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      '${formatPrice(widget.order.machine.price.deliveryCharge)} per km',
                      style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ]),
              SizedBox(height: 10),
              Row(children: [
                Text('Total Delivery Charge',
                    style:
                        TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      formatPrice(widget.order.getDeliveryCharge()),
                      style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ]),
              SizedBox(height: 10),
              Row(children: [
                Text('Total Renting Price',
                    style:
                        TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      formatPrice(
                          widget.order.getTotalRentingPriceForMerchant()),
                      style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ]),
              SizedBox(height: 10),
              Row(children: [
                Text('Tax Charge',
                    style:
                        TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      formatPrice(widget.order.getTaxChargeForMerchant()),
                      style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ]),
              SizedBox(height: 10),
              Row(children: [
                Text('Total Renting Charge',
                    style:
                        TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      formatPrice(widget.order.getTotalRentChargeForMerchant()),
                      style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ]),
              globals.currentLoginUser.role == 'Admin'
                  ? SizedBox(height: 10)
                  : Container(),
              globals.currentLoginUser.role == 'Admin'
                  ? Row(children: [
                      Text('Amount Paid to Merchant',
                          style: TextStyle(
                              fontSize: 13, fontWeight: FontWeight.bold)),
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            formatPrice(
                                widget.order.getTotalRentChargeForMerchant()),
                            style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ])
                  : Container(),
              // SizedBox(height: 10),
              // if (widget.order.paymentStatus == 'DEPOSIT PAYMENT')
              //   Row(children: [
              //     Text('Fixed Deposit Paid',
              //         style:
              //             TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
              //     Expanded(
              //       child: Align(
              //         alignment: Alignment.centerRight,
              //         child: Text(
              //           formatPrice(widget.order.balance),
              //           style: TextStyle(
              //               fontSize: 13,
              //               color: Colors.grey,
              //               fontWeight: FontWeight.bold),
              //         ),
              //       ),
              //     ),
              //   ]),
              // if (widget.order.paymentStatus == 'DEPOSIT PAYMENT')
              //   SizedBox(height: 10),
              // if (widget.order.paymentStatus == 'DEPOSIT PAYMENT')
              //   Row(children: [
              //     Text('Balance Price',
              //         style:
              //             TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
              //     Expanded(
              //       child: Align(
              //         alignment: Alignment.centerRight,
              //         child: Text(
              //           formatPrice((widget.order.getTotalRentCharge() -
              //               widget.order.amountPaid)),
              //           style: TextStyle(
              //               fontSize: 13,
              //               color: Colors.grey,
              //               fontWeight: FontWeight.bold),
              //         ),
              //       ),
              //     ),
              //   ]),
              // if (widget.order.paymentStatus == 'FULL PAYMENT')
              // Row(children: [
              //   Text('Amount Paid',
              //       style:
              //           TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
              //   Expanded(
              //     child: Align(
              //       alignment: Alignment.centerRight,
              //       child: Text(
              //         formatPrice(widget.order.getTotalRentCharge()),
              //         style: TextStyle(
              //             fontSize: 13,
              //             color: Colors.grey,
              //             fontWeight: FontWeight.bold),
              //       ),
              //     ),
              //   ),
              // ]),
              SizedBox(height: 10),
              globals.currentLoginUser.role == 'Admin' &&
                      (widget.order.orderStatus == 'COMPLETE' ||
                          widget.order.orderStatus == 'PLACED')
                  ? TextButton(
                      onPressed: () {
                        launchURL(widget.order.fileUrl);
                      },
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.orange)),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        child: Center(
                            child: Text(
                          'VIEW INVOICE',
                          style: TextStyle(color: Colors.white),
                        )),
                      ),
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }

  // Future<void> getInvoiceUrl(OrderItem order) async {
  //   print('ID: ${order.id}');
  //   await FirestoreService.filterInvoice('orderID', order.id)
  //       .get()
  //       .then((value) {
  //     value.docs.map((element) {
  //       print('invoice: ${element.get('url')}');
  //     }).toList();
  //   });
  // }
}
