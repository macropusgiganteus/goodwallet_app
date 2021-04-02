import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:goodwallet_app/Homepage.dart';
import 'package:goodwallet_app/SpeechConfirmation.dart';
import 'package:vector_math/vector_math_64.dart' as math;
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_page_transition/flutter_page_transition.dart';
import 'components/WalletSlider.dart';
import 'package:goodwallet_app/components/Header.dart';
import 'Manual_income.dart';
import 'SpeechConfirmation.dart';
import "dart:async";
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permission_handler/permission_handler.dart';

final noText = SnackBar(
  content: Text(
    'Speech undetected',
    textAlign: TextAlign.center,
    style: TextStyle(fontSize: 12.sp),
  ),
);

class VoiceInput extends StatefulWidget {
  final index;
  final firebaseInstance;
  VoiceInput(this.index, this.firebaseInstance);
  @override
  _VoiceInputState createState() => _VoiceInputState(index, firebaseInstance);
}

class _VoiceInputState extends State<VoiceInput> {
  final _walletIndex;
  final firebaseInstance;
  _VoiceInputState(this._walletIndex, this.firebaseInstance);
  //ui variables
  double _opacity = 1.0;
  double _textOpacity = 0.0;
  var _opacityDuration = const Duration(milliseconds: 500);
  var _animationDuration = const Duration(milliseconds: 600);

  //speech to text variables
  stt.SpeechToText _speech;

  bool _isListening = false;
  String _text = 'Press the button and start speaking';
  bool _buttonPressed = false;

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();

