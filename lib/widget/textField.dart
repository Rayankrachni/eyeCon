
import 'package:eyedetector/const/appColor.dart';
import 'package:flutter/material.dart';


class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.prefixIcon,
    this.obscureText = false,
    this.lines=1,
    this.iconColor=primaryColor,
    this.suffixIcon,
    this.onTapSuffix,
    required this.textInputType,
  });

  final TextEditingController controller;
  final String hintText;
  final IconData prefixIcon;
  final bool obscureText;
  final int lines;
  final Color iconColor;
  final IconData? suffixIcon;
  final Function()? onTapSuffix;
  final TextInputType textInputType;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration:const BoxDecoration(
        //color: textfieldbg.withOpacity(0.2),
        
         borderRadius:BorderRadius.all(Radius.circular(10)),
      ),
      
      child: TextFormField(
        controller: controller,
    
        validator: (value) {
          if (value!.isEmpty) {
            
            return 'Complete the field';
            
          }
          return null;
        },
        keyboardType: textInputType,
        textInputAction: TextInputAction.next,
    
        style:const TextStyle(color: Colors.black),
        obscureText: obscureText,
        maxLines: lines,
        
        decoration: InputDecoration(
          hintText: hintText,
    
          contentPadding: const EdgeInsets.symmetric(
            vertical: 5.0,
            horizontal: 20.0,
          ),
          prefixIcon: Icon(
            prefixIcon,
            color: iconColor,
            size: 17,
          ),
          hintStyle: const TextStyle(
            fontFamily: 'myriad',
            
            fontSize: 14,
            color: Colors.grey
          ),
    
          suffix: suffixIcon != null
              ? InkWell(
                onTap: onTapSuffix,
                child: Icon(
                  suffixIcon,
                  color: primaryColor,
                  size: 20,
                ),
              )
              : null,
          enabledBorder:const OutlineInputBorder(
            borderRadius:BorderRadius.all(Radius.circular(10)),
            borderSide: BorderSide(
              width: 1,
              color: textfieldbg,
            ),
          ),
          focusedErrorBorder:const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            borderSide:  BorderSide(
              width: 1,
              color: Colors.red,
            ),
          ),
          focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            borderSide: BorderSide(
              width: 1,
              color: primaryColor,
            ),
          ),
          errorBorder:const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10),),
            borderSide:  BorderSide(
              width: 1,
              color: Colors.red,
            ),
          ),
        ),
      ),
    );
  }
}