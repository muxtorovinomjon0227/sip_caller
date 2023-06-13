import 'package:auto_animated/auto_animated.dart';
import 'package:flutter/material.dart';
import 'package:kothon_app/constants/kothon_colors.dart';
import 'package:kothon_app/presentation/common_widgets/kothon_header.dart';
import 'package:kothon_app/presentation/common_widgets/show_toast.dart';
import 'package:kothon_app/presentation/home/widgets/grid_utils.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    Key key,
  }) : super(key: key);
  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    //
    final sHeight = MediaQuery.of(context).size.height;
    // final sWidth = MediaQuery.of(context).size.width;
    //
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: sHeight * 0.5,
                padding: EdgeInsets.only(top: sHeight * 0.11),
                color: KothonColors.homeTopSectionBackground,
                child: LiveGrid(
                  padding: EdgeInsets.all(36),
                  showItemInterval: Duration(milliseconds: 60),
                  showItemDuration: Duration(milliseconds: 150),
                  visibleFraction: 0.001,
                  itemCount: 6,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 26,
                    mainAxisSpacing: 26,
                  ),
                  itemBuilder: animationItemBuilder(
                    (index) => HorizontalItem(
                      title: index.toString(),
                      onClick: () {
                        print(index);
                        switch (index) {
                          case 0:
                            {
                              print("aye 0");
                              // Navigator.push(
                              //   context,
                              //   Transition(
                              //     child: CommunicationHome(),
                              //     transitionEffect: TransitionEffect.fade,
                              //   ).builder(),
                              // );
                              Navigator.pushNamed(context, '/commHome');
                            }
                            break;
                          case 1:
                            {
                              futureToast(
                                  context: context, message: "Coming Soon!");
                              print("aye 1");
                            }
                            break;
                          case 2:
                            {
                              futureToast(
                                  context: context, message: "Coming Soon!");
                              print("aye 2");
                            }
                            break;
                          case 3:
                            {
                              futureToast(
                                  context: context, message: "Coming Soon!");
                              print("aye 3");
                            }
                            break;
                          case 4:
                            {
                              futureToast(
                                  context: context, message: "Coming Soon!");
                              print("aye 4");
                            }
                            break;
                          case 5:
                            {
                              futureToast(
                                  context: context, message: "Coming Soon!");
                              print("aye 5");
                            }
                            break;
                          default:
                            break;
                        }
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            top: 0,
            child: KothonHeader(),
          )
        ],
      ),
    );
  }
}
