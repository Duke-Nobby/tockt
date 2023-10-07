import 'package:cardwiser/base/common_text_style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../generated/l10n.dart';
import '../utils/color_utils.dart';

class MessageDialog extends Dialog {
  String title;
  String message;
  String confirmText;
  Function()? onConfirmPressEvent;

  MessageDialog({
    Key? key,
    this.title = '',
    required this.message,
    this.confirmText = '',
    this.onConfirmPressEvent,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      child: Material(
        type: MaterialType.transparency,
        child: Container(
//          padding: EdgeInsets.all(15),
          child: Stack(
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  // 点击空白处
                  Navigator.pop(context);
                },
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    decoration: ShapeDecoration(
                      color: Color(0xffffffff),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(4.0),
                        ),
                      ),
                    ),
                    margin: const EdgeInsets.all(12.0),
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(0),
                          child: Stack(
                            alignment: AlignmentDirectional.centerEnd,
                            children: <Widget>[
                              Container(
                                padding: const EdgeInsets.only(left: 10, right: 10),
                                decoration: const BoxDecoration(
                                    color: Color(0xFFF5F6FA),
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(4.0),
                                      topRight: Radius.circular(4.0),
                                    )),
                                height: 45,
                                child: Center(
                                  child: Text(
                                    title.isEmpty ? S.of(context).str_tips : title,
                                    textAlign: TextAlign.center,
                                    style: CommonTextStyle.blackStyle(fontSize: 16),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          constraints: BoxConstraints(minHeight: 40.0),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: IntrinsicHeight(
                              child: Text(message, textAlign: TextAlign.left, style: CommonTextStyle.blackStyle(fontSize: 13)),
                            ),
                          ),
                        ),
                        _buildBottomButtonGroup(context),
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomButtonGroup(context) {
    var widgets = <Widget>[];
    widgets.add(_buildBottomPositiveButton(context));
    return Flex(
      direction: Axis.horizontal,
      children: widgets,
    );
  }

  Widget _buildBottomPositiveButton(context) {
    return Flexible(
      fit: FlexFit.tight,
      child: Container(
//        margin: ,
        padding: const EdgeInsets.only(left: 10, bottom: 10, right: 10),
        child: TextButton(
          style: ButtonStyle(backgroundColor: MaterialStateProperty.all(ColorUtils.topicTextColor)),
          onPressed: onConfirmPressEvent,
          child: Text(confirmText.isEmpty ? S.of(context).str_confirm : confirmText, textAlign: TextAlign.center, style: CommonTextStyle.whiteStyle()),
        ),
      ),
    );
  }

  static showToast(String message) {
    Fluttertoast.showToast(
        msg: message, toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.CENTER, timeInSecForIosWeb: 1, backgroundColor: Colors.black.withAlpha(200), textColor: Colors.white, fontSize: 15.0);
  }

  static showMessageDialog(BuildContext context, String message, Function() onConfirmPressEvent, {String title = '', String confirm = ''}) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return MessageDialog(
            message: message,
            title: title,
            confirmText: confirm,
            onConfirmPressEvent: onConfirmPressEvent,
          );
        });
  }

// static showAppUpdate(BuildContext context, String message, Function() update, Function() nextRemind) {
//   showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (context) {
//         return Material(
//             type: MaterialType.transparency,
//             child: Container(
//               child: Center(
//                   child: Container(
//                 width: Resized.of(context).getWidth(width: 281, widthDesign: 375),
//                 height: Resized.of(context).getWidth(width: 378, widthDesign: 375),
//                 decoration: BoxDecoration(
//                   image: DecorationImage(image: AssetImage('assets/images/upgrade_bg.png'), fit: BoxFit.cover),
//                 ),
//                 padding: EdgeInsets.only(top: Resized.of(context).getWidth(width: 231, widthDesign: 375), left: 37, right: 37),
//                 child: Column(
//                   children: <Widget>[
//                     Expanded(
//                       child: Container(
//                         margin: EdgeInsets.only(bottom: 15),
//                         child: ListView(
//                           children: <Widget>[
//                             Container(
//                               child: Text(
//                                 message,
//                                 style: ZbxTextStyle.textStyle(fontType: FontType.bold, fontSize: 12, color: ColorUtils.title2Color),
//                               ),
//                             )
//                           ],
//                         ),
//                       ),
//                     ),
//                     Container(
//                       width: double.infinity,
//                       height: Resized.of(context).getWidth(width: 40, widthDesign: 375),
//                       decoration: ShapeDecoration(shape: StadiumBorder(), color: ColorUtils.buttonColor),
//                       clipBehavior: Clip.antiAlias,
//                       child: TextButton(
//                         style: ButtonStyle(
//                             backgroundColor: MaterialStateProperty.all(ColorUtils.buttonColor), iconSize: MaterialStateProperty.all(Resized.of(context).getWidth(width: 40, widthDesign: 375))),
//                         child: Text(
//                           Translations.of(context).text('home_update_now'),
//                           style: ZbxTextStyle.textStyle(fontType: FontType.regular, fontSize: 15, color: ColorUtils.buttonTextColor),
//                         ),
//                         onPressed: update,
//                       ),
//                     ),
//                     Container(
//                       height: Resized.of(context).getWidth(width: 38, widthDesign: 375),
//                       color: Colors.amber,
//                       child: TextButton(
//                         style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.white)),
//                         onPressed: nextRemind,
//                         child: Text(
//                           Translations.of(context).text('home_next_remind'),
//                           style: ZbxTextStyle.textStyle(fontType: FontType.regular, fontSize: 11, color: Color(0xFF898989)),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               )),
//             ));
//       });
// }
}
