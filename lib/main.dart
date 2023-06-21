import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const MyHomePage(title: '书架'),
        '/login': (context) => LoginScreen(),
        '/userInfo': (context) => Book(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String? registeredUsername;
  String? registeredPassword;

  void _navigateToLogin() {
    Navigator.pushNamed(context, '/login', arguments: {
      'registeredUsername': registeredUsername,
      'registeredPassword': registeredPassword,
    });
  }

  void _showRegistrationSuccessDialog(String username, String password) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('注册成功'),
          content: Text('您已成功注册！'),
          actions: <Widget>[
            TextButton(
              child: Text('立即登录'),
              onPressed: () {
                Navigator.pop(context); // 关闭对话框
                _navigateToLogin(); // 跳转到登录页面
              },
            ),
            TextButton(
              child: Text('稍后登录'),
              onPressed: () {
                Navigator.pop(context); // 关闭对话框
              },
            ),
          ],
        );
      },
    );
    registeredUsername = username;
    registeredPassword = password;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FormTestRoute(
              onRegisterSuccess: _showRegistrationSuccessDialog,
            ),
          ],
        ),
      ),
    );
  }
}

class FormTestRoute extends StatefulWidget {
  final Function(String, String) onRegisterSuccess;

  const FormTestRoute({Key? key, required this.onRegisterSuccess})
      : super(key: key);

  @override
  _FormTestRouteState createState() => _FormTestRouteState();
}

class _FormTestRouteState extends State<FormTestRoute> {
  TextEditingController _unameController = TextEditingController();
  TextEditingController _pwdController = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _register() {
    if (_formKey.currentState!.validate()) {
      // 验证通过提交数据
      // 模拟注册成功
      String username = _unameController.text;
      String password = _pwdController.text;
      widget.onRegisterSuccess(username, password);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        children: <Widget>[
          TextFormField(
            autofocus: true,
            controller: _unameController,
            decoration: InputDecoration(
              labelText: "用户名",
              hintText: "用户名或邮箱",
              icon: Icon(Icons.person),
            ),
            validator: (v) {
              return v!.trim().isNotEmpty ? null : "用户名不能为空";
            },
          ),
          TextFormField(
            controller: _pwdController,
            decoration: InputDecoration(
              labelText: "密码",
              hintText: "您的登录密码",
              icon: Icon(Icons.lock),
            ),
            obscureText: true,
            validator: (v) {
              return v!.trim().length > 5 ? null : "密码不能少于6位";
            },
          ),
          Padding(
            padding: const EdgeInsets.only(top: 28.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: ElevatedButton(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text("注册"),
                    ),
                    onPressed: _register,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class LoginScreen extends StatelessWidget {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic>? arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;

    if (arguments != null) {
      final String registeredUsername = arguments['registeredUsername'];
      final String registeredPassword = arguments['registeredPassword'];

      bool performLogin(String username, String password) {
        // 进行登录验证，比较输入的用户名和密码与保存的注册信息是否相同
        return username == registeredUsername && password == registeredPassword;
      }

      return Scaffold(
        appBar: AppBar(
          title: Text('登录'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: "用户名",
                  hintText: "请输入注册时的用户名",
                  icon: Icon(Icons.person),
                ),
              ),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: "密码",
                  hintText: "请输入注册时的密码",
                  icon: Icon(Icons.lock),
                ),
                obscureText: true,
              ),
              SizedBox(height: 20), // 添加一个间距
              Align(
                alignment: Alignment.center,
                child: Container(
                  width: 200.0, // 设置按钮宽度
                  height: 50.0, // 设置按钮高度
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.all(0), // 移除内边距
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100.0),
                      ),
                      primary: Colors.red,
                      onPrimary: Colors.white,
                      shadowColor: Colors.black54,
                      elevation: 4.0,
                    ),
                    child: Text("登录"),
                    onPressed: () {
                      // 获取输入的用户名和密码
                      String username = _usernameController.text;
                      String password = _passwordController.text;

                      if (performLogin(username, password)) {
                        // 登录成功，跳转到用户信息页面并传递用户名和密码
                        Navigator.pushNamed(context, '/userInfo', arguments: {
                          'username': username,
                          'password': password,
                        });
                      } else {
                        // 登录失败，显示错误提示
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text('登录失败'),
                              content: Text('用户名或密码不正确'),
                              actions: <Widget>[
                                TextButton(
                                  child: Text('确定'),
                                  onPressed: () {
                                    Navigator.pop(context); // 关闭对话框
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Text('登录'),
        ),
        body: Center(
          child: Text('未提供注册信息'),
        ),
      );
    }
  }
}

class Book extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('书架')),
        body: MyHomePage02(),
      ),
    );
  }
}

class MyHomePage02 extends StatefulWidget {
  @override
  _MyHomePageState02 createState() => _MyHomePageState02();
}

class _MyHomePageState02 extends State<MyHomePage02> {
  int _selectedIndex = 0;

