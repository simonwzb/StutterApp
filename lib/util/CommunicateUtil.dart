import 'dart:ui';



/// 安卓和flutter通信的工具
class CommunicateUtil{

  static void listenerFromAndroid(){
    ///声明一个用来存回调的对象
    // VoidCallback removeListener;
    //
    // ///添加事件响应者,监听native发往flutter端的事件
    // removeListener = BoostChannel.instance.addEventListener("eventToFlutter", (key, arguments) {
    //   ///deal with your event here
    //   print(" key="+key+"from android argument="+arguments.toString());
    //   return;
    // });

    ///然后在退出的时候（比如dispose中）移除监听者
    // removeListener?.call();
  }
}