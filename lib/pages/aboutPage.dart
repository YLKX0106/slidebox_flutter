import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  final AboutController _aboutController = Get.put(AboutController());

  @override
  Widget build(BuildContext context) {
    final Color outline = Theme
        .of(context)
        .colorScheme
        .outline;
    TextStyle subTitleStyle =
    TextStyle(fontSize: 13, color: Theme
        .of(context)
        .colorScheme
        .outline);
    return Scaffold(
      appBar: AppBar(
        title: Text('关于', style: Theme
            .of(context)
            .textTheme
            .titleMedium),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset(
              'assets/images/icon.png',
              width: 150,
            ),
            Text(
              'SidePhoto',
              style: Theme
                  .of(context)
                  .textTheme
                  .titleMedium,
            ),
            const SizedBox(height: 6),
            ListTile(
              onTap: () => _aboutController.githubUrl(),
              title: const Text('开源地址'),
              trailing: Text(
                'github.com/YLKX0106/slidebox_flutter',
                style: subTitleStyle,
              ),
            ),
            ListTile(
              onTap: () => _aboutController.feedback(),
              title: const Text('问题反馈'),
              trailing: Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: outline,
              ),
            ),
            ListTile(
              onTap: ()async{
                final permission = await PhotoManager.requestPermissionExtend();
                if (permission.isAuth==true){
                  SmartDialog.showToast('已获取权限');
                }else{
                  SmartDialog.showToast('请给予软件存储权限');
                }
              },
              title: const Text('获取权限'),
            ),
            SizedBox(height: MediaQuery
                .of(context)
                .padding
                .bottom + 20)
          ],
        ),
      ),
    );
  }
}


class AboutController extends GetxController {
  // 跳转github
  githubUrl() {
    launchUrl(
      Uri.parse('https://github.com/YLKX0106/slidebox_flutter'),
      mode: LaunchMode.externalApplication,
    );
  }

  // 问题反馈
  feedback() {
    launchUrl(
      Uri.parse('https://github.com/YLKX0106/slidebox_flutter/issues'),
      // 系统自带浏览器打开
      mode: LaunchMode.externalApplication,
    );
  }
}
