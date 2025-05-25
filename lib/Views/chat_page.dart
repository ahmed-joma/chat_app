import 'package:chat_app/constants.dart';
import 'package:chat_app/cubit/chat_cubit/chat_cubit/cubit/chat_cubit.dart';
import 'package:chat_app/models/message.dart';
import 'package:chat_app/widget/chat_buble.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ignore: must_be_immutable
class chatPage extends StatelessWidget {
  chatPage({super.key});

  final _controller = ScrollController();

  List<Message> messageList = [];

  TextEditingController controller = TextEditingController();
  //عشان اقدر افضي التكسك فيلد من النص واخليه يرتسل ف انشأت اوبجكت كونترولر
  @override
  Widget build(BuildContext context) {
    var email = ModalRoute.of(context)!.settings.arguments;
    //هين هريجعلي الارجومينت الي انا باعتها من الصفحه الي قبلها
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading:
            false, // عشان احذف السهم الي برجعني بوب لصفحه الي ورا
        backgroundColor: KPrimaryColor,
        title: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Image.asset(
            'assets/images/scholar.png',
            height: 70,
          ),
          const Text(
            'chat',
            style: TextStyle(
              fontSize: 20,
              color: Colors.white,
              fontFamily: 'Pacifico',
            ),
          ),
        ]),
      ),
      body: Column(
        children: [
          Expanded(
            //حطيت هذه الداله عشان اخلي الكولوم ياخد نفس ارتفاع اللست فيو
            //وظيفه الاكسباندد انها بتقول للشايلد تاعها خد المساحه المتاحه ليك
            //يعني ف اي مره اتضطريت احط لست فيوا جوا كولوم لازم احط اللست فيوا جوا اكسباند
            child: BlocConsumer<ChatCubit, ChatState>(
              listener: (context, state) {
                if (state is ChatSuccess) {
                  messageList = state.messageList;
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    _controller.animateTo(
                      _controller.position.maxScrollExtent,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeIn,
                    ); // استخدمت WidgetsBinding.instance.addPostFrameCallback حتى أضمن أن السكروول يتم بعد اكتمال بناء الرسائل على الشاشة،
// لأن تحريك السكروول مباشرة قد لا يظهر آخر رسالة بشكل كامل إذا لم يكن قد تم حساب الطول الجديد للـ ListView بعد.
                  });
                } else if (state is ChatFailure) {
                  messageList.add(state.failedMessage);
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    _controller.animateTo(
                      _controller.position.maxScrollExtent,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeIn,
                    );
                  });
                }
              },
              builder: (context, state) {
                if (state is ChatInitial) {
                  BlocProvider.of<ChatCubit>(context).getMessages();
                }
                return BlocBuilder<ChatCubit, ChatState>(
                  builder: (context, state) {
                    return ListView.builder(
                        controller: _controller,
                        itemCount:
                            messageList.length, //هنا بدي اعرض الرسائل ع الشاشه
                        itemBuilder: (context, index) {
                          return messageList[index].kEmail == email
                              ? ChatBuble(
                                  message: messageList[index],
                                  //من خلال المسج هين اعيطيتوا المسج الي جاي الي
                                )
                              : ChatBubleForFrind(
                                  message: messageList[index],
                                  //من خلال المسج هين اعيطيتوا المسج الي جاي الي
                                );
                        });
                  },
                );
              },
            ),
            //في هذه الجزئيه انا هين هعمل بلد بناء للشاشه حسب الايميل
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 18,
              right: 18,
              bottom: 20,
              top: 18,
            ),
            child: TextField(
              controller: controller, //عرفت الكونترولر هون
              onSubmitted: (data) {
                BlocProvider.of<ChatCubit>(context)
                    .sendMessage(message: data, email: email.toString());
                controller.clear();
                //هين قولت للكنترولر فضي التكست فيلد بعد ما يتم ارسال الرساله
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: const BorderSide(color: KPrimaryColor),
                ),
                hintText: 'type a message...',
                suffixIcon: IconButton(
                    icon: const Icon(
                      Icons.send,
                      color: KPrimaryColor,
                    ),
                    onPressed: () {
                      BlocProvider.of<ChatCubit>(context).sendMessage(
                          message: controller.text, email: email.toString());
                      controller.clear();
                      //هين قولت للكنترولر فضي التكست فيلد بعد ما يتم ارسال الرساله
                    }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
