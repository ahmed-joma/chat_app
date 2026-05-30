import 'package:chat_app/constants.dart';
import 'package:chat_app/models/message.dart';
import 'package:flutter/material.dart';

class ChatBuble extends StatelessWidget {
  const ChatBuble({
    super.key,
    required this.message,
  });
  final Message message;
  @override
  Widget build(BuildContext context) {
    return Align(
      //انا استخدمت الالاين عشان احدد الببل تاع التكست يجيلي ع اليسار
      alignment: Alignment.centerRight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            // height: 65,
            // width: 150, //حذفتهم عشان بدي اعطي طول وعرض ثابتين للببل
            padding: const EdgeInsets.only(
              left: 16,
              top: 16,
              bottom: 16,
              right: 16,
            ), //هين انا عملت مساحه بادنج حوالين النص
            //البادنج بياخدلي مسافه داخل الكونتينر
            margin: const EdgeInsets.symmetric(
              vertical: 8,
              horizontal: 18,
            ),
            //المارج بيياخدي مسافه خارج الكونتينر
            decoration: const BoxDecoration(
              color: kPrimaryColor,
              borderRadius: BorderRadius.only(
                // عشان اعمل الزوايه
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
                bottomLeft: Radius.circular(30),
              ),
            ),
            child: Text(
              message.message,
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
              ),
            ),
          ),
          if (message.isLoading)
            const Padding(
              padding: EdgeInsets.only(left: 4),
              child: Icon(Icons.access_time, color: Colors.grey, size: 18),
            ),
          if (!message.isLoading && message.isFailed)
            const Padding(
              padding: EdgeInsets.only(left: 4),
              child: Icon(Icons.error, color: Colors.red, size: 18),
            ),
        ],
      ),
    );
  }
}

class ChatBubleForFrind extends StatelessWidget {
  const ChatBubleForFrind({
    super.key,
    required this.message,
  });
  final Message message;
  @override
  Widget build(BuildContext context) {
    return Align(
      //انا استخدمت الالاين عشان احدد الببل تاع التكست يجيلي ع اليسار
      alignment: Alignment.centerLeft,
      child: Container(
        // height: 65,
        // width: 150, //حذفتهم عشان بدي اعطي طول وعرض ثابتين للببل
        padding: const EdgeInsets.only(
          left: 16,
          top: 16,
          bottom: 16,
          right: 16,
        ), //هين انا عملت مساحه بادنج حوالين النص
        //البادنج بياخدلي مسافه داخل الكونتينر
        margin: const EdgeInsets.symmetric(
          vertical: 8,
          horizontal: 18,
        ),
        //المارج بيياخدي مسافه خارج الكونتينر
        decoration: const BoxDecoration(
          color: Colors.orange,
          borderRadius: BorderRadius.only(
            // عشان اعمل الزوايه
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
            bottomRight: Radius.circular(30),
          ),
        ),
        child: Text(
          message.message,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 15,
          ),
        ),
      ),
    );
  }
}
