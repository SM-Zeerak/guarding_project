import 'package:flutter/material.dart';
import 'package:guarding_project/utils/color_utils.dart';
import 'package:guarding_project/utils/textStyle_utils.dart';

class SettingCards extends StatelessWidget {
  final String icon;
  final String text;
  final Function()? ontap;
  const SettingCards({
    super.key,
    required this.icon,
    required this.text,
    this.ontap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: ontap,
      child: Container(
        width: double.infinity,
        // height: 55,
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            offset: Offset(0, 4),
            blurRadius: 6,
            spreadRadius: 1,
          ),
        ], borderRadius: BorderRadius.circular(10), color: Colors.white),
        child: Padding(
          padding: const EdgeInsets.only(right: 14),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                child: Row(
                  children: [
                    Container(
                        width: 50,
                        height: 50,
                        child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.asset(icon,fit: BoxFit.fill,)
                            // SvgPicture.asset(icon),
                            )),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      text,
                      style: TextStylesUtils.custom(
                          fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: ClrUtls.grey,
              )
            ],
          ),
        ),
      ),
    );
  }
}
