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

  void _eeclassConnectionTest() async => await viewModel.eeclassConnectionTest();
  void _launchNotionOAuth() async => await viewModel.launchNotionOAuth();
  void _onSchedulingSettingChange() async => await viewModel.onSchedulingSettingChange();
  void _launchNotionDBBrowser() async => await viewModel.launchNotionDB();
  
  Widget _buildAccountSettingForm(){
    return Consumer<SettingPageViewModel>(
      builder: (context, viewModel, child) => Form(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DataDisplayCard.horizontal(
              title: "連線狀態",
              child: viewModel.isEEclassConnectionSuccess
                ? StatusChip(label: "連線成功", color: AppColor.onSuccessColor)
                : StatusChip(label: "連線失敗", color: AppColor.onErrorColor)
            ),
            DataDisplayCard.horizontal(
              title: "Account",
              child: Expanded(
                flex: 2,
                child: TextFormField(
                  textDirection: TextDirection.rtl,
                  style: AppText.labelLarge(context).copyWith(color: AppColor.secondary(context)),
                  initialValue: viewModel.user.eeclassAccount,
                  onChanged: (value) => viewModel.setStudentId(value),
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.symmetric(vertical: 5),
                    isDense: true,
                    hintText: "請輸入 EECLASS 帳號",
                    hintTextDirection: TextDirection.rtl,
                    border: UnderlineInputBorder(
                      borderSide: BorderSide.none
                    ),
                  ),
                ),
              ),
            ),
            DataDisplayCard.horizontal(
              title: "Password",
              child: Expanded(
                flex: 2,
                child: TextFormField(
                  textDirection: TextDirection.rtl,
                  style: AppText.labelLarge(context).copyWith(color: AppColor.secondary(context)),
                  initialValue: viewModel.user.eeclassPassword,
                  onChanged: (value) => viewModel.setEEclassPassword(value),
                  obscureText: true,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.symmetric(vertical: 5),
                    isDense: true,
                    hintText: "請輸入 EECLASS 密碼",
                    hintTextDirection: TextDirection.rtl,
                    border: UnderlineInputBorder(
                      borderSide: BorderSide.none
                    ),
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
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                elevation: 5,
                backgroundColor:  AppColor.onSurface(context),
                foregroundColor:  AppColor.surfaceColor,
                textStyle: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: AppColor.primary(context), width: 1) ,
                  borderRadius: BorderRadius.circular(5),
                ),
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(label, style: AppText.labelMedium(context)),
                  const Icon(Icons.arrow_right_alt, size: 20,),
                ],
              ),
            )
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
    TextStyle titleStyle =  AppText.headLineSmall(context).copyWith(color: AppColor.onSurface(context));
    TextStyle titleStyleStrong = AppText.headLineSmall(context).copyWith(color: AppColor.primary(context));
    TextStyle contentStyle = AppText.bodyLarge(context).copyWith(color: AppColor.secondary(context));
    String name = viewModel.user.lineUserName;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(text:TextSpan(
            children: [
              TextSpan(text: 'Welcome back, ', style: titleStyle),
              TextSpan(text: ' ${name} ', style: titleStyleStrong),
              // TextSpan(text: 'Helper', style: titleStyle),
            ],
          )),
          Text('歡迎來到 NCU Student Helper Setting page 請完成EECLASS帳號連接以及Notion授權。', style: contentStyle)
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
          subTitle: "請輸入EECLASS帳號密碼，並確認連線狀態",
          children: [
            _buildAccountSettingForm(),
            viewButton("EECLASS 資料更新", _eeclassConnectionTest)
          ],
        );
      });
  }

  Widget _buildEeclassAndNotionUpdateSettingFrame(){
    // TextStyle menuLabelStyle =  AppText.bodySmall(context);
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
              title: "連線狀態",
              child: viewModel.isNotionAuthSuccess
                ? StatusChip(label: "已授權", color: AppColor.onSuccessColor)
                : StatusChip(label: "未授權", color: AppColor.onErrorColor),),
          DataDisplayCard.horizontal(
            title: "Notion EECLASS Page",
            child: IconButton(
              iconSize: 16,
              icon: const Icon(Icons.open_in_new,),
              onPressed: () async => {
                if(viewModel.notionTemplateId != "None"){
                  _launchNotionDBBrowser()
                }else{
                  // open snake bar
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("請先設定授權 Notion")))
                }
              },
            ),
            
          ),
          
            DataDisplayCard.horizontal(
              title: "Auto Update 設定",
              child: Switch(
                thumbIcon: thumbIcon,
                activeColor: AppColor.onSuccessColor,
                inactiveThumbColor: AppColor.onWarningColor,
                value: viewModel.isSchedulingModeOpen,
                onChanged: (value) => {
                  viewModel.isSchedulingModeOpen = value,
                  _onSchedulingSettingChange()
                }
              ),
            ),
            DataDisplayCard.horizontal(
              title: "排程更新時間",
              child: Card(
                elevation: 1,
                color: AppColor.secondary(context),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    children: [
                      DropdownButton(
                        isDense: true,
                        dropdownColor: AppColor.secondary(context),
                        focusColor: Colors.transparent,
                        icon: const Icon(Icons.arrow_drop_down, color: AppColor.surfaceColor,),
                        onChanged: (value) => {
                          viewModel.schedulingTimeOption = value!,
                          _onSchedulingSettingChange()
                        },
                        underline: Container(),
                        value: viewModel.schedulingTimeOption,
                        items: viewModel.schedulingTimeOptions.map(
                          (int time) =>  DropdownMenuItem(value: time, child: Text("$time min", style: AppText.labelMedium(context)))
                        ).toList()
                      )
                    ],
                  ),
                ),
              )
            ), 
            viewButton("Notion Oauth 登入", _launchNotionOAuth),
          ],
        );
      });
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
                // _buildOAuthFrame(),
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

