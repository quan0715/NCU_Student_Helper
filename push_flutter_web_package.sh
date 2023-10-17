
# 第一步：執行 flutter build
cd ncu_helper_web
flutter build web --no-tree-shake-icons
cd ..
cp -r ./ncu_helper_web/build/web ./ncu_helper_server   
echo "完成！已將 web 資源移動到 Django 項目中。"

