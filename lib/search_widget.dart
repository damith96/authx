import 'package:authx_cs_usj/size_cofig.dart';
import 'package:flutter/material.dart';

class SearchWidget extends StatefulWidget {
  final String text;
  final ValueChanged<String> onChanged;
  final String hintText;

  const SearchWidget({
    required this.text,
    required this.onChanged,
    required this.hintText
  });

  @override
  _SearchWidgetState createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {

  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final isPortrait = Orientation.portrait == MediaQuery.of(context).orientation;
    final isMobileLandsCape = MediaQuery.of(context).size.height < 650 && !isPortrait;
    SizedConfig().init(context);
    final styleActive = TextStyle(color: Colors.black,fontSize: isMobileLandsCape ? 4.5*SizedConfig.heightMultiplier : 3*SizedConfig.heightMultiplier);
    final styleHint = TextStyle(color: Colors.black54,fontSize: isMobileLandsCape ? 4.5*SizedConfig.heightMultiplier : 3*SizedConfig.heightMultiplier);
    final style = widget.text.isEmpty ? styleHint : styleActive;

    return Container(
      alignment: Alignment.center,
      height: isPortrait?8 * SizedConfig.heightMultiplier: 12 * SizedConfig.heightMultiplier,
      margin: EdgeInsets.only(top:3*SizedConfig.heightMultiplier),
      padding: EdgeInsets.only(left: 6*SizedConfig.widthMultiplier,right: 2*SizedConfig.widthMultiplier),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(1.5*SizedConfig.heightMultiplier),
        color: Color(0xffaa9cb8),
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          //icon: Icon(Icons.search, color: style.color,size: isMobileLandsCape ? 5*SizedConfig.heightMultiplier : 3.5*SizedConfig.heightMultiplier,),
          suffixIcon: widget.text.isNotEmpty
              ? GestureDetector(
                  child: Icon(Icons.close, color: style.color,size: isMobileLandsCape ? 5*SizedConfig.heightMultiplier : 3.5*SizedConfig.heightMultiplier),
                  onTap: () {
                    controller.clear();
                    widget.onChanged('');
                    FocusScope.of(context).requestFocus(FocusNode());
                  },
                )
              : null,
          hintText: widget.hintText,
          hintStyle: style,
          border: InputBorder.none,
        ),
        style: TextStyle(color: Colors.black,fontSize: isMobileLandsCape ? 4.5*SizedConfig.heightMultiplier : 3*SizedConfig.heightMultiplier),
        cursorColor: Colors.black,
        onChanged: widget.onChanged,
      ),
    );
  }

}