  List<Widget> _pages = [
    Bookshelf(),
    Category(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '书架',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.sort),
            label: '分类',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}

class Bookshelf extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
       
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Bookshelf_Book1_Detail()),
                        );
                      },
                      child: Image(
                        image: AssetImage("images/sanguo.jpg"),
                        width: 200,
                        height: 200,
                      ),
                    ),
                    Text('三国演义'),
                  ],
                ),
                Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Bookshelf_Book2_Detail()),
                        );
                      },
                      child: Image(
                        image: AssetImage('images/honglou.jpg'),
                        width: 200,
                        height: 200,
                      ),
                    ),
                    Text('红楼梦'),
                  ],
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Bookshelf_Book3_Detail()),
                        );
                      },
                      child: Image(
                        image: AssetImage('images/baiqiang.jpg'),
                        width: 200,
                        height: 200,
                      ),
                    ),
                    Text('白蔷会'),
                  ],
                ),
                Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Bookshelf_Book4_Detail()),
                        );
                      },
                      child: Image(
                        image: AssetImage('images/shuihu.jpg'),
                        width: 200,
                        height: 200,
                      ),
                    ),
                    Text('水浒传'),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class Category extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Column(
        children: [
          const TabBar(
            indicatorColor:Colors.blue,
            labelColor:Colors.blue,
            unselectedLabelColor:Colors.black,
            tabs: [
              Tab(text: '男生'),
              Tab(text: '女生'),
              Tab(text: '热销'),
          ]),
          Expanded(
            child: TabBarView(children: [
              Category_Boy(),
              Category_Girl(),
              Category_Sellable(),
            ]),
          ),
        ],
      ),
    );
  }
}

class Bookshelf_Book1_Detail extends StatelessWidget {
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Image(
            image: AssetImage('images/shuihu.jpg'),
            width: 200,
            height: 200,
          ),
          SizedBox(height: 16),
          Text(
            '元末明初罗贯中',
            style: TextStyle(
                color: Colors.black,
                backgroundColor: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold
            ),
          ),
          SizedBox(height: 16),
          Text(
            '故事开始于黄巾兵起义，结束于司马氏灭吴开晋，以描写战争为主，反映了魏、蜀汉、吴三个政治集团之间的政治和军事斗争，展现了从东汉末年到西晋初年之间近一百年的历史风云，并成功塑造了一批叱咤风云的英雄人物。',
            style: TextStyle(
                color: Colors.black,
                backgroundColor: Colors.white,
                fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }
}

class Bookshelf_Book2_Detail extends StatelessWidget {
  @override
 Widget build(BuildContext context) {
    return Center(
      child: Column(
        
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Image(
            image: AssetImage('images/honglou.jpg'),
            width: 200,
            height: 200,
          ),
          SizedBox(height: 16),
          Text(
            '清代曹雪芹',
            style: TextStyle(color: Colors.black,fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          Text(
            '讲述的是发生在一个虚构朝代的封建大家庭中的人事物，其中以贾宝玉、林黛玉、薛宝钗三个人之间的感情纠葛为主线通过对一些日常事件的描述体现了在贾府的大观园中以金陵十二钗为主体的众女子的爱恨情愁。而在这同时又从贾府由富贵堂皇走向没落衰败的次线反映了一个大家族的没落历程和这个看似华丽的家族的丑陋的内在。',
            style: TextStyle(color: Colors.black,fontSize: 18, fontStyle: FontStyle.italic),
          ),
        ],
      ),
    );
  }
}

class Bookshelf_Book3_Detail extends StatelessWidget {
  @override
   Widget build(BuildContext context) {
    return Center(
      child: Column(
        
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Image(
            image: AssetImage('images/honglou.jpg'),
            width: 200,
            height: 200,
          ),
          SizedBox(height: 16),
          Text(
            '付鹏',
            style: TextStyle(color: Colors.black,fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          Text(
            '沈玉涵这是第三次因为那个怪异的东西夜半惊梦了。它早就被他销毁，在地球另一边的大英帝国。他起身看着镜子里自己五官深邃的脸，眼神迷离起来。这张亚洲脸上隐隐约约有白人的痕迹，源于他来自俄罗斯的祖母。这常让他被错当成图兰人。他一直为自己的中国',
            style: TextStyle(color: Colors.black,fontSize: 18, fontStyle: FontStyle.italic),
          ),
        ],
      ),
    );
  }
}

class Bookshelf_Book4_Detail extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Image(
            image: AssetImage('images/shuihu.jpg'),
            width: 200,
            height: 200,
          ),
          SizedBox(height: 16),
          Text(
            '元末明初施耐庵',
            style: TextStyle(color: Colors.black,fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          Text(
            '是以宋江领导的起义军为主要题材，通过一系列梁山英雄反抗压迫、英勇斗争的生动故事，暴露了北宋末年统治阶级的腐朽和残暴，揭露了当时尖锐对立的社会矛盾和“官逼民反”的残酷现实。',
            style: TextStyle(color: Colors.black,fontSize: 18, fontStyle: FontStyle.italic),
          ),
        ],
      ),
    );
  }
}

class Category_Boy extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text('afgafagagaga'));
  }
}

