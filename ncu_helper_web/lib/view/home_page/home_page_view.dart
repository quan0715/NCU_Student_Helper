import 'dart:js';

import 'package:flutter/material.dart';
import 'package:ncu_helper/view/theme/color.dart';
import 'package:ncu_helper/view_model/home_page_view_model.dart';
import 'package:provider/provider.dart';

class HomePageView extends StatelessWidget {
  const HomePageView({Key? key}) : super(key: key);

  void onLineLogin(BuildContext context) async{
    await Provider.of<HomePageViewModel>(context, listen: false).lineLogin();
  }

  Widget _getLogo(){
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 40),
      child: Container(
        height: 250,
        width: 250,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: AppColor.onSurfaceColor, width: 2),
          image: const DecorationImage(
            image: AssetImage('assets/profile.png'),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget _getTitle(){
    TextStyle style = const TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.bold,
      color: AppColor.onSurfaceColor,
    );
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 0),
      child: Row(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Goldie', style: style.copyWith(color: AppColor.primaryColor,),),
              RichText(
                text: TextSpan(
                  text: 'NCU',
                  style: style.copyWith(color: AppColor.primaryColor,),
                  children: [
                    TextSpan(
                      text: ' Student Helper ',
                      style: style
                    ),
                  ],
                )
              ),
              Text("Goldie 你的中央大學校園 AI 智慧助手", style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColor.onSurfaceColor.withOpacity(0.7),
              )),
            ],
          ),
        ],
      ),
    );
  }

  Widget _getTag(String text,{Color? color}){
    return Chip(
      label: Text("#$text"),
      // avatar: Text("#"),
      backgroundColor: color ?? AppColor.onSurfaceColor.withOpacity(0.1),
      labelStyle: const TextStyle(
        fontSize: 12,
        color:AppColor.surfaceColor,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _getTagFrame(){
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      alignment: WrapAlignment.center,
      spacing: 5,
      runSpacing: 5,
      children: [
        _getTag("校園導覽"),
        _getTag("訂高鐵票", color: AppColor.primaryColor.withOpacity(0.7)),
        _getTag("公車查詢"),
        _getTag("EECLASS", color: AppColor.primaryColor.withOpacity(0.7)),
        //_getTag("課務資料查詢"),
        _getTag("NCU Wiki"),
        _getTag("校園大小事")
      ],
    );
  }

  Widget _actionFrame(BuildContext context){
    return Consumer<HomePageViewModel> (
      builder: (context, viewModel, child){
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 0),
          child: viewModel.isLoading ? _loadingText() : _startButton(context));
      }
    );
  }

  Widget _startButton(BuildContext context){
    return Consumer<HomePageViewModel>(
      builder: (context, viewModel, child ) => 
      Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                if(viewModel.isLineLoggedIn){
                  Navigator.pushNamed(context, '/setting');
                }else{
                  onLineLogin(context);
                }
                
              },
              style: ElevatedButton.styleFrom(
                backgroundColor:  Colors.transparent,
                foregroundColor:  AppColor.primaryColor,
                textStyle: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 0),
              ),
              child: viewModel.isLineLoggedIn ?
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('開始跟 Goldie 聊聊天 !'),
                  SizedBox(width: 10,),
                  Icon(Icons.arrow_forward_ios),
                ],
              ): Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('點我登入 Line 帳號 !'),
                  SizedBox(width: 10,),
                ],
              ) 
            ),
          ),
        ],
      ),
    );
  }

  Widget _loadingText(){
    return Consumer<HomePageViewModel>(
      builder: (context, viewModel, child) => 
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Spacer(),
            Text(" ${viewModel.loadingMessage}",
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: AppColor.primaryColor,
              )
            ),
            LinearProgressIndicator(
              valueColor: const AlwaysStoppedAnimation<Color>(AppColor.primaryColor),
              backgroundColor: AppColor.onSurfaceColor.withOpacity(0.1),),
            const Spacer(),
          ],
        )
    );
  }

  Widget _buildBody(BuildContext context){
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _getLogo(),
                _getTitle(),
                _getTagFrame(),
                Expanded(child: _actionFrame(context)),
               
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.surfaceColor,
      body: ChangeNotifierProvider<HomePageViewModel>(
        create: (context) => HomePageViewModel()..init(),
        child: Container(
          // color: AppColor.onErrorColor,
          child: _buildBody(context)),
      )
    );
  }
}
