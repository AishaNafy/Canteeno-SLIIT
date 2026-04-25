import 'package:flutter/material.dart';
import 'dart:math';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen>
    with SingleTickerProviderStateMixin {
  /// 0 = Enter Email, 1 = Verify Code, 2 = New Password, 3 = Success
  int currentStep = 0;

  final emailController = TextEditingController();
  final codeController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  String error = "";
  String generatedCode = "";
  bool isLoading = false;
  bool obscureNewPass = true;
  bool obscureConfirmPass = true;

  late AnimationController _animController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeInOut),
    );
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    emailController.dispose();
    codeController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void _animateToNextStep(int step) {
    _animController.reset();
    setState(() {
      currentStep = step;
      error = "";
    });
    _animController.forward();
  }

  /// STEP 1: Send code to email
  void sendCode() {
    String email = emailController.text.trim();

    if (email.isEmpty) {
      setState(() => error = "Please enter your email");
      return;
    }

    if (!email.endsWith("@my.sliit.lk")) {
      setState(() => error = "Please use your SLIIT email");
      return;
    }

    setState(() {
      isLoading = true;
      error = "";
    });

    // Simulate sending code
    generatedCode = (100000 + Random().nextInt(899999)).toString();

    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      setState(() => isLoading = false);
      _animateToNextStep(1);

      // Show the code in a snackbar for demo purposes
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Demo: Your code is $generatedCode"),
          backgroundColor: const Color(0xFF9B1C1C),
          duration: const Duration(seconds: 5),
        ),
      );
    });
  }

  /// STEP 2: Verify code
  void verifyCode() {
    String enteredCode = codeController.text.trim();

    if (enteredCode.isEmpty) {
      setState(() => error = "Please enter the verification code");
      return;
    }

    if (enteredCode.length != 6) {
      setState(() => error = "Please enter a valid 6-digit code");
      return;
    }

    _animateToNextStep(2);
  }

  /// STEP 3: Change password
  void changePassword() {
    String newPass = newPasswordController.text.trim();
    String confirmPass = confirmPasswordController.text.trim();

    if (newPass.isEmpty || confirmPass.isEmpty) {
      setState(() => error = "Please fill in both fields");
      return;
    }

    if (newPass.length < 6) {
      setState(() => error = "Password must be at least 6 characters");
      return;
    }

    if (newPass != confirmPass) {
      setState(() => error = "Passwords do not match");
      return;
    }

    setState(() {
      isLoading = true;
      error = "";
    });

    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      setState(() => isLoading = false);
      _animateToNextStep(3);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: currentStep != 3
          ? AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () {
                  if (currentStep > 0 && currentStep < 3) {
                    _animateToNextStep(currentStep - 1);
                  } else {
                    Navigator.pop(context);
                  }
                },
              ),
              title: Text(
                currentStep == 0
                    ? "Forgot Password"
                    : currentStep == 1
                        ? "Verify Code"
                        : "New Password",
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              centerTitle: true,
            )
          : null,
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: _buildCurrentStep(),
          ),
        ),
      ),
    );
  }

  Widget _buildCurrentStep() {
    switch (currentStep) {
      case 0:
        return _buildEmailStep();
      case 1:
        return _buildVerifyCodeStep();
      case 2:
        return _buildNewPasswordStep();
      case 3:
        return _buildSuccessStep();
      default:
        return _buildEmailStep();
    }
  }

  /// ─── STEP 1: ENTER EMAIL ───
  Widget _buildEmailStep() {
    return Column(
      children: [
        const SizedBox(height: 40),

        // Icon
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: const Color(0xFF9B1C1C).withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.email_outlined,
            size: 50,
            color: Color(0xFF9B1C1C),
          ),
        ),

        const SizedBox(height: 30),

        const Text(
          "Enter your email address",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),

        const SizedBox(height: 10),

        Text(
          "We'll send a verification code to your\nSLIIT email address",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
            height: 1.5,
          ),
        ),

        const SizedBox(height: 40),

        // Email field
        TextField(
          controller: emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            hintText: "Enter your SLIIT email...",
            hintStyle: TextStyle(color: Colors.grey[500]),
            prefixIcon: const Icon(Icons.email, color: Color(0xFF9B1C1C)),
            filled: true,
            fillColor: Colors.grey[50],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: const BorderSide(color: Color(0xFF9B1C1C), width: 2),
            ),
          ),
        ),

        const SizedBox(height: 15),

        // Error
        if (error.isNotEmpty)
          Text(
            error,
            style: const TextStyle(color: Colors.red, fontWeight: FontWeight.w500),
          ),

        const SizedBox(height: 25),

        // Send Code Button
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF9B1C1C),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              elevation: 2,
            ),
            onPressed: isLoading ? null : sendCode,
            child: isLoading
                ? const SizedBox(
                    height: 22,
                    width: 22,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2.5,
                    ),
                  )
                : const Text(
                    "SEND CODE",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                    ),
                  ),
          ),
        ),

        const SizedBox(height: 30),
      ],
    );
  }

  /// ─── STEP 2: VERIFY CODE ───
  Widget _buildVerifyCodeStep() {
    return Column(
      children: [
        const SizedBox(height: 40),

        // Icon
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: const Color(0xFF9B1C1C).withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.verified_user_outlined,
            size: 50,
            color: Color(0xFF9B1C1C),
          ),
        ),

        const SizedBox(height: 30),

        const Text(
          "Verify your email",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),

        const SizedBox(height: 10),

        Text(
          "Enter the 6-digit code sent to\n${emailController.text.trim()}",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
            height: 1.5,
          ),
        ),

        const SizedBox(height: 40),

        // Code input field
        TextField(
          controller: codeController,
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            letterSpacing: 8,
          ),
          maxLength: 6,
          decoration: InputDecoration(
            hintText: "• • • • • •",
            hintStyle: TextStyle(
              color: Colors.grey[400],
              fontSize: 24,
              letterSpacing: 8,
            ),
            counterText: "",
            filled: true,
            fillColor: Colors.grey[50],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(color: Color(0xFF9B1C1C), width: 2),
            ),
          ),
        ),

        const SizedBox(height: 15),

        // Error
        if (error.isNotEmpty)
          Text(
            error,
            style: const TextStyle(color: Colors.red, fontWeight: FontWeight.w500),
          ),

        const SizedBox(height: 25),

        // Verify Button
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF9B1C1C),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              elevation: 2,
            ),
            onPressed: verifyCode,
            child: const Text(
              "VERIFY CODE",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
              ),
            ),
          ),
        ),

        const SizedBox(height: 20),

        // Resend code
        MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: () {
              // Resend code
              generatedCode = (100000 + Random().nextInt(899999)).toString();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("New code sent: $generatedCode"),
                  backgroundColor: const Color(0xFF9B1C1C),
                  duration: const Duration(seconds: 5),
                ),
              );
            },
            child: const Text(
              "Didn't receive the code? Resend",
              style: TextStyle(
                color: Color(0xFF9B1C1C),
                fontWeight: FontWeight.bold,
                fontSize: 14,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ),

        const SizedBox(height: 30),
      ],
    );
  }

  /// ─── STEP 3: NEW PASSWORD ───
  Widget _buildNewPasswordStep() {
    return Column(
      children: [
        const SizedBox(height: 40),

        // Icon
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: const Color(0xFF9B1C1C).withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.lock_reset,
            size: 50,
            color: Color(0xFF9B1C1C),
          ),
        ),

        const SizedBox(height: 30),

        const Text(
          "Create new password",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),

        const SizedBox(height: 10),

        Text(
          "Your new password must be at least\n6 characters long",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
            height: 1.5,
          ),
        ),

        const SizedBox(height: 40),

        // New Password
        TextField(
          controller: newPasswordController,
          obscureText: obscureNewPass,
          decoration: InputDecoration(
            hintText: "New password",
            hintStyle: TextStyle(color: Colors.grey[500]),
            prefixIcon: const Icon(Icons.lock, color: Color(0xFF9B1C1C)),
            suffixIcon: IconButton(
              icon: Icon(
                obscureNewPass ? Icons.visibility_off : Icons.visibility,
                color: Colors.grey[600],
              ),
              onPressed: () => setState(() => obscureNewPass = !obscureNewPass),
            ),
            filled: true,
            fillColor: Colors.grey[50],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: const BorderSide(color: Color(0xFF9B1C1C), width: 2),
            ),
          ),
        ),

        const SizedBox(height: 15),

        // Confirm Password
        TextField(
          controller: confirmPasswordController,
          obscureText: obscureConfirmPass,
          decoration: InputDecoration(
            hintText: "Confirm password",
            hintStyle: TextStyle(color: Colors.grey[500]),
            prefixIcon: const Icon(Icons.lock_outline, color: Color(0xFF9B1C1C)),
            suffixIcon: IconButton(
              icon: Icon(
                obscureConfirmPass ? Icons.visibility_off : Icons.visibility,
                color: Colors.grey[600],
              ),
              onPressed: () => setState(() => obscureConfirmPass = !obscureConfirmPass),
            ),
            filled: true,
            fillColor: Colors.grey[50],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: const BorderSide(color: Color(0xFF9B1C1C), width: 2),
            ),
          ),
        ),

        const SizedBox(height: 15),

        // Error
        if (error.isNotEmpty)
          Text(
            error,
            style: const TextStyle(color: Colors.red, fontWeight: FontWeight.w500),
          ),

        const SizedBox(height: 25),

        // Change Password Button
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF9B1C1C),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              elevation: 2,
            ),
            onPressed: isLoading ? null : changePassword,
            child: isLoading
                ? const SizedBox(
                    height: 22,
                    width: 22,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2.5,
                    ),
                  )
                : const Text(
                    "CHANGE PASSWORD",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                    ),
                  ),
          ),
        ),

        const SizedBox(height: 30),
      ],
    );
  }

  /// ─── STEP 4: SUCCESS ───
  Widget _buildSuccessStep() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.85,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Green tick with animation
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: const Duration(milliseconds: 800),
            curve: Curves.elasticOut,
            builder: (context, value, child) {
              return Transform.scale(
                scale: value,
                child: child,
              );
            },
            child: Container(
              width: 120,
              height: 120,
              decoration: const BoxDecoration(
                color: Color(0xFF4CAF50),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Color(0x404CAF50),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: const Icon(
                Icons.check,
                color: Colors.white,
                size: 70,
              ),
            ),
          ),

          const SizedBox(height: 40),

          const Text(
            "Password Changed\nSuccessfully!",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Colors.black,
              height: 1.3,
            ),
          ),

          const SizedBox(height: 15),

          Text(
            "You can now use your new password\nto sign in to your account",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
              height: 1.5,
            ),
          ),

          const SizedBox(height: 50),

          // Back to Login button
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF9B1C1C),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                elevation: 2,
              ),
              onPressed: () {
                // Go back to login screen
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
              child: const Text(
                "BACK TO LOGIN",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

