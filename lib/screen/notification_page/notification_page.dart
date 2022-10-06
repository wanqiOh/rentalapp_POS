import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rentalapp_pos/app_folder/app_theme.dart';
import 'package:rentalapp_pos/base_helper/app_utils.dart';
import 'package:rentalapp_pos/model/view_model/order_item.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../custom_router.dart';

class NotificationPage extends StatefulWidget {
  List<OrderItem> orders;
  NotificationPage({this.orders});

  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.grey.shade50,
          leading: backwardButton(context),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: AppTheme.subMargin),
            ),
            notificationIcon(widget.orders, context),
          ],
        ),
        body: RefreshIndicator(
          color: AppTheme.primaryColor,
          onRefresh: () => Future.delayed(Duration(seconds: 2), () {
            // await NotificationsRepository().getNotifications();
            // globals.orders.clear();
            // globals.notifications.clear();
            // globals.notifications = NotificationsRepository.notifications;
            // for (int i = 0; i < globals.orders.length; i++) {
            //   globals.orders[i].title = globals.notifications[i].title;
            //   globals.orders[i].content = globals.notifications[i].content;
            //   globals.orders[i].clicked =
            //       checkClickedStatus(globals.notifications[i].clicked);
            //   globals.orders[i].sendTime = DateTime.fromMillisecondsSinceEpoch(
            //       (globals.notifications[i].sendDateTime * 1000));
            // }
            return true;
          }),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, AppTheme.largeMargin),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                generateTitle('Notificatons'),
                widget.orders.length == 0
                    ? makeNonListViewElement()
                    : makeListViewElement(context, widget.orders)
              ],
            ),
          ),
        ),
      ),
    );
  }

  notificationIcon(List orders, BuildContext context) {
    List<bool> item = [];
    for (var element in orders) {
      print(element.clicked);
      element.clicked ? null : item.add(element.clicked);
    }

    if (item.isNotEmpty) {
      return CircleAvatar(
        backgroundColor: Colors.red,
        radius: 12,
        child: AutoSizeText(
          '${item.length}',
          style: TextStyle(color: AppTheme.white),
          minFontSize: 10,
          maxFontSize: 10,
          maxLines: 1,
        ),
      );
    } else {
      return Container();
    }
  }

  textLayoutNotificationPage(String title, bool isRead, TextAlign textAlign) {
    return Text(
      title,
      style: isRead ? AppTheme.smallText : AppTheme.boldSmallText,
      maxLines: 1,
      textAlign: textAlign,
      overflow: TextOverflow.ellipsis,
    );
  }

  String filterDateTime(DateTime createdDate) {
    if (createdDate.day == DateTime.now().day &&
        createdDate.month == DateTime.now().month &&
        createdDate.year == DateTime.now().year) {
      if (createdDate.hour == DateTime.now().hour &&
          createdDate.minute == DateTime.now().minute) {
        return 'Now';
      } else {
        return timeago.format(createdDate);
      }
    } else {
      return DateFormat('dd').format(createdDate) +
          'th ' +
          DateFormat('MMM yyyy hh.mm a').format(createdDate);
    }
  }

  bool checkClickedStatus(int clicked) {
    if (clicked == 1)
      return true;
    else
      return false;
  }

  makeListViewElement(BuildContext context, List changeValue) {
    return Expanded(
      child: ListView.separated(
          shrinkWrap: true,
          itemCount: widget.orders.length,
          itemBuilder: (BuildContext context, int index) {
            return InkWell(
              onTap: () async {
                setState(() {
                  widget.orders[index].clicked = true;
                });

                Navigator.pushNamed(
                  context,
                  CustomRouter.inboxRoute,
                  arguments: widget.orders[index],
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: textLayoutNotificationPage(
                              widget.orders[index].title,
                              widget.orders[index].clicked,
                              TextAlign.start),
                        ),
                        Expanded(
                          child: textLayoutNotificationPage(
                              filterDateTime(widget.orders[index].sendTime),
                              widget.orders[index].clicked,
                              TextAlign.end),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: AppTheme.subMargin),
                    ),
                    AutoSizeText(
                      'Order is scheduled on ' +
                          DateFormat('dd/MM/yyyy')
                              .format(widget.orders[index].startDate) +
                          ' ' +
                          'Delivery to ' +
                          widget.orders[index].destination.address1 +
                          ', ' +
                          widget.orders[index].destination.address2 +
                          ', ' +
                          widget.orders[index].destination.city +
                          ', ' +
                          widget.orders[index].destination.postcode +
                          ', ' +
                          widget.orders[index].destination.state,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: widget.orders[index].clicked
                          ? AppTheme.smallText
                          : AppTheme.boldSmallText,
                    )
                  ],
                ),
              ),
            );
          },
          separatorBuilder: (_, __) => const Divider()),
    );
  }

  makeNonListViewElement() {
    return Expanded(
      child: Center(
        child: Text(
          'No received any order yet',
          style: TextStyle(color: Colors.grey),
        ),
      ),
    );
  }
}