class Category_Girl extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
       
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Category_Girl_Book1_Detail()),
                        );
                      },
                      child: Image(
                        image: AssetImage("images/jianai.jpg"),
                        width: 200,
                        height: 200,
                      ),
                    ),
                    Text('简爱'),
                  ],
                ),
                Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Category_Girl_Book2_Detail()),
                        );
                      },
                      child: Image(
                        image: AssetImage('images/xiaofuren.jpg'),
                        width: 200,
                        height: 200,
                      ),
                    ),
                    Text('小妇人'),
                  ],
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Category_Girl_Book3_Detail()),
                        );
                      },
                      child: Image(
                        image: AssetImage('images/piao.jpg'),
                        width: 200,
                        height: 200,
                      ),
                    ),
                    Text('飘'),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class Category_Sellable extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Category_Sellable_Book1_Detail()),
                        );
                      },
                      child: Image(
                        image: AssetImage("images/xinhua.jpg"),
                        width: 200,
                        height: 200,
                      ),
                    ),
                    Text('新华字典'),
                  ],
                ),
                Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Category_Sellable_Book2_Detail()),
                        );
                      },
                      child: Image(
                        image: AssetImage('images/yueliang.jpg'),
                        width: 200,
                        height: 200,
                      ),
                    ),
                    Text('月亮与六便士'),
                  ],
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Category_Sellable_Book3_Detail()),
                        );
                      },
                      child: Image(
                        image: AssetImage('images/bainian.jpg'),
                        width: 200,
                        height: 200,
                      ),
                    ),
                    Text('百年孤独'),
                  ],
                ),
                Column(
                  children: [

                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class Category_Boy_Book1_Detail extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text('afgafagagaga'));
  }
}

class Category_Boy_Book2_Detail extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text('afgafagagaga'));
  }
}

class Category_Boy_Book3_Detail extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text('afgafagagaga'));
  }
}

class Category_Girl_Book1_Detail extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Image(
            image: AssetImage('images/jianai.jpg'),
            width: 200,
            height: 200,
          ),
          SizedBox(height: 16),
          Text(
            '英国夏洛蒂·勃朗特',
            style: TextStyle(color: Colors.black,fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          Text(
            '该小说讲述了失去父母的女孩简被庄园主人罗切斯特暗恋，在偶然得知罗切斯特是有妇之夫，而且还向她隐瞒了惊人真相后，简陷入了迷茫、挣扎、苦痛的故事，暴露和批判了西方资本主义社会黑暗面。',
            style: TextStyle(color: Colors.black,fontSize: 18, fontStyle: FontStyle.italic),
          ),
        ],
      ),
    );
  }
}

class Category_Girl_Book2_Detail extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Image(
            image: AssetImage('images/xiaofuren.jpg'),
            width: 200,
            height: 200,
          ),
          SizedBox(height: 16),
          Text(
            '美国路易莎·梅·奥尔科特',
            style: TextStyle(color: Colors.black,fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          Text(
            '该作是一部以美国南北战争为背景，以19世纪美国新英格兰地区的一个普通家庭四个姐妹之间的生活琐事为蓝本的带有自传色彩的家庭伦理小说。',
            style: TextStyle(color: Colors.black,fontSize: 18, fontStyle: FontStyle.italic),
          ),
        ],
      ),
    );
  }
}

class Category_Girl_Book3_Detail extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Image(
            image: AssetImage('images/piao.jpg'),
            width: 200,
            height: 200,
          ),
          SizedBox(height: 16),
          Text(
            '美国玛格丽特·米切尔',
            style: TextStyle(color: Colors.black,fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          Text(
            '该作以亚特兰大以及附近的一个种植园为故事场景，描绘了内战前后美国南方人的生活。 以主人公的爱情纠缠为主线，成功地再现了 林肯 时期的南北战争以及美国南方地区的社会生活。',
            style: TextStyle(color: Colors.black,fontSize: 18, fontStyle: FontStyle.italic),
          ),
        ],
      ),
    );
  }
}

class Category_Sellable_Book1_Detail extends StatelessWidget {
  Widget build(BuildContext context) {
    return Center(
      child: Column(

        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Image(
            image: AssetImage('images/xinhua.jpg'),
            width: 200,
            height: 200,
          ),
          SizedBox(height: 16),
          Text(
            '新中国成立后出版的第一部以白话释义、用白话举例的字典',
            style: TextStyle(
                color: Colors.black,
                backgroundColor: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold
            ),
          ),
          SizedBox(height: 16),
          Text(
            '自出版以来，为中国文化水平的提高作出了历史性的贡献。',
            style: TextStyle(
              color: Colors.black,
              backgroundColor: Colors.white,
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }
}

class Category_Sellable_Book2_Detail extends StatelessWidget {
  Widget build(BuildContext context) {
    return Center(
      child: Column(

      ),
    );
  }
}

class Category_Sellable_Book3_Detail extends StatelessWidget {
  Widget build(BuildContext context) {
    return Center(
      child: Column(

      ),
    );
  }
}
