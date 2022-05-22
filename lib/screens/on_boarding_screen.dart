import 'package:flutter/material.dart';
import 'package:shopping_app/screens/login/login_screen.dart';
import 'package:shopping_app/shared/styles/colors.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class BoardingModel {
  late String image;
  late String title;
  late String body;

  BoardingModel(this.image, this.title, this.body);
}

class OnBoardingScreen extends StatefulWidget {
  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  var boardController = PageController();

  bool isLast = false;

  List<BoardingModel> board = [
    BoardingModel(
        'assets/images/board_1.png', 'Screen 1 title', 'Screen 1 body'),
    BoardingModel(
        'assets/images/board_2.png', 'Screen 2 title', 'Screen 2 body'),
    BoardingModel(
        'assets/images/board_3.png', 'Screen 3 title', 'Screen 3 body'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
              onPressed: (){
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) =>  LoginScreen()),
                );
              },
              child: const Text('SKIP',style: TextStyle(
                color: primaryColor,
                fontSize: 18,
                fontWeight: FontWeight.w600
              ),)
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                onPageChanged: (int index){
                  if(index == board.length -1){
                    setState(() {
                      isLast =true;
                    });
                  }else{
                    setState(() {
                      isLast = false;
                    });
                  }
                },
                controller: boardController,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) => boardingItem(board[index]),
                itemCount: 3,
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            Row(
              children: [
                SmoothPageIndicator(
                    controller: boardController,
                    effect: const ExpandingDotsEffect(
                      spacing: 5,
                      expansionFactor: 4,
                      dotColor: Colors.grey,
                      dotWidth: 8,
                      dotHeight: 10
                    ),
                    count: board.length
                ),
                const Spacer(),
                FloatingActionButton(
                  onPressed: () {

                    if(isLast){
                      Navigator.push(context,
                          MaterialPageRoute(
                              builder: (context) =>  LoginScreen()));
                    }else{
                      boardController.nextPage(
                          duration: const Duration(milliseconds: 750),
                          curve: Curves.decelerate
                      );
                    }

                  },
                  child: const Icon(Icons.arrow_forward_ios),
                  backgroundColor: primaryColor,
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget boardingItem(BoardingModel model) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Image(image: AssetImage(model.image)),
          ),
          const SizedBox(
            height: 15,
          ),
          Text(
            model.title,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 15,
          ),
          Text(
            model.body,
            style: const TextStyle(fontSize: 18),
          ),
        ],
      );
}
