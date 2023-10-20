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
  void _onHSRDataSubmitted() async => await viewModel.onHSRDataSubmitted();

  late final PageController _pageController;

  @override
  void initState() {
    _pageController = PageController(initialPage: 0);
    super.initState();
  }

  Widget pageTextFormFieldDataFrame({
      required String title,
      required String hintText,
      required String initialValue,
      void Function(String)? onChanged,
      String? Function(String?)? validator,
      bool obscureText = false,
    }){
      return DataDisplayCard.horizontal(
        title: title,
        child: Expanded(
          flex: 2,
          child: TextFormField(
            textDirection: TextDirection.rtl,
            style: AppText.labelLarge(context).copyWith(color: AppColor.secondary(context)),
            initialValue: initialValue,
            onChanged: onChanged,
            validator: validator,
            obscureText: obscureText,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(vertical: 5),
              isDense: true,
              hintText: hintText,
              hintStyle: AppText.labelLarge(context).copyWith(color: AppColor.secondary(context).withOpacity(0.7)),
              hintTextDirection: TextDirection.rtl,
              border: const UnderlineInputBorder(
                borderSide: BorderSide.none
              ),
            ),
          ),
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

  Widget _buildHSRDataForm(){
    return Consumer<SettingPageViewModel>(
      builder: (context, viewModel, child) => SettingSection(
          title: "高鐵訂票資料設定",
          subTitle: "請依照指示輸入正式資料，幫助Goldie完成訂票程序",
          children: [
            Form(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  pageTextFormFieldDataFrame(
                    title: "身份證字號（10碼）",
                    hintText:  "輸入身份證字號",
                    initialValue: viewModel.hsrPersonId,
                    onChanged: (value) => viewModel.setHsrData(hsrPersonId: value),
                    validator: (value) => value!.isEmpty ? "請勿留空" : null,
                  ),
                  pageTextFormFieldDataFrame(
                    title: "電話號碼",
                    hintText:  "輸入電話號碼",
                    initialValue: viewModel.hsrPhone,
                    onChanged: (value) => viewModel.setHsrData(hsrPhone: value),
                    validator: (value) => value!.isEmpty ? "請勿留空" : null,
                  ),
                  pageTextFormFieldDataFrame(
                    title: "電子郵件",
                    hintText:  "輸入電子郵件",
                    initialValue: viewModel.hsrEmail,
                    onChanged: (value) => viewModel.setHsrData(hsrEmail: value),
                    validator: (value) => value!.isEmpty ? "請勿留空" : null,
                  ),
                ],
              )
            ),
            viewButton("訂票資料更新", _onHSRDataSubmitted)
          ],
        )
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
      builder: (context, viewModel, child) => SettingSection(
          title: "EECLASS 設定",
          subTitle: "請輸入EECLASS帳號密碼，並確認連線狀態",
          children: [
            Form(
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
                  pageTextFormFieldDataFrame(
                    title: "Account",
                    hintText:  "請輸入 EECLASS 帳號",
                    initialValue: viewModel.user.eeclassAccount,
                    onChanged: (value) => viewModel.setEeclassAccount(value),
                    validator: (value) => value!.isEmpty ? "請輸入帳號" : null,
                  ),
                  pageTextFormFieldDataFrame(
                    title: "Password",
                    hintText:  "請輸入 EECLASS 密碼",
                    obscureText: true,
                    initialValue: viewModel.user.eeclassPassword,
                    onChanged: (value) => viewModel.setEEclassPassword(value),
                    validator: (value) => value!.isEmpty ? "請輸入密碼" : null,
                  ),
                ],
              )
            ),
            viewButton("EECLASS 資料更新", _eeclassConnectionTest)
          ],
        )
      );
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
  
  Widget _tabChip(String label, int index){
    bool isSelected = viewModel.isCurrentPageIndex(index);
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: RawChip(
        label: Text(label),
        // avatar: isSelected ? const Icon(Icons.label , color: AppColor.surfaceColor,) : null,
        shape: const StadiumBorder(
          // borderRadius: BorderRadius.circular(20),
          side: BorderSide.none
        ),
        labelStyle: AppText.labelMedium(context).copyWith(color: isSelected ? AppColor.surfaceColor : AppColor.primary(context)),
        backgroundColor: isSelected ? AppColor.primary(context) : AppColor.surface(context),
        onSelected: (value) => {
          // debugPrint("$index, selected = $value"),
          viewModel.currentPageIndex = index,
          _pageController..animateToPage(viewModel.currentPageIndex, duration: const Duration(microseconds: 1000), curve:  Curves.easeInOut)
        },
      ),
    );
  }

  Widget _buildPageViewTab(){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: Row(
        children: List.generate(viewModel.pageTitles.length, (index) => _tabChip(viewModel.pageTitles[index], index))
      ),
    );
  }

  Widget pageBody(){
    return Consumer<SettingPageViewModel>(
      builder: (context, viewModel, child) => Scaffold(
        resizeToAvoidBottomInset : false,
        body: viewModel.isLoading ? loadingWidget() :
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTitleFrame(),
              _buildPageViewTab(),
              Expanded(
                child: PageView(
                  onPageChanged: (index) => {
                    viewModel.currentPageIndex = index,
                    _pageController..animateToPage(viewModel.currentPageIndex, duration: const Duration(microseconds: 1000), curve:  Curves.easeInOut)
                  },
                  controller: _pageController,
                  physics: const AlwaysScrollableScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  children: [
                    _buildEeclassSettingFrame(),
                    _buildEeclassAndNotionUpdateSettingFrame(),
                    _buildHSRDataForm(),
                  ],
                ),
              ),
            ],
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