    Future askForPermissions() async {
      if (await Permission.microphone.request().isGranted) {
        // Either the permission was already granted before or the user just granted it.
      }
// You can request multiple permissions at once.
      Map<Permission, PermissionStatus> statuses = await [
        Permission.microphone,
      ].request();
      print(statuses[Permission.microphone]);
    }
  }

  @override
  Widget build(BuildContext context) {
    var _screenWidth = MediaQuery.of(context).size.width;
    var _screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        //Background Gradient Color
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xffAE90F4), Color(0xffDF8D9F)],
          ),
        ),

        child: Align(
          alignment: Alignment.center,
          child: Stack(
            alignment: AlignmentDirectional.center,
            children: [
              Column(
                children: [
                  Header(),
                  SizedBox(
                    height: 10.h,
                  ),
                  WalletSlider(firebaseInstance),
                  AnimatedOpacity(
                    duration: _opacityDuration,
                    opacity: _opacity,
                    child: Container(
                      height: 0.4.sh,
                      child: Stack(
                        children: [
                          Container(
                            width: 280.w,
                            child: Text(
                              'Example',
                              textAlign: TextAlign.left,
                              style: TextStyle(fontSize: 22.sp),
                            ),
                          ),
                          AnimatedPositioned(
                            duration: _animationDuration,
                            top: _buttonPressed ? 0 : 18.h,
                            child: VoiceExample('plus',
                                'รายรับ: ได้เงินจากแม่ 200 บาท', 0xff379243),
                          ),
                          AnimatedPositioned(
                            duration: _animationDuration,
                            top: _buttonPressed ? 0 : 102.h,
                            child: VoiceExample('minus',
                                'รายจ่าย: ซื้อข้าวกะเพรา 45 บาท', 0xffC3374E),
                          ),
                          AnimatedPositioned(
                            duration: _animationDuration,
                            top: _buttonPressed ? 0 : 184.h,
                            child: VoiceExample('transferLogo',
                                'การโอน: โอนเงิน 80 บาท', 0xffE1B152),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 60.h,
                    width: _screenWidth,
                  ),
                  Container(
                    child: Text(
                      'Press and hold the button\nto record your word',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16.sp),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 23.h),
                    height: 70.h,
                    width: 70.h,
                    child: Listener(
                        onPointerDown: (details) async {
                          setState(() {
                            _opacity = 0;
                            _textOpacity = 1;
                          });
                          _text = '';
                          _buttonPressed = true;
                          bool available = await _speech.initialize(
                            onStatus: (val) => print('onStatus: $val'),
                            onError: (val) => print('onError: $val'),
                          );
                          if (available) {
                            var locales = await _speech.locales();
                            var selectedLocale = locales[60];

                            setState(() => _isListening = true);
                            _speech.listen(
                              localeId: selectedLocale.localeId,
                              onResult: (val) => setState(() {
                                _text = val.recognizedWords;
                                setState(() {
                                  _text = _text;
                                });
                              }),
                            );
                          }
                        }, // recording
                        onPointerUp: (details) async {
                          _buttonPressed = false;
                          await Future.delayed(Duration(milliseconds: 1000));
                          setState(() => _isListening = false);
                          _speech.stop();
                          print('final result = ' + _text);
                          await Future.delayed(Duration(milliseconds: 1000));
                          setState(() {
                            _opacity = 1;
                            _textOpacity = 0;
                          });
                          if (_text != null && _text != '') {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ConfirmationMainPage(
                                        text: _text,
                                        index: _walletIndex,
                                        firebaseInstance: firebaseInstance,
                                      )),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(noText);
                          }
                        }, // stop recording
                        child: RadialProgress()),
                  )
                ],
              ),
              AnimatedOpacity(
                duration: _opacityDuration,
                opacity: _textOpacity,
                child: Container(
                  constraints: BoxConstraints(maxWidth: 0.8.sw),
                  margin: EdgeInsets.only(bottom: 150.h),
                  child: Text(
                    _text,
                    style: TextStyle(fontSize: 30.sp, color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(PageTransition(
                        type: PageTransitionType.rippleRightUp,
                        child: ManualIncome(_walletIndex, firebaseInstance)));
                  },
                  child: Container(
                    height: 0.07.sh,
                    width: 0.065.sh,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(60.r),
                        bottomLeft: Radius.circular(8.r),
                        topRight: Radius.circular(8.r),
                      ),
                      color: Colors.white,
                    ),
                    padding: EdgeInsets.symmetric(
                        vertical: 0.015.sh, horizontal: 0.015.sw),
                    child: SvgPicture.asset(
                      'images/edit.svg',
                      color: Color(0xffCB80AD),
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.bottomRight,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class VoiceExample extends StatelessWidget {
  @override
  final svg;
  final text;
  final color;
  VoiceExample(this.svg, this.text, this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 62.h,
      width: 280.w,
      margin: EdgeInsets.only(top: 22.h), //l r 44
      padding: EdgeInsets.symmetric(horizontal: 11.w),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
            color: Colors.white, width: 5.0.w, style: BorderStyle.solid),
        borderRadius: BorderRadius.all(Radius.circular(15.0.r)),
      ),
      child: Row(
        children: [
          Container(
            height: 20.h,
            width: 20.w,
            child: SvgPicture.asset(
              'images/$svg.svg',
              color: Color(this.color),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 10.w),
            child: Text(
              text,
              style: TextStyle(
                  color: Color(this.color),
                  fontSize: 16.sp,
                  fontFamily: 'Knit'),
            ),
          )
        ],
      ),
    );
  }
}

class RadialProgress extends StatefulWidget {
  final double goalCompleted = 0.0;

  @override
  _RadialProgressState createState() => _RadialProgressState();
}

class _RadialProgressState extends State<RadialProgress>
    with SingleTickerProviderStateMixin {
  AnimationController _radialProgressAnimationController;
  Animation<double> _progressAnimation;
  final Duration fadeInDuration = Duration(milliseconds: 500);
  final Duration fillDuration = Duration(seconds: 2);

  double progressDegrees = 0;
  var count = 0;

  @override
  void initState() {
    super.initState();
    _radialProgressAnimationController =
        AnimationController(vsync: this, duration: fillDuration);
    _progressAnimation = Tween(begin: 0.0, end: 360.0).animate(CurvedAnimation(
        parent: _radialProgressAnimationController, curve: Curves.easeIn))
      ..addListener(() {
        setState(() {
          progressDegrees = widget.goalCompleted * _progressAnimation.value;
        });
      });
    _radialProgressAnimationController.forward();
  }

  @override
  void dispose() {
    _radialProgressAnimationController.dispose();
    super.dispose();
  }

  bool _buttonPressed = false;
  bool _loopActive = false;
  double x = 0;

  void _increaseCounterWhilePressed() async {
    if (_loopActive) return; // check if loop is active

    _loopActive = true;
    while (_buttonPressed) {
      // do your thing
      setState(() {
        progressDegrees = widget.goalCompleted + x * _progressAnimation.value;
      });
      x += 0.01;
      // wait a second
      await Future.delayed(Duration(milliseconds: 50));
    }
    _loopActive = false;
  } // recording

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (details) {
        _buttonPressed = true;
        _increaseCounterWhilePressed();
      }, // recording
      onPointerUp: (details) {
        _buttonPressed = false;
        setState(() {
          progressDegrees = widget.goalCompleted + 0 * _progressAnimation.value;
        }); // stop recording
        x = 0;
      }, // stop recording
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: Colors.white,
            ),
            borderRadius: BorderRadius.all(Radius.circular(49.r))),
        child: CustomPaint(
          child: Container(
            height: 200.0.h,
            width: 200.0.h,
            //padding: EdgeInsets.symmetric(vertical: 40.0),
            child: Container(),
          ),
          painter: RadialPainter(progressDegrees),
        ),
      ),
    );
  }
}

class RadialPainter extends CustomPainter {
  double progressInDegrees;

  RadialPainter(this.progressInDegrees);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.black12
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8.0;

    Offset center = Offset(size.width / 2, size.height / 2);
    canvas.drawCircle(center, size.width / 2, paint);

    Paint progressPaint = Paint()
      ..shader = LinearGradient(
              colors: [Colors.red, Colors.purple, Colors.purpleAccent])
          .createShader(Rect.fromCircle(center: center, radius: size.width / 2))
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8.0;

    canvas.drawArc(
        Rect.fromCircle(center: center, radius: size.width / 2),
        math.radians(-90),
        math.radians(progressInDegrees),
        false,
        progressPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
