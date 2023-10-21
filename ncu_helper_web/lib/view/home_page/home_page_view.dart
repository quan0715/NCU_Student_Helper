
import 'package:flutter/material.dart';
import 'package:ncu_helper/view/theme/color.dart';
import 'package:ncu_helper/view/theme/text.dart';
import 'package:ncu_helper/view_model/home_page_view_model.dart';
import 'package:provider/provider.dart';

class HomePageView extends StatefulWidget {
  const HomePageView({Key? key}) : super(key: key);

  @override
  State<HomePageView> createState() => _HomePageViewState();
}

class _HomePageViewState extends State<HomePageView> {
  void onLineLogin(BuildContext context) async{
    var viewModel = Provider.of<HomePageViewModel>(context, listen: false);
    viewModel.isLineLoggedIn
        ? Navigator.pushNamed(context, '/setting')
        : await viewModel.lineLogin();
  }

  Widget _getLogo(){
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 25, horizontal:30),
      child: Container(
        height: 210,
        width: 210,
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
    TextStyle style = AppText.headLineMedium(context).copyWith(
      fontWeight: FontWeight.bold,
      color: AppColor.onSurfaceColor.withOpacity(0.7),
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
              Text("Goldie - 你的中央大學校園 AI 智慧助手", style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColor.secondary(context)
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
      backgroundColor: color ?? AppColor.onSurfaceColor,
      labelStyle: const TextStyle(
        fontSize: 12,
        color:AppColor.surfaceColor,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _getTagFrame(){
    return Row(
      children: [
        Expanded(
          child: Wrap(
            crossAxisAlignment: WrapCrossAlignment.start,
            alignment: WrapAlignment.start,
            spacing: 5,
            runSpacing: 5,
            children: [
              _getTag("校園導覽"),
              _getTag("EECLASS", color: AppColor.primaryColor),
              _getTag("高鐵"),
              _getTag("公車"),
              _getTag("Notion", color: AppColor.primaryColor),
              _getTag("NCU Wiki"),
              _getTag("周邊美食")
            ],
          ),
        ),
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
                viewModel.isLineLoggedIn
                 ? Navigator.pushNamed(context, '/setting')
                 : onLineLogin(context);
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
      child: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
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
        ),
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
