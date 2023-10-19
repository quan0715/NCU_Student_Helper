import 'package:flutter/material.dart';
import 'package:ncu_helper/view/setting_page/data_display_card.dart';
import 'package:ncu_helper/view/setting_page/setting_section.dart';
import 'package:ncu_helper/view/setting_page/status_chip.dart';
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

  void _lineLogin() async => await viewModel.lineLogin();
  void _eeclassConnectionTest() async => await viewModel.eeclassConnectionTest();
  void _launchNotionOAuth() async => await viewModel.launchNotionOAuth();
  void _onSchedulingSettingChange() async => await viewModel.onSchedulingSettingChange();
  
  Widget _buildAccountSettingForm(){
    return Consumer<SettingPageViewModel>(
      builder: (context, viewModel, child) => Form(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DataDisplayCard(
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
            DataDisplayCard(
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
                  const Icon(Icons.arrow_right_alt, size: 20,),
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
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
      ),
    );        
  }

  Widget _buildEeclassSettingFrame(){
    return Consumer<SettingPageViewModel>(
      builder: (context, viewModel, child){
        // viewModel.eeclassConnectionTest();
        return SettingSection(
          title: "EECLASS 設定",
          status: viewModel.isEEclassConnectionSuccess
            ? StatusChip(label: "連線成功", color: AppColor.onSuccessColor)
            : StatusChip(label: "連線失敗", color: AppColor.onErrorColor),
          children: [
            _buildAccountSettingForm(),
            viewButton("EECLASS 連線測試", _eeclassConnectionTest)
          ],
        );
      });
  }

  Widget _buildEeclassAndNotionUpdateSettingFrame(){
    TextStyle menuLabelStyle =  AppText.bodySmall(context);
    final MaterialStateProperty<Icon?> thumbIcon = MaterialStateProperty.resolveWith<Icon?>(
      (Set<MaterialState> states) {
        if (states.contains(MaterialState.selected)) {
          return const Icon(Icons.check);
        }
        return const Icon(Icons.close);
      },
    );
    return Consumer<SettingPageViewModel>(
      builder: (context, viewModel, child){
        return SettingSection(
          title: "EECLASS & Notion 排程更新設定",
          subTitle: "設定排程時間與切換自動/手動更新",
          children: [
            DataDisplayCard.horizontal(
              title: "Auto Update 設定",
              child: Switch(
                thumbIcon: thumbIcon,
                activeColor: AppColor.onSuccessColor,
                inactiveThumbColor: AppColor.onWarningColor,
                value: viewModel.isSchedulingModeOpen,
                onChanged: (value) => viewModel.isSchedulingModeOpen = value,
              ),
            ),
            DataDisplayCard.horizontal(
              title: "EECLASS / Notion 更新時間",
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    children: [
                      DropdownButton(
                        focusColor: Colors.transparent,
                        onChanged: (value) => viewModel.schedulingTimeOption = value!,
                        underline: Container(),
                        value: viewModel.schedulingTimeOption,
                        items: viewModel.schedulingTimeOptions.map(
                          (int time) =>  DropdownMenuItem(value: time, child: Text("$time min", style: menuLabelStyle))
                        ).toList()
                      )
                    ],
                  ),
                ),
              )
            ), 
            viewButton("更新資料", _onSchedulingSettingChange)
          ],
        );
      });
  }
  
  Widget _buildOAuthFrame(){
    return Consumer<SettingPageViewModel>(
      builder: (context, viewModel, child) => SettingSection(
        title: "Notion OAuth 設定",
        status: viewModel.isNotionAuthSuccess
          ? StatusChip(label: "已授權", color: AppColor.onSuccessColor)
          : StatusChip(label: "未授權", color: AppColor.onErrorColor),

        children: [
          DataDisplayCard(
            title: "Notion EECLASS TOKEN",
            child: Row(
              children: [
                Expanded(child: Text(viewModel.notionAuthToken)),
              ],
            )
          ),
          DataDisplayCard(
            title: "Notion EECLASS db URL",
            child: Row(
              children: [
                Expanded(child: Text(viewModel.notionTemplateId)),
              ],
            )
          ),
          viewButton("Notion OAuth 連線", _launchNotionOAuth)
        ],
      ));
  }

  Widget _buildLineTestFrame(){
    return Consumer<SettingPageViewModel>(
      builder: (context, viewModel, child) => SettingSection(
        title: "line login 測試",
        subTitle: "如從外部網站進入，請先登入line，再進行設定",
        status: viewModel.isLineLoggedIn 
          ? StatusChip(label: "已登入", color: AppColor.onSuccessColor)
          : StatusChip(label: "未登入", color: AppColor.onErrorColor),

        children: [
          DataDisplayCard(title: "line 使用者名稱", child: Row(
            children: [
              Expanded(child: Text(viewModel.lineUserName)),
            ],
          )),
          DataDisplayCard(title: "line 使用者User Id", child: Row(
            children: [
              Expanded(child: Text(viewModel.lineId)),
            ],
          )),
          viewButton("Line Login 測試", _lineLogin)
        ],
        
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
                // _buildLineTestFrame(),
                _buildEeclassSettingFrame(),
                _buildOAuthFrame(),
                _buildEeclassAndNotionUpdateSettingFrame(),
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

