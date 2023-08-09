

import 'package:eyedetector/const/appColor.dart';
import 'package:eyedetector/faceDetection.dart';
import 'package:eyedetector/helpers/navigator.dart';
import 'package:eyedetector/model/user.dart';
import 'package:eyedetector/widget/textField.dart';
import 'package:flutter/material.dart';

class FormPage extends StatefulWidget {
  const FormPage({super.key});

  @override
  State<FormPage> createState() => _FormPagetState();
}

class _FormPagetState extends State<FormPage> {
  TextEditingController name=TextEditingController();
  TextEditingController surname=TextEditingController();
  TextEditingController phone=TextEditingController();
  TextEditingController email=TextEditingController();
  TextEditingController gender=TextEditingController();
  TextEditingController birthday=TextEditingController();

  UserModel? userModel;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    String selectedItem = 'male';
    bool isEmptyBirthday=false;

  final List<String> languages = ['male', 'female'];


    DateTime selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1960),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
          selectedDate = picked;
          isEmptyBirthday=false;
          birthday.text = "${picked.toLocal()}".split(' ')[0];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Center(
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text("Complete the Form",style: TextStyle(fontSize: 22,color: primaryColor),),
                  const SizedBox(height: 40,),
                  CustomTextFormField(controller: name, prefixIcon: Icons.person, textInputType: TextInputType.text, hintText: 'name',),
                  const SizedBox(height: 20,),
                  CustomTextFormField(controller: surname, prefixIcon: Icons.person, textInputType: TextInputType.text, hintText: 'surname',),
                  const SizedBox(height: 20,),
                  CustomTextFormField(controller: email, prefixIcon: Icons.email, textInputType: TextInputType.emailAddress, hintText: 'email',),
                  const SizedBox(height: 20,),
                  CustomTextFormField(controller: phone, prefixIcon: Icons.phone, textInputType: TextInputType.phone, hintText: 'phone',),
                  const SizedBox(height: 20,),
                    Container(
                      width: MediaQuery.of(context).size.width*0.9,
                             decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.0),
                                border: Border.all(
                                  color: primaryColor
                                )
                              ),
                            child: Center(
                              child: Row(
                                children: [ 
                                  const SizedBox(width: 10,),
                                  Icon(Icons.trending_up,color: primaryColor,size: 20,),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width*0.7,
                                    child:  DropdownButton<String>(
                                      value: selectedItem,
                                      onChanged: (newValue) {
                                        setState(() {
                                          selectedItem = newValue!;
                                        });
                                        print('Selected item: $newValue');
                                      },
                                      hint: const Text("Gender"),
                                      icon: Icon(Icons.abc, color: Colors.transparent), // Remove the icon
                                      underline: Container(),
                                      padding: const EdgeInsets.only(left: 0, right: 20, top: 0),
                                      alignment: Alignment.center,
                                      // Set a value greater than or equal to kMinInteractiveDimension
                                      itemHeight: kMinInteractiveDimension,
                                      menuMaxHeight: 200,
                                      items: languages.map((String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: SizedBox(
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(vertical: 8.0,),
                                              child: Center(
                                                child: Text(
                                                  value,
                                                  style: TextStyle(color: Colors.grey, fontSize: 12),
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                    ),

                                  ),
                                ],
                              ),
                            
                            )),
                            const SizedBox(height: 20,),
                 
                 Container(
                        width: MediaQuery.of(context).size.width*0.9,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.0),
                          border: Border.all(
                            color:isEmptyBirthday? Colors.red: primaryColor
                          )
                        ),
                         child: ElevatedButton(
                          onPressed: () => _selectDate(context),


                           style: ElevatedButton.styleFrom(
                            primary: Colors.white,
                               elevation: 0,
                              padding:const EdgeInsets.symmetric(horizontal: 20, vertical: 12), // Button padding
                              shape: RoundedRectangleBorder(
                              
                                borderRadius: BorderRadius.circular(20.0), // Button border radius
                             ),
                         ),
                          child: Row(
                            children:  [
                              Icon(Icons.date_range,color: isEmptyBirthday? Colors.red: primaryColor),
                              const SizedBox(width: 10),
                              birthday.text.isEmpty ?
                              const Text(
                                'Birth day',
                                style:
                                    TextStyle(color: Colors.grey,fontSize: 12),
                              ):
                              Text(
                                birthday.text,
                                style:
                                    const TextStyle(color: Colors.black,fontSize: 14),
                              )
                            ],
                          ),
                                             ),
                       ),
                       
                       SizedBox(height: 20,),
                  SizedBox(
                    width: MediaQuery.of(context).size.width*0.9,
                    child: ElevatedButton(onPressed: (){
                      if(_formKey.currentState!.validate() ){
                          if( birthday.text.isNotEmpty){
                              userModel = UserModel(
                        name: name.text,
                        email: email.text,
                        surname: surname.text,
                        phone: phone.text,
                        gender: selectedItem,
                        birthday: birthday.text,
                      );
                      print("-------${userModel.toString}------");
                      push(context: context, screen: FaceDetectorView(userModel: userModel,));
                         
                          }
                          else {
                            setState(() {
                              isEmptyBirthday=true;
                            });
                          }
                      
                      }

                     
                     }, 
                       style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12), // Button padding
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0), // Button border radius
                        ),
  ),
                     
                     child: Text("Next")),
                  )     
                  
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}