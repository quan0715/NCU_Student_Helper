// import 'package:intl/intl.dart';

// class DashBoardFormat{
//   // static NumberFormat _numberFormat = NumberFormat('#,###');
//   static String todayTime(DateTime time) => DateFormat('HH:mm').format(time);
//   static String dayTimeChartLabel(DateTime time) => DateFormat('MM/d \n hh a').format(time);
//   static String time(DateTime time) => DateFormat('MM/dd hh:mm').format(time);
//   static String timeWithSecond(DateTime time) => DateFormat('MM/dd HH:mm:ss').format(time);
//   static String timePickerLabel(DateTime time){
//     var t = DateTime.now();
//     if(t.day == time.day && t.month == time.month && t.year == time.year){
//       return "今天";
//     }else if (t.year == time.year){
//       return DateFormat('MM月dd日').format(time);
//     }else{
//       return DateFormat('yyyy年MM月dd日').format(time);
//     }
//   }
//   static String dateTime(DateTime time) => DateFormat('MM/dd').format(time);
//   static String number(int value) => NumberFormat('#,###').format(value);
//   // iso8601 format to DateTime
//   static String iO8dateTime(String time) => dateTime(DateTime.parse(time));
// }