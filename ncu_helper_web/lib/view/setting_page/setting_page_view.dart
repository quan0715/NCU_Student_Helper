import 'package:flutter/material.dart';
import 'package:ncu_helper/view/theme/theme.dart';
import 'package:ncu_helper/view_model/setting_page_view_model.dart';
import 'package:provider/provider.dart';

class SettingPageView extends StatefulWidget {
  const SettingPageView({Key? key}) : super(key: key);

  @override
  State<SettingPageView> createState() => _SettingPageViewState();
}
class _SettingPageViewState extends State<SettingPageView> {
  SettingPageViewModel viewModel = SettingPageViewModel();

  @override
  void initState() {
    // debugPrint(viewModel.isEEclassConnectionSuccess.toString());
    super.initState();
  }

  Widget dataCard({double elevation = 0.0, String title = "分類", required Widget child, }){
    return Card(
      elevation: elevation,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: AppText.labelMedium(context).copyWith(color: AppColor.primary(context)),),
            child,
          ],
        ),
      ),
    );
  }

  Widget _buildAccountSettingForm(){
    return Consumer<SettingPageViewModel>(
      builder: (context, viewModel, child) => Form(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            dataCard(
              title: "EECLASS Account",
              child: TextFormField(
                style: AppText.bodyMedium(context),
                initialValue: viewModel.user.studentId,
                onChanged: (value) => viewModel.setStudentId(value),
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.symmetric(vertical: 5),
                  isDense: true,
                  hintText: "請輸入 EECLASS 帳號",
                  border: UnderlineInputBorder(
                    // borderSide: BorderSide.none
                  ),
                ),
              ),
            ),
            dataCard(
              title: "EECLASS Password",
              child: TextFormField(
                style: AppText.bodyMedium(context),
                initialValue: viewModel.user.eeclassPassword,
                onChanged: (value) => viewModel.setEEclassPassword(value),
                obscureText: true,
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.symmetric(vertical: 5),
                  isDense: true,
                  hintText: "請輸入 EECLASS 密碼",
                  border: UnderlineInputBorder(
                    // borderSide: BorderSide.none
                  ),
                ),
              ),
            ),
          ],
        )
      ),
    );
  }

  Widget viewButton(String label, onPressed){
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Row(
        children: [
          Expanded(
            child: MaterialButton(
              color: AppColor.primary(context),
              textColor: AppColor.onPrimary(context),
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              onPressed: onPressed, 
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(label, style: AppText.bodySmall(context).copyWith(color: AppColor.onPrimary(context),)),
                  Icon(Icons.arrow_right_alt, size: 20,),
                ],
              ),
            ),
          ),
        ],
      ),
    );

  }

  Widget loadingWidget(){
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildTitleFrame(){
    TextStyle titleStyle =  AppText.titleLarge(context);
    TextStyle titleStyleStrong = AppText.titleLarge(context).copyWith(color: AppColor.primary(context));
    TextStyle contentStyle = AppText.titleSmall(context).copyWith(fontWeight: FontWeight.normal);
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(text:TextSpan(
          children: [
            TextSpan(text: 'NCU', style: titleStyle),
            TextSpan(text: ' EECLASS ', style: titleStyleStrong),
            TextSpan(text: 'Helper', style: titleStyle),
          ],
        )),
        Text('歡迎來到 NCU EECLASS Helper 請照以下步驟來完成EECLASS設定', style: contentStyle)
      ],
    );        
  }

  Widget stateWidget(String label, Color color){
    return RawChip(
      avatar: CircleAvatar(
        backgroundColor: color,
        radius: 5,
      ),
      side: BorderSide(color: color.withOpacity(0.5)),
      label: Text(label, style: AppText.bodySmall(context)),
    );
  }

  Widget _buildSettingFrame(){
    return Consumer<SettingPageViewModel>(
      builder: (context, viewModel, child){
        // viewModel.eeclassConnectionTest();
        return Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Card(
          elevation: 1,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("EECLASS 設定", style: AppText.titleMedium(context)),
                          viewModel.isEEclassConnectionSuccess
                           ? stateWidget("連線成功", AppColor.onSuccessColor)
                           : stateWidget("連線失敗", AppColor.onErrorColor)
                        ],
                      ),
                      const Divider(),
                      _buildAccountSettingForm(),
                      viewButton("EECLASS 連線測試", () async => await viewModel.eeclassConnectionTest())
                      // viewButton("EECLASS 連線測試", () async => await viewModel.userInitTest())
                    ],
                  ),
                ),
            ],
          )
        ));
      });
  }

  Widget _buildOAuthSettingForm(){
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        dataCard(
          title: "Notion EECLASS TOKEN",
          child: Row(
            children: [
              Expanded(child: Text("None")),
            ],
          )
        ),
        dataCard(
          title: "Notion EECLASS db URL",
          child: Row(
            children: [
              Expanded(child: Text("None")),
            ],
          )
        ),
      ],
    );
  }
  
  Widget _buildOAuthFrame(){
    return Consumer<SettingPageViewModel>(
      builder: (context, viewModel, child) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Card(
          elevation: 1,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Notion OAuth 設定", style: AppText.titleMedium(context)),
                        stateWidget("未授權", AppColor.onErrorColor),
                      ],
                    ),
                    const Divider(),
                    _buildOAuthSettingForm(),
                    viewButton("Notion OAuth 連線", (){})
                  ],
                ),
              ),
            ],
          )
        ),
      ));
  }

  Widget _buildLineTestFrame(){
    return Consumer<SettingPageViewModel>(
      builder: (context, viewModel, child) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Card(
          elevation: 1,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                child: 
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("line login 測試", style: AppText.titleMedium(context)),
                          viewModel.isLineLoggedIn 
                          ? stateWidget("已登入", AppColor.onSuccessColor) 
                          : stateWidget("未登入", AppColor.onErrorColor) 
                          
                        ],
                      ),
                      const Divider(),
                      dataCard(title: "line 使用者名稱", child: Row(
                        children: [
                          Expanded(child: Text(viewModel.lineUserName)),
                        ],
                      )),
                      dataCard(title: "line 使用者User Id", child: Row(
                        children: [
                          Expanded(child: Text(viewModel.lineId)),
                        ],
                      )),
                      viewButton("Line Login 測試", () async => await viewModel.lineLogin())
                    ],
                  ),
                ),
            ],
          )
        ),
      ));
  }

  Widget pageBody(){
    return Consumer<SettingPageViewModel>(
      builder: (context, viewModel, child) => Scaffold(
        body: 
        viewModel.isLoading ? loadingWidget() :
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTitleFrame(),
                _buildLineTestFrame(),
                _buildSettingFrame(),
                _buildOAuthFrame(),
              ],
              ),
          ),
        ),
      ));
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SettingPageViewModel>.value(
      value: viewModel..init(),
      builder: (context, child) => pageBody(),
    );
  }
}