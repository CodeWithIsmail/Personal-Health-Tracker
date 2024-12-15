// External Package
export 'package:fluttertoast/fluttertoast.dart';
export 'package:flutter/cupertino.dart';
export 'package:flutter/material.dart' hide RefreshCallback;
export 'package:image_cropper/image_cropper.dart';
export 'package:image_picker/image_picker.dart';
export 'package:path_provider/path_provider.dart';
export 'package:flutter_markdown/flutter_markdown.dart';
export 'package:font_awesome_flutter/font_awesome_flutter.dart';
export 'package:qr_flutter/qr_flutter.dart';
export 'package:pretty_qr_code/pretty_qr_code.dart';
export 'package:google_sign_in/google_sign_in.dart';
export 'package:intl/intl.dart' hide TextDirection;
export 'package:flutter_spinkit/flutter_spinkit.dart';

// firebase
export 'package:firebase_core/firebase_core.dart';
export 'package:firebase_auth/firebase_auth.dart';
export 'package:cloud_firestore/cloud_firestore.dart';
// gemini
export 'package:google_generative_ai/google_generative_ai.dart';

// screens
export 'screens/SignUpScreen.dart';
export 'screens/LogInScreen.dart';
export 'screens/HomePage.dart';
export 'screens/HomeScreenPage.dart';
export 'screens/AddReportScreen.dart';
export 'screens/ReportInputScreen.dart';
export 'screens/ProfileScreen.dart';
export 'screens/HistoryPage.dart';
export 'screens/ReportAnalysisScreen.dart';
export 'screens/InputProfileInfoScreen.dart';

// helper
export 'helper/AuthCheck.dart';
export 'helper/LogOrRegi.dart';
export 'helper/QRmaker.dart' hide QRCodeGenerator;
export 'helper/QRscan.dart';
export 'helper/QRmake.dart';
export 'helper/constants.dart';

// services
export 'services/AuthService.dart';
export 'services/firestoreDB.dart';
export 'services/firebase_options.dart';

// custom
export 'custom/CustomAlert.dart';
export 'custom/CustomToast.dart';
export 'custom/CustomIconCreate.dart';
export 'custom/CustomTextField.dart';
export 'custom/CustomTextGestureDetector.dart';
export 'custom/CustomButtonGestureDetector.dart';

// components
export 'components/MessageWidget.dart';
export 'components/ProfileInfo.dart';

// flutter
export 'dart:io';
export 'dart:convert';

//api
export 'api/GeminiAPI.dart';
export 'api/ImageUploadCloudinary.dart';

// private data
export 'PrivateData.dart';
