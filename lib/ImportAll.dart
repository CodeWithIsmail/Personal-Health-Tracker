export 'package:flutter/cupertino.dart';
export 'package:flutter/material.dart' hide RefreshCallback;

// External Package
export 'package:fluttertoast/fluttertoast.dart';
export 'package:image_cropper/image_cropper.dart';
export 'package:image_picker/image_picker.dart';
export 'package:flutter_markdown/flutter_markdown.dart';
export 'package:font_awesome_flutter/font_awesome_flutter.dart';
export 'package:qr_flutter/qr_flutter.dart';
export 'package:google_sign_in/google_sign_in.dart';
export 'package:intl/intl.dart' hide TextDirection;
export 'package:flutter_spinkit/flutter_spinkit.dart';
export 'package:syncfusion_flutter_charts/charts.dart';
export 'package:syncfusion_flutter_charts/sparkcharts.dart';
export 'package:provider/provider.dart';
export 'package:webview_flutter/webview_flutter.dart';

export 'AuthWrapper.dart';

// model
export 'model/user_model.dart';
export 'model/report_model.dart';
export 'model/report_attribute_model.dart';
// provider
export 'provider/news_provider.dart';
export 'provider/auth_provider.dart';
export 'provider/user_provider.dart';
export 'provider/report_provider.dart';
export 'provider/test_names_provider.dart';
export 'provider/report_attribute_provider.dart';
// chart_builder
export 'chart_builder/chart_data_timewise.dart';
export 'chart_builder/linechart_builder.dart';
export 'chart_builder/columnchart_builder.dart';

// firebase
export 'package:firebase_core/firebase_core.dart';
export 'package:firebase_auth/firebase_auth.dart';
export 'package:cloud_firestore/cloud_firestore.dart';

// gemini
export 'package:google_generative_ai/google_generative_ai.dart';

// screens
// authentication pages
export 'screens/authentication_pages/login_page.dart';
export 'screens/authentication_pages/signup_page.dart';
export 'screens/authentication_pages/verification_page.dart';
// homepage
export 'screens/homepage/home_page.dart';
export 'screens/homepage/web_view.dart';
// report_history
export 'screens/report_history/report_detail_page.dart';
export 'screens/report_history/report_history_page.dart';
// history_visualization
export 'screens/history_visualization/history_visualization_page.dart';

export 'screens/main_navigation_page.dart';
export 'screens/homepage/home_page.dart';
export 'screens/report_add/AddReportScreen.dart';
export 'screens/report_add/ReportInputScreen.dart';
export 'screens/ProfileScreen.dart';
export 'screens/ReportHistoryvisualization.dart';
export 'screens/report_add/ReportAnalysisScreen.dart';
export 'screens/InputProfileInfoScreen.dart';

// helper
export 'helper/QRscan.dart';
export 'helper/QRmake.dart';
export 'helper/Calculator.dart';
export 'helper/time_converter.dart';

// constant
export 'constant/constant_loading_indicator.dart';
export 'constant/constants.dart';
export 'constant/dropdown_options.dart';

// services
export 'services/firestoreDB.dart';
export 'services/firebase_options.dart';

// custom
export 'custom/CustomAlert.dart';
export 'custom/CustomToast.dart';
export 'custom/CustomIconCreate.dart';
export 'custom/CustomTextField.dart';
export 'custom/CustomTextGestureDetector.dart';
export 'custom/CustomButtonGestureDetector.dart';
export 'custom/custom_date_range_widget.dart';
export 'custom/custom_history_container_widget.dart';
// components
export 'components/MessageWidget.dart';
export 'components/ProfileInfo.dart';
export 'components/MyAppBar.dart';

// flutter
export 'dart:io';
export 'dart:convert';

//api
export 'api/GeminiAPI.dart';
export 'api/ImageUploadCloudinary.dart';

// private data
export 'PrivateData.dart';

// routes
export 'route/routes.dart';