

import 'package:eyedetector/const/appColor.dart';
import 'package:eyedetector/model/user.dart';
import 'package:eyedetector/provider/userProvider.dart';
import 'package:eyedetector/widget/textField.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'const/appConsts.dart';
import 'helpers/sharedPre.dart';

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
    String selectedItem = 'Male';

    bool isEmptyBirthday=false;

  final List<String> genderList = ['Male', 'Female'];
  final List<String> colorEyeList = ['Unknown', 'Black', 'Blue', 'Brown', 'Dichromatic', 'Gray', 'Green', 'Hazel', 'Maroon', 'Pink'];
  String selectedColor = 'Green';
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
    final UserProvider provider = Provider.of<UserProvider>(context);


    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Center(
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  const Center(child:  Text("Login Form",style: TextStyle(fontSize: 24,color: Colors.black,fontWeight:  FontWeight.w500),)),
                  const SizedBox(height: 20,),
                  const Center(child:    Text("Kindly provide the required information to log in ",      style: TextStyle(fontSize: 14, color: Colors.grey),    )),
                  const SizedBox(height: 40,),
                  CustomTextFormField(controller: name, prefixIcon: Icons.person, textInputType: TextInputType.text, hintText: 'Name',),
                  //const SizedBox(height: 20,),
                  CustomTextFormField(controller: surname, prefixIcon: Icons.person, textInputType: TextInputType.text, hintText: 'Surname',),
                 // const SizedBox(height: 20,),
                  CustomTextFormField(controller: email, prefixIcon: Icons.email, textInputType: TextInputType.emailAddress, hintText: 'Email',),

                 // CustomTextFormField(controller: phone, prefixIcon: Icons.phone, textInputType: TextInputType.phone, hintText: 'Phone',),
                  const Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text("Eye Color"),
                  ),
                  Container(
                      width: MediaQuery.of(context).size.width*0.95,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: Colors.white,
                          border: Border.all(
                              color: textfieldbg
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
                                value: selectedColor,


                                onChanged: (newValue) {
                                  setState(() {
                                    selectedColor = newValue!;
                                  });
                                },
                                hint: const Text("Eye Color"),
                                icon: Icon(Icons.abc, color: Colors.transparent), // Remove the icon
                                underline: Container(),
                                padding: const EdgeInsets.only(left: 0, right: 20, top: 0),
                                alignment: Alignment.center,
                                // Set a value greater than or equal to kMinInteractiveDimension
                                itemHeight: kMinInteractiveDimension,
                                menuMaxHeight: 200,
                                items: colorEyeList.map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: SizedBox(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 8.0,),
                                        child: Center(
                                          child: Text(
                                            value,
                                            style: TextStyle(color: Colors.black, fontSize: 12),
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

                 /* const SizedBox(height: 20,),
                  Container(
                      width: MediaQuery.of(context).size.width*0.95,
                             decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                             color: Colors.white,
                                border: Border.all(
                                  color: textfieldbg
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
                                      },
                                      hint: const Text("Gender"),
                                      icon: Icon(Icons.abc, color: Colors.transparent), // Remove the icon
                                      underline: Container(),
                                      padding: const EdgeInsets.only(left: 0, right: 20, top: 0),
                                      alignment: Alignment.center,
                                      // Set a value greater than or equal to kMinInteractiveDimension
                                      itemHeight: kMinInteractiveDimension,
                                      menuMaxHeight: 200,
                                      items: genderList.map((String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: SizedBox(
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(vertical: 8.0,),
                                              child: Center(
                                                child: Text(
                                                  value,
                                                  style: TextStyle(color: Colors.black, fontSize: 12),
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

                            )),*/
                  const Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text("Birth Date"),
                  ),
                  Container(
                        width: MediaQuery.of(context).size.width*0.95,
                        decoration: BoxDecoration(
                          color: Colors.white,
                            borderRadius: BorderRadius.circular(10.0),
                          border: Border.all(
                            color:isEmptyBirthday? Colors.red: textfieldbg
                          )
                        ),
                         child: ElevatedButton(
                          onPressed: () => _selectDate(context),


                           style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                               elevation: 0,
                              padding:const EdgeInsets.symmetric(horizontal: 20, vertical: 0), // Button padding
                              shape: RoundedRectangleBorder(

                                borderRadius: BorderRadius.circular(20.0), // Button border radius
                             ),
                         ),
                          child: Row(
                            children:  [
                              Icon(Icons.date_range,color: isEmptyBirthday? Colors.red: primaryColor,size: 16,),
                              const SizedBox(width: 10),
                              birthday.text.isEmpty ?
                              const Text(
                                'Birth day',
                                style:
                                 TextStyle(
                                    fontFamily: 'myriad',

                                    fontSize: 12,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.grey
                                ),
                              ):
                              Text(
                                birthday.text,
                                style:
                                    const TextStyle(color: Colors.black,fontSize: 15,fontWeight: FontWeight.w400),
                              )
                            ],
                          ),
                                             ),
                       ),
                  const SizedBox(height: 40,),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: ElevatedButton(onPressed: (){
                      if(_formKey.currentState!.validate() && birthday.text.isNotEmpty){

                       userModel = UserModel(
                        name: name.text,
                        email: email.text,
                        surname: surname.text,
                        phone: phone.text,
                        gender: selectedItem,
                        birthday: birthday.text,
                        eyeColor: selectedColor
                      );

                              provider.register(userModel!, context) ;
                    //




                      }    else {
                        setState(() {
                          isEmptyBirthday=true;
                        });
                      }


                     },
                       style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 20,vertical: 15),
                           backgroundColor: Colors.blueAccent, // Button padding
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0), // Button border radius
                        )),

                     child: provider.isLoading?Center(child: CircularProgressIndicator()):Text("Login",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),)),
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