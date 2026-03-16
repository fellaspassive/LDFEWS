import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';


class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage>{

  bool isPasswordHidden = true;
  bool isConfirmedPasswordHidden =  true;
  bool isPasswordMatch = true;
  bool isTermsAccepted = false;
  int passwordStrength = 0;
  String strengthText = "Weak";
  Color strengthColor = Colors.red;
  int verifyButtonCount = 60;
  bool isVerifyButtonPressed = false;
  Timer?timer;
  bool isTimerRunning = false;
  

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();


  bool emailFormatValidityChecker(String email){
    return RegExp(
      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
    ).hasMatch(email);
  }
  void checkPasswordStrength(String password){
    int strength = 0;

    if (password.length >= 8) strength++;
    if (password.contains(RegExp(r'[A-Z]'))) strength++;
    if (password.contains(RegExp(r'[0-9]'))) strength++;
    if (password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]_'))) strength++;

    setState((){
      passwordStrength = strength;
    if (strength <= 1) {
        strengthText = "Weak";
        strengthColor = Colors.red;
    } else if (strength == 2) {
        strengthText = "Fair";
        strengthColor = Colors.orange;
    } else if (strength == 3) {
        strengthText = "Strong";
        strengthColor = Colors.blue;
    } else {
        strengthText = "Very Strong";
        strengthColor = Colors.green;
    }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 240, 245, 250),
      appBar: AppBar(
        title: const Text(
          "Create Account",
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 2, 62, 138),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                const SizedBox(height: 10),
                
                // Logo and welcome message
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 2, 62, 138).withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.water_drop,
                        size: 24,
                        color: Color.fromARGB(255, 2, 62, 138),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Join LDFEWS",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Color.fromARGB(255, 2, 62, 138),
                          ),
                        ),
                        Text(
                          "Create your monitoring account",
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                
                const SizedBox(height: 30),
                
                // Sign Up Form Card
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                    border: Border.all(
                      color: Colors.white.withOpacity(0.5),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Personal Information Section
                      Row(
                        children: [
                          Container(
                            width: 4,
                            height: 18,
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 2, 62, 138),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            "Personal Information",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 20),
                      
                      // Full Name Field
                      TextField(
                        controller: nameController,
                        decoration: InputDecoration(
                          labelText: "Full Name",
                          labelStyle: const TextStyle(color: Colors.grey),
                          hintText: "Enter your full name",
                          prefixIcon: const Icon(Icons.person_outline, color: Colors.grey, size: 20),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.grey.shade50,
                          contentPadding: const EdgeInsets.symmetric(vertical: 14),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: const Color.fromARGB(255, 2, 62, 138).withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 16),
                      // E-mail Verification
                      TextField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: "Email Address",
                          labelStyle: const TextStyle(color: Colors.grey),
                          hintText: "Enter your email",
                          prefixIcon: const Icon(
                            Icons.email_outlined,
                            color: Colors.grey,
                            size: 20,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.grey.shade50,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 14,
                            horizontal: 12,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: const Color.fromARGB(255, 2, 62, 138)
                                  .withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),
                      
                      // Phone Number Field
                      TextField(
                        controller: phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          labelText: "Phone Number (Optional)",
                          labelStyle: const TextStyle(color: Colors.grey),
                          hintText: "Enter your phone number",
                          prefixIcon: const Icon(Icons.phone_outlined, color: Colors.grey, size: 20),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.grey.shade50,
                          contentPadding: const EdgeInsets.symmetric(vertical: 14),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: const Color.fromARGB(255, 2, 62, 138).withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Security Section
                      Row(
                        children: [
                          Container(
                            width: 4,
                            height: 18,
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 2, 62, 138),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            "Security",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 20),
                      
                      // Password Field
                      TextField(
                        controller: passwordController,
                        obscureText: isPasswordHidden,
                        onChanged: (value) {
                          checkPasswordStrength(value);
                        },
                        decoration: InputDecoration(
                          labelText: "Password",
                          labelStyle: const TextStyle(color: Colors.grey),
                          hintText: "Create a strong password",
                          prefixIcon: const Icon(Icons.lock_outline, color: Colors.grey, size: 20),
                          suffixIcon: IconButton(
                            icon: Icon(
                              isPasswordHidden ? Icons.visibility_off : Icons.visibility,
                              color: Colors.grey.shade400, size: 18
                            ),
                            onPressed: () {
                            setState(() {
                              isPasswordHidden = !isPasswordHidden;
                            });
                            },
                          ),
  
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.grey.shade50,
                          contentPadding: const EdgeInsets.symmetric(vertical: 14),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: const Color.fromARGB(255, 2, 62, 138).withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 8),
                      
                      // Password strength indicator
                      Row(
                            children: [
                              ...List.generate(4, (index) {
                                return Expanded(
                                  child: Container(
                                    height: 4,
                                    margin: const EdgeInsets.only(right: 4),
                                    decoration: BoxDecoration(
                                      color: index < passwordStrength
                                          ? strengthColor
                                          : Colors.grey.shade200,
                                      borderRadius: BorderRadius.circular(2),
                                    ),
                                  ),
                                );
                              }),
                            ],
                          ),
                      
                      const SizedBox(height: 4),
                      
                      Text(
                        "Password strength: $strengthText",
                        style: TextStyle(
                          fontSize: 11,
                          color: strengthColor,
                        ),
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Confirm Password Field
                      TextField(
                        controller: confirmController,
                        obscureText: isConfirmedPasswordHidden,
                        onChanged: (value){
                          setState((){
                            isPasswordMatch = value == passwordController.text;
                          });
                        },
                        decoration: InputDecoration(
                          labelText: "Confirm Password",
                          labelStyle: const TextStyle(color: Colors.grey),
                          hintText: "Re-enter your password",
                          prefixIcon: const Icon(Icons.lock_outline, color: Colors.grey, size: 20),
                          suffixIcon: IconButton(
                            icon: Icon(
                            isConfirmedPasswordHidden ? Icons.visibility_off : Icons.visibility,
                            color: Colors.grey.shade400,
                            size: 18),
                          onPressed: () {
                            setState((){
                              isConfirmedPasswordHidden = !isConfirmedPasswordHidden;
                            });
                          },
                        ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.grey.shade50,
                          contentPadding: const EdgeInsets.symmetric(vertical: 14),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: const Color.fromARGB(255, 2, 62, 138).withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 20),
                      
                      // Terms and Conditions
                      Row(
                        children: [
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: Checkbox(
                              value: isTermsAccepted,
                              onChanged: (value) {
                                setState(() {
                                  isTermsAccepted = value!;
                                });
                              },
                              activeColor: const Color.fromARGB(255, 2, 62, 138),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: RichText(
                              text: TextSpan(
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade600,
                                ),
                                children: [
                                  const TextSpan(
                                    text: "I agree to the ",
                                  ),
                                  TextSpan(
                                    text: "Terms of Service",
                                    style: TextStyle(
                                      color: const Color.fromARGB(255, 2, 62, 138),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const TextSpan(
                                    text: " and ",
                                  ),
                                  TextSpan(
                                    text: "Privacy Policy",
                                    style: TextStyle(
                                      color: const Color.fromARGB(255, 2, 62, 138),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Sign Up Button
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          onPressed: () async {
                            String name = nameController.text.trim();
                            String email = emailController.text.trim();
                            String pass = passwordController.text.trim();
                            String confirm = confirmController.text.trim();
                            String phone = phoneController.text.trim();

                            if (name.isEmpty || email.isEmpty || pass.isEmpty || confirm.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: const Text("Please fill all required fields"), backgroundColor: Colors.orange.shade700),
                              );
                              return;
                            }

                            if (pass != confirm) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: const Text("Passwords do not match"), backgroundColor: Colors.red.shade400),
                              );
                              return;
                            }

                            if (pass.length < 6) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: const Text("Password must be at least 6 characters"), backgroundColor: Colors.orange.shade700),
                              );
                              return;
                            }

                            if (!isTermsAccepted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: const Text("You must accept the Terms of Service"), backgroundColor: Colors.orange.shade700),
                              );
                              return;
                            }

                            try {
                              // 1️Create user in Firebase Auth
                              print('Signup: starting createUserWithEmailAndPassword for $email');
                              UserCredential userCredential = await FirebaseAuth.instance
                                  .createUserWithEmailAndPassword(email: email, password: pass);
                              print('Signup: user created with uid: ${userCredential.user?.uid}');

                              //  Save additional user info in Firestore
                              await FirebaseFirestore.instance        
                                  .collection('users')
                                  .doc(userCredential.user!.uid)
                                  .set({
                                'name': name,
                                'email': email,
                                'phone': phone,
                                'createdAt': FieldValue.serverTimestamp(),
                              });
                              print('Signup: user document written to Firestore');

                              try{
                                await userCredential.user!.sendEmailVerification();
                               showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (context) {
                                  return AlertDialog(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    title: const Column(
                                      children: [
                                        Icon(
                                          Icons.mark_email_read,
                                          size: 48,
                                          color: Color.fromARGB(255, 2, 62, 138),
                                        ),
                                        SizedBox(height: 12),
                                        Text(
                                          "Verify Your Email",
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w600,
                                            color: Color.fromARGB(255, 2, 62, 138),
                                          ),
                                        ),
                                      ],
                                    ),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          "A verification email has been sent to:",
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey.shade600,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                        const SizedBox(height: 8),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                          decoration: BoxDecoration(
                                            color: Colors.grey.shade100,
                                            borderRadius: BorderRadius.circular(30),
                                          ),
                                          child: Text(
                                            FirebaseAuth.instance.currentUser?.email ?? "",
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              color: Color.fromARGB(255, 2, 62, 138),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 16),
                                        const Text(
                                          "Please check your inbox and verify your email before logging in.",
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: Colors.black87,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () async {
                                          await FirebaseAuth.instance.currentUser!
                                              .sendEmailVerification();
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              content: const Text("Verification email resent!"),
                                              behavior: SnackBarBehavior.floating,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                            ),
                                          );
                                        },
                                        style: TextButton.styleFrom(
                                          foregroundColor: const Color.fromARGB(255, 2, 62, 138),
                                        ),
                                        child: const Text("Resend"),
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                          Navigator.pop(context);
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color.fromARGB(255, 2, 62, 138),
                                          foregroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                        ),
                                        child: const Text("OK"),
                                      ),
                                    ],
                                  );
                                },
                              );
                            }catch (e) {
                              print("Failed to send verification email: $e");
                            }
                               

                              // Success
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: const Text("Account created successfully!"), backgroundColor: Colors.green.shade600),
                              );
                            } on FirebaseAuthException catch (e) {
                              // Detailed logging for Firebase auth errors
                              print('FirebaseAuthException during signup');
                              print('  code   : ${e.code}');
                              print('  message: ${e.message}');

                              String message = "An error occurred";
                              if (e.code == 'email-already-in-use') message = "This email is already in use";
                              if (e.code == 'invalid-email') message = "Invalid email address";
                              if (e.code == 'weak-password') message = "Password is too weak";

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text("$message (code: ${e.code})"),
                                  backgroundColor: Colors.red.shade400,
                                ),
                              );
                            } catch (e, stackTrace) {
                              // Print error in console for debugging
                              print('Unexpected signup error: $e');
                              print(stackTrace);

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text("Unexpected error: $e"),
                                  duration: const Duration(seconds: 3),
                                  behavior: SnackBarBehavior.floating,
                                  backgroundColor: Colors.red.shade400,
                                ),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(255, 2, 62, 138),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Create Account",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(width: 8),
                              Icon(Icons.person_add_alt_1, size: 18),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Login Link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already have an account? ",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: const Size(50, 30),
                      ),
                      child: const Text(
                        "Sign In",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color.fromARGB(255, 2, 62, 138),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}