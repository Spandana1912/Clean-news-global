import 'package:flutter/material.dart';

import 'settings_controller.dart';

/// All UI text for the app in English, Tamil, Telugu and Hindi.
///
/// Usage inside any widget:
///   final s = AppStrings.of(context);
///   Text(s.home)
///
/// Because [AppStrings.of] listens to [SettingsScope], every screen that
/// calls it rebuilds immediately when the language is changed.
class AppStrings {
  final String language;

  const AppStrings(this.language);

  factory AppStrings.of(BuildContext context) {
    return AppStrings(SettingsScope.of(context).language);
  }

  // ----------------------------------------------------------
  // CORE HELPERS
  // ----------------------------------------------------------

  String _t(String en, String ta, String te, String hi) {
    switch (language) {
      case 'Tamil':
        return ta;
      case 'Telugu':
        return te;
      case 'Hindi':
        return hi;
      default:
        return en;
    }
  }

  /// Locale code used for dates, place names and Material widgets.
  String get localeCode {
    switch (language) {
      case 'Tamil':
        return 'ta';
      case 'Telugu':
        return 'te';
      case 'Hindi':
        return 'hi';
      default:
        return 'en';
    }
  }

  static String languageDisplayName(String value) {
    switch (value) {
      case 'Tamil':
        return 'தமிழ் (Tamil)';
      case 'Telugu':
        return 'తెలుగు (Telugu)';
      case 'Hindi':
        return 'हिन्दी (Hindi)';
      default:
        return 'English';
    }
  }

  // ==========================================================
  // BRAND
  // ==========================================================

  String get brandName => _t(
    'The Clean News Global',
    'தி கிளீன் நியூஸ் குளோபல்',
    'ది క్లీన్ న్యూస్ గ్లోబల్',
    'द क्लीन न्यूज़ ग्लोबल',
  );

  String get cleanNewsGlobalCaps => _t(
    'CLEAN NEWS GLOBAL',
    'கிளீன் நியூஸ் குளோபல்',
    'క్లీన్ న్యూస్ గ్లోబల్',
    'क्लीन न्यूज़ ग्लोबल',
  );

  String get readDiscoverUnderstand => _t(
    'READ • DISCOVER • UNDERSTAND',
    'படி • கண்டறி • புரிந்துகொள்',
    'చదవండి • తెలుసుకోండి • అర్థం చేసుకోండి',
    'पढ़ें • खोजें • समझें',
  );

  // ==========================================================
  // BOTTOM NAVIGATION
  // ==========================================================

  String get home => _t('Home', 'முகப்பு', 'హోమ్', 'होम');
  String get saved =>
      _t('Saved', 'சேமித்தவை', 'సేవ్ చేసినవి', 'सहेजे गए');
  String get profile =>
      _t('Profile', 'சுயவிவரம்', 'ప్రొఫైల్', 'प्रोफ़ाइल');
  String get settings =>
      _t('Settings', 'அமைப்புகள்', 'సెట్టింగ్స్', 'सेटिंग्स');

  // ==========================================================
  // GENERAL
  // ==========================================================

  String get notifications =>
      _t('Notifications', 'அறிவிப்புகள்', 'నోటిఫికేషన్లు', 'सूचनाएं');
  String get languageText => _t('Language', 'மொழி', 'భాష', 'भाषा');
  String get savedArticles => _t(
    'Saved Articles',
    'சேமித்த கட்டுரைகள்',
    'సేవ్ చేసిన వార్తలు',
    'सहेजे गए लेख',
  );
  String get details =>
      _t('Details', 'விவரங்கள்', 'వివరాలు', 'विवरण');
  String get aboutUs => _t(
    'About Us',
    'எங்களைப் பற்றி',
    'మా గురించి',
    'हमारे बारे में',
  );
  String get logout =>
      _t('Logout', 'வெளியேறு', 'లాగ్ అవుట్', 'लॉग आउट');
  String get okay => _t('Okay', 'சரி', 'సరే', 'ठीक है');
  String get close =>
      _t('Close', 'மூடு', 'మూసివేయి', 'बंद करें');
  String get selectLanguage => _t(
    'Select Language',
    'மொழியைத் தேர்ந்தெடுக்கவும்',
    'భాషను ఎంచుకోండి',
    'भाषा चुनें',
  );
  String get loading => _t(
    'Loading...',
    'ஏற்றப்படுகிறது...',
    'లోడ్ అవుతోంది...',
    'लोड हो रहा है...',
  );

  // ==========================================================
  // PASSWORD
  // ==========================================================

  String get changePassword => _t(
    'Change Password',
    'கடவுச்சொல்லை மாற்று',
    'పాస్‌వర్డ్ మార్చండి',
    'पासवर्ड बदलें',
  );
  String get currentPassword => _t(
    'Current Password',
    'தற்போதைய கடவுச்சொல்',
    'ప్రస్తుత పాస్‌వర్డ్',
    'वर्तमान पासवर्ड',
  );
  String get newPassword => _t(
    'New Password',
    'புதிய கடவுச்சொல்',
    'కొత్త పాస్‌వర్డ్',
    'नया पासवर्ड',
  );
  String get confirmNewPassword => _t(
    'Confirm New Password',
    'புதிய கடவுச்சொல்லை உறுதிசெய்',
    'కొత్త పాస్‌వర్డ్‌ను నిర్ధారించండి',
    'नए पासवर्ड की पुष्टि करें',
  );
  String get cancel =>
      _t('Cancel', 'ரத்து செய்', 'రద్దు చేయండి', 'रद्द करें');
  String get update => _t(
    'Update',
    'புதுப்பி',
    'అప్‌డేట్ చేయండి',
    'अपडेट करें',
  );
  String get passwordUpdatedSuccessfully => _t(
    'Password updated successfully.',
    'கடவுச்சொல் வெற்றிகரமாக மாற்றப்பட்டது.',
    'పాస్‌వర్డ్ విజయవంతంగా మార్చబడింది.',
    'पासवर्ड सफलतापूर्वक अपडेट हो गया।',
  );
  String get unableToUpdatePassword => _t(
    'Unable to update password.',
    'கடவுச்சொல்லை மாற்ற முடியவில்லை.',
    'పాస్‌వర్డ్‌ను మార్చడం సాధ్యం కాలేదు.',
    'पासवर्ड अपडेट नहीं हो सका।',
  );
  String get samePasswordError => _t(
    'New password cannot be the same as your current password.',
    'புதிய கடவுச்சொல் தற்போதைய கடவுச்சொல்லைப் போல இருக்கக்கூடாது.',
    'కొత్త పాస్‌వర్డ్ ప్రస్తుత పాస్‌వర్డ్‌లా ఉండకూడదు.',
    'नया पासवर्ड वर्तमान पासवर्ड जैसा नहीं होना चाहिए।',
  );
  String get passwordCannotBeEmpty => _t(
    'Password cannot be empty.',
    'கடவுச்சொல் காலியாக இருக்கக்கூடாது.',
    'పాస్‌వర్డ్ ఖాళీగా ఉండకూడదు.',
    'पासवर्ड खाली नहीं हो सकता।',
  );
  String get enterCurrentPassword => _t(
    'Enter your current password.',
    'தற்போதைய கடவுச்சொல்லை உள்ளிடவும்.',
    'ప్రస్తుత పాస్‌వర్డ్‌ను నమోదు చేయండి.',
    'अपना वर्तमान पासवर्ड दर्ज करें।',
  );
  String get enterNewPassword => _t(
    'Enter a new password.',
    'புதிய கடவுச்சொல்லை உள்ளிடவும்.',
    'కొత్త పాస్‌వర్డ్‌ను నమోదు చేయండి.',
    'नया पासवर्ड दर्ज करें।',
  );
  String get confirmYourNewPassword => _t(
    'Confirm your new password.',
    'புதிய கடவுச்சொல்லை உறுதிசெய்யவும்.',
    'మీ కొత్త పాస్‌వర్డ్‌ను నిర్ధారించండి.',
    'अपने नए पासवर्ड की पुष्टि करें।',
  );
  String get passwordsDoNotMatch => _t(
    'Passwords do not match.',
    'கடவுச்சொற்கள் பொருந்தவில்லை.',
    'పాస్‌వర్డ్‌లు సరిపోలడం లేదు.',
    'पासवर्ड मेल नहीं खाते।',
  );
  String get passwordRequirements => _t(
    'Password requirements',
    'கடவுச்சொல் தேவைகள்',
    'పాస్‌వర్డ్ అవసరాలు',
    'पासवर्ड की आवश्यकताएं',
  );
  String get passwordRequirementsList => _t(
    '• At least 12 characters\n'
        '• One uppercase and one lowercase letter\n'
        '• One number and one special character',
    '• குறைந்தது 12 எழுத்துகள்\n'
        '• ஒரு பெரிய எழுத்து மற்றும் ஒரு சிறிய எழுத்து (ஆங்கிலம்)\n'
        '• ஒரு எண் மற்றும் ஒரு சிறப்புக் குறியீடு',
    '• కనీసం 12 అక్షరాలు\n'
        '• ఒక పెద్ద అక్షరం మరియు ఒక చిన్న అక్షరం (ఇంగ్లీష్)\n'
        '• ఒక సంఖ్య మరియు ఒక ప్రత్యేక చిహ్నం',
    '• कम से कम 12 अक्षर\n'
        '• एक अपरकेस और एक लोअरकेस अक्षर (अंग्रेज़ी)\n'
        '• एक अंक और एक विशेष चिह्न',
  );
  String get showPassword => _t(
    'Show password',
    'கடவுச்சொல்லைக் காட்டு',
    'పాస్‌వర్డ్ చూపించు',
    'पासवर्ड दिखाएं',
  );
  String get hidePassword => _t(
    'Hide password',
    'கடவுச்சொல்லை மறை',
    'పాస్‌వర్డ్ దాచు',
    'पासवर्ड छिपाएं',
  );

  // ==========================================================
  // DARK MODE / TEXT SIZE
  // ==========================================================

  String get darkMode => _t(
    'Dark Mode',
    'இருண்ட பயன்முறை',
    'డార్క్ మోడ్',
    'डार्क मोड',
  );
  String get darkThemeEnabled => _t(
    'Dark theme enabled',
    'இருண்ட தீம் இயக்கப்பட்டுள்ளது',
    'డార్క్ థీమ్ ఆన్‌లో ఉంది',
    'डार्क थीम चालू है',
  );
  String get lightThemeEnabled => _t(
    'Light theme enabled',
    'ஒளி தீம் இயக்கப்பட்டுள்ளது',
    'లైట్ థీమ్ ఆన్‌లో ఉంది',
    'लाइट थीम चालू है',
  );
  String get textSize => _t(
    'Text Size',
    'எழுத்து அளவு',
    'వచన పరిమాణం',
    'टेक्स्ट आकार',
  );
  String get adjustReadingTextSize => _t(
    'Adjust reading text size',
    'வாசிப்பு எழுத்து அளவை மாற்றவும்',
    'చదివే వచన పరిమాణాన్ని మార్చండి',
    'पढ़ने के लिए टेक्स्ट आकार बदलें',
  );
  String get small => _t('Small', 'சிறியது', 'చిన్నది', 'छोटा');
  String get normal =>
      _t('Normal', 'இயல்பானது', 'సాధారణం', 'सामान्य');
  String get large => _t('Large', 'பெரியது', 'పెద్దది', 'बड़ा');

  // ==========================================================
  // NEWS NOTIFICATIONS
  // ==========================================================

  String get manageNewsNotifications => _t(
    'Manage news notifications',
    'செய்தி அறிவிப்புகளை நிர்வகிக்கவும்',
    'వార్తా నోటిఫికేషన్లను నిర్వహించండి',
    'समाचार सूचनाएं प्रबंधित करें',
  );
  String get newsNotificationsEnabled => _t(
    'News notifications enabled',
    'செய்தி அறிவிப்புகள் இயக்கப்பட்டுள்ளன',
    'వార్తా నోటిఫికేషన్లు ఆన్‌లో ఉన్నాయి',
    'समाचार सूचनाएं चालू हैं',
  );
  String get newsNotificationsDisabled => _t(
    'News notifications disabled',
    'செய்தி அறிவிப்புகள் முடக்கப்பட்டுள்ளன',
    'వార్తా నోటిఫికేషన్లు ఆఫ్‌లో ఉన్నాయి',
    'समाचार सूचनाएं बंद हैं',
  );
  String get notificationsDisabledTitle => _t(
    'Notifications are disabled',
    'அறிவிப்புகள் முடக்கப்பட்டுள்ளன',
    'నోటిఫికేషన్లు ఆఫ్‌లో ఉన్నాయి',
    'सूचनाएं बंद हैं',
  );
  String get enableNotificationsHint => _t(
    'Enable notifications in Settings to get the latest news updates.',
    'சமீபத்திய செய்தி அறிவிப்புகளைப் பெற அமைப்புகளில் அறிவிப்புகளை இயக்கவும்.',
    'తాజా వార్తల అప్‌డేట్‌లు పొందడానికి సెట్టింగ్స్‌లో నోటిఫికేషన్లను ఆన్ చేయండి.',
    'ताज़ा समाचार अपडेट पाने के लिए सेटिंग्स में सूचनाएं चालू करें।',
  );
  String get goToSettings => _t(
    'Go to Settings',
    'அமைப்புகளுக்குச் செல்',
    'సెట్టింగ్స్‌కు వెళ్లండి',
    'सेटिंग्स पर जाएं',
  );
  String get noNewNotifications => _t(
    'No new notifications.',
    'புதிய அறிவிப்புகள் இல்லை.',
    'కొత్త నోటిఫికేషన్లు లేవు.',
    'कोई नई सूचना नहीं।',
  );
  String get defaultNewsSource =>
      _t('News', 'செய்தி', 'వార్తలు', 'समाचार');

  // ==========================================================
  // PROFILE / ABOUT / PRIVACY
  // ==========================================================

  String get viewUsernameEmail => _t(
    'View username and email',
    'பயனர்பெயர் மற்றும் மின்னஞ்சலைப் பார்க்கவும்',
    'వినియోగదారు పేరు మరియు ఇమెయిల్ చూడండి',
    'उपयोगकर्ता नाम और ईमेल देखें',
  );
  String get profileTitle =>
      _t('Profile', 'சுயவிவரம்', 'ప్రొఫైల్', 'प्रोफ़ाइल');
  String get welcomeToApp => _t(
    'Welcome to The Clean News Global',
    'தி கிளீன் நியூஸ் குளோபலுக்கு வரவேற்கிறோம்',
    'ది క్లీన్ న్యూస్ గ్లోబల్‌కు స్వాగతం',
    'द क्लीन न्यूज़ ग्लोबल में आपका स्वागत है',
  );
  String get manageSavedNews => _t(
    'Manage your saved news',
    'சேமித்த செய்திகளை நிர்வகிக்கவும்',
    'సేవ్ చేసిన వార్తలను నిర్వహించండి',
    'सहेजे गए समाचार प्रबंधित करें',
  );
  String get yourDetails => _t(
    'Your Details',
    'உங்கள் விவரங்கள்',
    'మీ వివరాలు',
    'आपका विवरण',
  );
  String get usernameLabel => _t(
    'Username',
    'பயனர்பெயர்',
    'వినియోగదారు పేరు',
    'उपयोगकर्ता नाम',
  );
  String get emailLabel =>
      _t('Email', 'மின்னஞ்சல்', 'ఇమెయిల్', 'ईमेल');
  String get defaultUser =>
      _t('User', 'பயனர்', 'వినియోగదారు', 'उपयोगकर्ता');

  String get aboutCleanNews => _t(
    'About The Clean News Global',
    'தி கிளீன் நியூஸ் குளோபல் பற்றி',
    'ది క్లీన్ న్యూస్ గ్లోబల్ గురించి',
    'द क्लीन न्यूज़ ग्लोबल के बारे में',
  );
  String get aboutCleanNewsDescription => _t(
    'The Clean News Global provides a clean and simple way to discover and read news from India and around the world.',
    'தி கிளீன் நியூஸ் குளோபல் இந்தியா மற்றும் உலகம் முழுவதிலிருந்தும் செய்திகளை எளிமையாகவும் தெளிவாகவும் படிக்க உதவுகிறது.',
    'ది క్లీన్ న్యూస్ గ్లోబల్ భారతదేశం మరియు ప్రపంచవ్యాప్తంగా వార్తలను సులభంగా మరియు స్పష్టంగా తెలుసుకోవడానికి సహాయపడుతుంది.',
    'द क्लीन न्यूज़ ग्लोबल भारत और दुनिया भर की खबरों को सरल और साफ़ तरीके से पढ़ने की सुविधा देता है।',
  );
  String get privacyPolicy => _t(
    'Privacy Policy',
    'தனியுரிமைக் கொள்கை',
    'గోప్యతా విధానం',
    'गोपनीयता नीति',
  );
  String get privacyPolicyDescription => _t(
    'Your account information is used only to provide the features of The Clean News Global. We do not display your private account information publicly.',
    'உங்கள் கணக்குத் தகவல்கள் தி கிளீன் நியூஸ் குளோபலின் அம்சங்களை வழங்குவதற்காக மட்டுமே பயன்படுத்தப்படுகின்றன. உங்கள் தனிப்பட்ட கணக்குத் தகவல்கள் பொதுவில் வெளியிடப்படாது.',
    'మీ ఖాతా సమాచారం ది క్లీన్ న్యూస్ గ్లోబల్ ఫీచర్లను అందించడానికి మాత్రమే ఉపయోగించబడుతుంది. మీ వ్యక్తిగత ఖాతా సమాచారం బహిరంగంగా ప్రదర్శించబడదు.',
    'आपकी खाता जानकारी का उपयोग केवल द क्लीन न्यूज़ ग्लोबल की सुविधाएं प्रदान करने के लिए किया जाता है। आपकी निजी खाता जानकारी सार्वजनिक रूप से प्रदर्शित नहीं की जाती।',
  );

  // ==========================================================
  // SAVED PAGE
  // ==========================================================

  String get noSavedArticles => _t(
    'No saved articles yet.',
    'இன்னும் சேமித்த கட்டுரைகள் இல்லை.',
    'ఇంకా సేవ్ చేసిన వార్తలు లేవు.',
    'अभी तक कोई सहेजा हुआ लेख नहीं है।',
  );

  // ==========================================================
  // HOME PAGE
  // ==========================================================

  String get todaysTea => _t(
    "TODAY'S TEA ☕️",
    'இன்றைய தேநீர் ☕️',
    'ఈరోజు టీ ☕️',
    'आज की चाय ☕️',
  );
  String get globalEditionTagline => _t(
    'GLOBAL EDITION  •  DAILY NEWS',
    'உலகப் பதிப்பு  •  தினசரி செய்திகள்',
    'గ్లోబల్ ఎడిషన్  •  రోజువారీ వార్తలు',
    'ग्लोबल संस्करण  •  दैनिक समाचार',
  );
  String hiUser(String name) => _t(
    'Hi, $name 👋',
    'வணக்கம், $name 👋',
    'హాయ్, $name 👋',
    'नमस्ते, $name 👋',
  );
  String get searchNewsHint => _t(
    'Search news...',
    'செய்திகளைத் தேடுங்கள்...',
    'వార్తలను వెతకండి...',
    'समाचार खोजें...',
  );
  String get searchNewsTooltip => _t(
    'Search news',
    'செய்திகளைத் தேடு',
    'వార్తలను వెతకండి',
    'समाचार खोजें',
  );
  String get clearSearchTooltip => _t(
    'Clear search',
    'தேடலை அழி',
    'శోధనను క్లియర్ చేయండి',
    'खोज साफ़ करें',
  );
  String get trendingToday => _t(
    'TRENDING TODAY',
    'இன்றைய டிரெண்டிங்',
    'ఈరోజు ట్రెండింగ్',
    'आज के ट्रेंडिंग',
  );
  String searchingFor(String query) {
    final q = query.toUpperCase();
    return _t(
      'SEARCHING FOR: $q',
      'தேடல்: $q',
      'వెతుకుతున్నది: $q',
      'खोज रहे हैं: $q',
    );
  }

  String get checkLatestNews => _t(
    'CHECK LATEST NEWS',
    'சமீபத்திய செய்திகளைச் சரிபார்',
    'తాజా వార్తలను తనిఖీ చేయండి',
    'ताज़ा समाचार जांचें',
  );
  String get checkingLatestNews => _t(
    'CHECKING LATEST NEWS...',
    'சரிபார்க்கிறது...',
    'తనిఖీ చేస్తోంది...',
    'जांच रहे हैं...',
  );
  String get checkingLatestSnack => _t(
    'Checking for the latest news...',
    'சமீபத்திய செய்திகளைச் சரிபார்க்கிறது...',
    'తాజా వార్తలను తనిఖీ చేస్తోంది...',
    'ताज़ा समाचार जांचे जा रहे हैं...',
  );
  String get newsFrom =>
      _t('NEWS FROM', 'செய்திகள்:', 'వార్తలు:', 'समाचार:');
  String get india =>
      _t('INDIA', 'இந்தியா', 'భారతదేశం', 'भारत');
  String get international => _t(
    'INTERNATIONAL',
    'சர்வதேசம்',
    'అంతర్జాతీయం',
    'अंतरराष्ट्रीय',
  );

  /// Index matches the `categories` list in HomePage.
  String category(int index) {
    switch (index) {
      case 1:
        return _t('Business', 'வணிகம்', 'వ్యాపారం', 'व्यापार');
      case 2:
        return _t('Sports', 'விளையாட்டு', 'క్రీడలు', 'खेल');
      case 3:
        return _t(
          'Technology',
          'தொழில்நுட்பம்',
          'సాంకేతికం',
          'प्रौद्योगिकी',
        );
      case 4:
        return _t('Health', 'ஆரோக்கியம்', 'ఆరోగ్యం', 'स्वास्थ्य');
      case 5:
        return _t('Science', 'அறிவியல்', 'సైన్స్', 'विज्ञान');
      case 6:
        return _t(
          'Entertainment',
          'பொழுதுபோக்கு',
          'వినోదం',
          'मनोरंजन',
        );
      default:
        return _t('All', 'அனைத்தும்', 'అన్నీ', 'सभी');
    }
  }

  String get topStories => _t(
    'TOP STORIES',
    'முக்கியச் செய்திகள்',
    'ముఖ్య వార్తలు',
    'मुख्य समाचार',
  );
  String get searchResults => _t(
    'SEARCH RESULTS',
    'தேடல் முடிவுகள்',
    'శోధన ఫలితాలు',
    'खोज परिणाम',
  );
  String get searchBadge =>
      _t('SEARCH', 'தேடல்', 'శోధన', 'खोज');
  String get aiSummary => _t(
    'AI SUMMARY',
    'AI சுருக்கம்',
    'AI సారాంశం',
    'AI सारांश',
  );
  String get aiArticleSummary => _t(
    'AI ARTICLE SUMMARY',
    'AI செய்திச் சுருக்கம்',
    'AI వార్త సారాంశం',
    'AI लेख सारांश',
  );
  String get preparingSummary => _t(
    'Preparing your article summary...',
    'உங்கள் கட்டுரைச் சுருக்கம் தயாராகிறது...',
    'మీ వార్త సారాంశం సిద్ధమవుతోంది...',
    'आपका लेख सारांश तैयार हो रहा है...',
  );
  String get noSummaryReturned => _t(
    'No summary was returned.',
    'சுருக்கம் எதுவும் கிடைக்கவில்லை.',
    'సారాంశం అందలేదు.',
    'कोई सारांश प्राप्त नहीं हुआ।',
  );
  String get readArticle => _t(
    'READ ARTICLE',
    'கட்டுரையைப் படிக்க',
    'వార్త చదవండి',
    'लेख पढ़ें',
  );
  String get articleTitle =>
      _t('ARTICLE', 'கட்டுரை', 'వార్త', 'लेख');
  String get articleSaved => _t(
    'Article saved to your archive.',
    'கட்டுரை உங்கள் சேமிப்பில் சேர்க்கப்பட்டது.',
    'వార్త మీ ఆర్కైవ్‌లో సేవ్ చేయబడింది.',
    'लेख आपके संग्रह में सहेजा गया।',
  );
  String get articleRemoved => _t(
    'Article removed from your archive.',
    'கட்டுரை உங்கள் சேமிப்பிலிருந்து நீக்கப்பட்டது.',
    'వార్త మీ ఆర్కైవ్ నుండి తొలగించబడింది.',
    'लेख आपके संग्रह से हटाया गया।',
  );
  String get shareArticle => _t(
    'Share Article',
    'கட்டுரையைப் பகிர்',
    'వార్తను షేర్ చేయండి',
    'लेख साझा करें',
  );
  String get copyLink => _t(
    'Copy Link',
    'இணைப்பை நகலெடு',
    'లింక్ కాపీ చేయండి',
    'लिंक कॉपी करें',
  );
  String get linkCopied => _t(
    'Link copied!',
    'இணைப்பு நகலெடுக்கப்பட்டது!',
    'లింక్ కాపీ అయింది!',
    'लिंक कॉपी हो गया!',
  );
  String get linkUnavailable => _t(
    'Article link is not available.',
    'கட்டுரை இணைப்பு கிடைக்கவில்லை.',
    'వార్త లింక్ అందుబాటులో లేదు.',
    'लेख का लिंक उपलब्ध नहीं है।',
  );
  String get invalidLink => _t(
    'Invalid article link.',
    'தவறான கட்டுரை இணைப்பு.',
    'చెల్లని వార్త లింక్.',
    'अमान्य लेख लिंक।',
  );
  String get couldNotOpenArticle => _t(
    'Could not open the article.',
    'கட்டுரையைத் திறக்க முடியவில்லை.',
    'వార్తను తెరవలేకపోయాము.',
    'लेख नहीं खुल सका।',
  );
  String get unableToLoadArticle => _t(
    'Unable to load this article.',
    'இந்தக் கட்டுரையை ஏற்ற முடியவில்லை.',
    'ఈ వార్తను లోడ్ చేయలేకపోయాము.',
    'यह लेख लोड नहीं हो सका।',
  );
  String newArticlesAvailable(int n) {
    if (n == 1) {
      return _t(
        '1 new article is available.',
        '1 புதிய கட்டுரை உள்ளது.',
        '1 కొత్త వార్త అందుబాటులో ఉంది.',
        '1 नया लेख उपलब्ध है।',
      );
    }
    return _t(
      '$n new articles are available.',
      '$n புதிய கட்டுரைகள் உள்ளன.',
      '$n కొత్త వార్తలు అందుబాటులో ఉన్నాయి.',
      '$n नए लेख उपलब्ध हैं।',
    );
  }

  String get upToDate => _t(
    "You're up to date. No new news found.",
    'நீங்கள் புதுப்பித்த நிலையில் உள்ளீர்கள். புதிய செய்திகள் இல்லை.',
    'మీరు తాజాగా ఉన్నారు. కొత్త వార్తలు లేవు.',
    'आप अप टू डेट हैं। कोई नया समाचार नहीं मिला।',
  );
  String get couldNotCheckLatest => _t(
    'Could not check for latest news.',
    'சமீபத்திய செய்திகளைச் சரிபார்க்க முடியவில்லை.',
    'తాజా వార్తలను తనిఖీ చేయలేకపోయాము.',
    'ताज़ा समाचार जांचे नहीं जा सके।',
  );
  String get editionRefreshed => _t(
    "Today's edition has been refreshed.",
    'இன்றைய பதிப்பு புதுப்பிக்கப்பட்டது.',
    'నేటి ఎడిషన్ రిఫ్రెష్ అయింది.',
    'आज का संस्करण रिफ्रेश हो गया।',
  );
  String get unableToSearch => _t(
    'Unable to search for news.',
    'செய்திகளைத் தேட முடியவில்லை.',
    'వార్తలను వెతకలేకపోయాము.',
    'समाचार खोजे नहीं जा सके।',
  );
  String get unableToLoadNews => _t(
    "Unable to load today's news.",
    'இன்றைய செய்திகளை ஏற்ற முடியவில்லை.',
    'నేటి వార్తలను లోడ్ చేయలేకపోయాము.',
    'आज के समाचार लोड नहीं हो सके।',
  );
  String get tryAgain => _t(
    'TRY AGAIN',
    'மீண்டும் முயற்சி',
    'మళ్లీ ప్రయత్నించండి',
    'पुनः प्रयास करें',
  );
  String get noSearchResults => _t(
    'No latest news available on this feed.',
    'இந்த ஃபீடில் சமீபத்திய செய்திகள் இல்லை.',
    'ఈ ఫీడ్‌లో తాజా వార్తలు లేవు.',
    'इस फ़ीड में कोई ताज़ा समाचार उपलब्ध नहीं है।',
  );
  String get noNews => _t(
    'No news articles available right now.',
    'தற்போது செய்திக் கட்டுரைகள் இல்லை.',
    'ప్రస్తుతం వార్తలు అందుబాటులో లేవు.',
    'अभी कोई समाचार उपलब्ध नहीं है।',
  );
  String get tryAnotherTopic => _t(
    'Try searching for another topic.',
    'வேறு தலைப்பைத் தேடிப் பாருங்கள்.',
    'మరొక అంశం కోసం వెతకండి.',
    'कोई दूसरा विषय खोजकर देखें।',
  );

  // ==========================================================
  // WEATHER
  // ==========================================================

  String get loadingWeather => _t(
    'Loading weather...',
    'வானிலை ஏற்றப்படுகிறது...',
    'వాతావరణం లోడ్ అవుతోంది...',
    'मौसम लोड हो रहा है...',
  );
  String get weatherUnavailable => _t(
    'Weather information is unavailable',
    'வானிலை தகவல் கிடைக்கவில்லை',
    'వాతావరణ సమాచారం అందుబాటులో లేదు',
    'मौसम की जानकारी उपलब्ध नहीं है',
  );
  String get currentLocation => _t(
    'Current location',
    'தற்போதைய இடம்',
    'ప్రస్తుత ప్రదేశం',
    'वर्तमान स्थान',
  );
  String get defaultCity => _t(
    'Coimbatore',
    'கோயம்புத்தூர்',
    'కోయంబత్తూరు',
    'कोयंबटूर',
  );
  String get feelsLike => _t(
    'Feels like',
    'உணர்வு',
    'అనుభూతి',
    'महसूस',
  );
  String get humidity => _t('Humidity', 'ஈரப்பதம்', 'తేమ', 'नमी');
  String get wind => _t('Wind', 'காற்று', 'గాలి', 'हवा');

  /// WMO weather codes returned by Open-Meteo.
  String weatherCondition(int code) {
    if (code == 0) {
      return _t('Clear sky', 'தெளிவான வானம்', 'ఆకాశం నిర్మలం', 'साफ़ आसमान');
    }
    if (code == 1) {
      return _t(
        'Mostly clear',
        'பெரும்பாலும் தெளிவு',
        'ఎక్కువగా నిర్మలం',
        'ज़्यादातर साफ़',
      );
    }
    if (code == 2) {
      return _t(
        'Partly cloudy',
        'பகுதி மேகமூட்டம்',
        'పాక్షికంగా మేఘావృతం',
        'आंशिक बादल',
      );
    }
    if (code == 3) {
      return _t('Cloudy', 'மேகமூட்டம்', 'మేఘావృతం', 'बादल छाए हैं');
    }
    if (code == 45 || code == 48) {
      return _t('Foggy', 'பனிமூட்டம்', 'పొగమంచు', 'कोहरा');
    }
    if (code >= 51 && code <= 57) {
      return _t('Drizzle', 'தூறல்', 'చినుకులు', 'बूंदाबांदी');
    }
    if (code >= 61 && code <= 67) {
      return _t('Rain', 'மழை', 'వర్షం', 'बारिश');
    }
    if ((code >= 71 && code <= 77) || code == 85 || code == 86) {
      return _t(
        'Snow',
        'பனிப்பொழிவு',
        'మంచు కురుస్తోంది',
        'बर्फबारी',
      );
    }
    if (code >= 80 && code <= 82) {
      return _t('Rain showers', 'கனமழை', 'జల్లులు', 'तेज़ बौछारें');
    }
    if (code >= 95) {
      return _t(
        'Thunderstorm',
        'இடியுடன் கூடிய மழை',
        'ఉరుములతో వర్షం',
        'आंधी-तूफ़ान',
      );
    }
    return _t('Clear sky', 'தெளிவான வானம்', 'ఆకాశం నిర్మలం', 'साफ़ आसमान');
  }

  // ==========================================================
  // LOGIN PAGE
  // ==========================================================

  String get theDailyEdition => _t(
    'THE DAILY EDITION',
    'தினசரி பதிப்பு',
    'రోజువారీ ఎడిషన్',
    'दैनिक संस्करण',
  );
  String get volNo => _t(
    'VOL. I • NO. 01',
    'தொகுதி I • எண் 01',
    'సంపుటి I • సంఖ్య 01',
    'खंड I • अंक 01',
  );
  String get mastheadClean => _t(
    'CLEAN NEWS',
    'கிளீன் நியூஸ்',
    'క్లీన్ న్యూస్',
    'क्लीन न्यूज़',
  );
  String get mastheadGlobal =>
      _t('GLOBAL', 'குளோபல்', 'గ్లోబల్', 'ग्लोबल');
  String get est => _t(
    'EST. 2026',
    'நிறுவப்பட்டது 2026',
    'స్థాపన 2026',
    'स्थापना 2026',
  );
  String get newsCultureWorld => _t(
    'NEWS • CULTURE • WORLD',
    'செய்தி • கலாச்சாரம் • உலகம்',
    'వార్తలు • సంస్కృతి • ప్రపంచం',
    'समाचार • संस्कृति • विश्व',
  );
  String get daily =>
      _t('DAILY', 'தினசரி', 'రోజువారీ', 'दैनिक');
  String get welcomeReader => _t(
    'WELCOME, READER',
    'வாசகரே, வரவேற்கிறோம்',
    'పాఠకులకు స్వాగతం',
    'पाठकों का स्वागत है',
  );
  String get dailyWindow => _t(
    'Your daily window to the world.',
    'உலகிற்கான உங்கள் தினசரி சாளரம்.',
    'ప్రపంచానికి మీ రోజువారీ కిటికీ.',
    'दुनिया की आपकी रोज़ की खिड़की।',
  );
  String get todaysReader => _t(
    "TODAY'S READER",
    'இன்றைய வாசகர்',
    'నేటి పాఠకుడు',
    'आज के पाठक',
  );
  String get emailId => _t(
    'EMAIL ID',
    'மின்னஞ்சல் முகவரி',
    'ఇమెయిల్ ఐడి',
    'ईमेल आईडी',
  );
  String get enterEmailId => _t(
    'Enter your Email ID',
    'உங்கள் மின்னஞ்சல் முகவரியை உள்ளிடவும்',
    'మీ ఇమెయిల్ ఐడిని నమోదు చేయండి',
    'अपना ईमेल आईडी दर्ज करें',
  );
  String get password => _t(
    'PASSWORD',
    'கடவுச்சொல்',
    'పాస్‌వర్డ్',
    'पासवर्ड',
  );
  String get enterPassword => _t(
    'Enter your password',
    'உங்கள் கடவுச்சொல்லை உள்ளிடவும்',
    'మీ పాస్‌వర్డ్‌ను నమోదు చేయండి',
    'अपना पासवर्ड दर्ज करें',
  );
  String get login =>
      _t('LOGIN', 'உள்நுழை', 'లాగిన్', 'लॉगिन');
  String get firstTimeReading => _t(
    'First time reading? ',
    'முதல் முறையாகப் படிக்கிறீர்களா? ',
    'మొదటిసారి చదువుతున్నారా? ',
    'पहली बार पढ़ रहे हैं? ',
  );
  String get subscribe => _t(
    'Subscribe',
    'சந்தா சேர்',
    'సబ్‌స్క్రైబ్ చేయండి',
    'सब्सक्राइब करें',
  );
  String get loginTagline => _t(
    'A DAILY COLLECTION OF STORIES FROM AROUND THE WORLD',
    'உலகெங்கிலுமிருந்து தினசரி செய்தித் தொகுப்பு',
    'ప్రపంచం నలుమూలల నుండి రోజువారీ వార్తల సమాహారం',
    'दुनिया भर की कहानियों का दैनिक संग्रह',
  );
  String get loginEnterCredentials => _t(
    'Please enter your username and password.',
    'உங்கள் பயனர்பெயர்/மின்னஞ்சல் மற்றும் கடவுச்சொல்லை உள்ளிடவும்.',
    'దయచేసి మీ వినియోగదారు పేరు/ఇమెయిల్ మరియు పాస్‌వర్డ్‌ను నమోదు చేయండి.',
    'कृपया अपना उपयोगकर्ता नाम/ईमेल और पासवर्ड दर्ज करें।',
  );
  String get loginFailed => _t(
    'LOGIN FAILED',
    'உள்நுழைவு தோல்வி',
    'లాగిన్ విఫలమైంది',
    'लॉगिन विफल',
  );

  // ==========================================================
  // REGISTER PAGE
  // ==========================================================

  String get subscribeTitle => _t(
    'SUBSCRIBE',
    'சந்தா',
    'సబ్‌స్క్రైబ్',
    'सब्सक्राइब',
  );
  String get estIndependent => _t(
    'EST. 2026  •  INDEPENDENT NEWS',
    'நிறுவப்பட்டது 2026  •  சுதந்திர செய்திகள்',
    'స్థాపన 2026  •  స్వతంత్ర వార్తలు',
    'स्थापना 2026  •  स्वतंत्र समाचार',
  );
  String get createReaderAccount => _t(
    'Create Your Reader Account',
    'உங்கள் வாசகர் கணக்கை உருவாக்குங்கள்',
    'మీ రీడర్ ఖాతాను సృష్టించండి',
    'अपना पाठक खाता बनाएं',
  );
  String get joinAndStayInformed => _t(
    'Join Clean News Global and stay informed.',
    'கிளீன் நியூஸ் குளோபலில் இணைந்து தகவலறிந்து இருங்கள்.',
    'క్లీన్ న్యూస్ గ్లోబల్‌లో చేరి సమాచారంతో ఉండండి.',
    'क्लीन न्यूज़ ग्लोबल से जुड़ें और जानकारी में रहें।',
  );
  String get readerRegistration => _t(
    'READER REGISTRATION',
    'வாசகர் பதிவு',
    'రీడర్ నమోదు',
    'पाठक पंजीकरण',
  );
  String get usernameCaps => _t(
    'USERNAME',
    'பயனர்பெயர்',
    'వినియోగదారు పేరు',
    'उपयोगकर्ता नाम',
  );
  String get enterUsername => _t(
    'Enter your username',
    'உங்கள் பயனர்பெயரை உள்ளிடவும்',
    'మీ వినియోగదారు పేరును నమోదు చేయండి',
    'अपना उपयोगकर्ता नाम दर्ज करें',
  );
  String get pleaseEnterUsername => _t(
    'Please enter a username',
    'பயனர்பெயரை உள்ளிடவும்',
    'దయచేసి వినియోగదారు పేరును నమోదు చేయండి',
    'कृपया उपयोगकर्ता नाम दर्ज करें',
  );
  String get usernameMinLength => _t(
    'Username must be at least 3 characters',
    'பயனர்பெயர் குறைந்தது 3 எழுத்துகள் இருக்க வேண்டும்',
    'వినియోగదారు పేరు కనీసం 3 అక్షరాలు ఉండాలి',
    'उपयोगकर्ता नाम कम से कम 3 अक्षरों का होना चाहिए',
  );
  String get emailAddress => _t(
    'EMAIL ADDRESS',
    'மின்னஞ்சல் முகவரி',
    'ఇమెయిల్ చిరునామా',
    'ईमेल पता',
  );
  String get enterEmail => _t(
    'Enter your email',
    'உங்கள் மின்னஞ்சலை உள்ளிடவும்',
    'మీ ఇమెయిల్‌ను నమోదు చేయండి',
    'अपना ईमेल दर्ज करें',
  );
  String get pleaseEnterEmail => _t(
    'Please enter your email',
    'மின்னஞ்சலை உள்ளிடவும்',
    'దయచేసి మీ ఇమెయిల్‌ను నమోదు చేయండి',
    'कृपया अपना ईमेल दर्ज करें',
  );
  String get pleaseEnterValidEmail => _t(
    'Please enter a valid email',
    'சரியான மின்னஞ்சலை உள்ளிடவும்',
    'దయచేసి చెల్లుబాటు అయ్యే ఇమెయిల్‌ను నమోదు చేయండి',
    'कृपया मान्य ईमेल दर्ज करें',
  );
  String get createPassword => _t(
    'Create a password',
    'கடவுச்சொல்லை உருவாக்கவும்',
    'పాస్‌వర్డ్‌ను సృష్టించండి',
    'पासवर्ड बनाएं',
  );
  String get pleaseEnterPassword => _t(
    'Please enter a password',
    'கடவுச்சொல்லை உள்ளிடவும்',
    'దయచేసి పాస్‌వర్డ్‌ను నమోదు చేయండి',
    'कृपया पासवर्ड दर्ज करें',
  );
  String get confirmPassword => _t(
    'CONFIRM PASSWORD',
    'கடவுச்சொல்லை உறுதிசெய்',
    'పాస్‌వర్డ్‌ను నిర్ధారించండి',
    'पासवर्ड की पुष्टि करें',
  );
  String get reEnterPassword => _t(
    'Re-enter your password',
    'கடவுச்சொல்லை மீண்டும் உள்ளிடவும்',
    'పాస్‌వర్డ్‌ను మళ్లీ నమోదు చేయండి',
    'पासवर्ड फिर से दर्ज करें',
  );
  String get pleaseConfirmPassword => _t(
    'Please confirm your password',
    'கடவுச்சொல்லை உறுதிசெய்யவும்',
    'దయచేసి పాస్‌వర్డ్‌ను నిర్ధారించండి',
    'कृपया पासवर्ड की पुष्टि करें',
  );
  String get createAccount => _t(
    'CREATE ACCOUNT',
    'கணக்கை உருவாக்கு',
    'ఖాతాను సృష్టించండి',
    'खाता बनाएं',
  );
  String get alreadyHaveAccount => _t(
    'Already have an account?  Back to Login',
    'ஏற்கனவே கணக்கு உள்ளதா?  உள்நுழைவுக்குத் திரும்பு',
    'ఇప్పటికే ఖాతా ఉందా?  లాగిన్‌కు తిరిగి వెళ్లండి',
    'पहले से खाता है?  लॉगिन पर वापस जाएं',
  );
  String get yourDailySource => _t(
    'YOUR DAILY SOURCE FOR CLEAN NEWS',
    'தூய செய்திகளுக்கான உங்கள் தினசரி ஆதாரம்',
    'స్వచ్ఛమైన వార్తలకు మీ రోజువారీ వనరు',
    'साफ़-सुथरी खबरों का आपका दैनिक स्रोत',
  );
  String get accountCreated => _t(
    'ACCOUNT CREATED',
    'கணக்கு உருவாக்கப்பட்டது',
    'ఖాతా సృష్టించబడింది',
    'खाता बन गया',
  );
  String get accountMayExist => _t(
    'Your account may already exist. You can open the verification screen and try sending the email again. Do not register repeatedly with the same email.',
    'உங்கள் கணக்கு ஏற்கனவே உருவாக்கப்பட்டிருக்கலாம். சரிபார்ப்புத் திரையைத் திறந்து மின்னஞ்சலை மீண்டும் அனுப்ப முயற்சிக்கவும். ஒரே மின்னஞ்சலில் மீண்டும் மீண்டும் பதிவு செய்யாதீர்கள்.',
    'మీ ఖాతా ఇప్పటికే సృష్టించబడి ఉండవచ్చు. ధృవీకరణ స్క్రీన్‌ను తెరిచి ఇమెయిల్‌ను మళ్లీ పంపడానికి ప్రయత్నించండి. ఒకే ఇమెయిల్‌తో పదే పదే నమోదు చేయకండి.',
    'आपका खाता पहले से बन चुका हो सकता है। आप सत्यापन स्क्रीन खोलकर ईमेल दोबारा भेजने का प्रयास कर सकते हैं। एक ही ईमेल से बार-बार पंजीकरण न करें।',
  );
  String get stayHere => _t(
    'STAY HERE',
    'இங்கேயே இரு',
    'ఇక్కడే ఉండండి',
    'यहीं रहें',
  );
  String get openVerification => _t(
    'OPEN VERIFICATION',
    'சரிபார்ப்பைத் திற',
    'ధృవీకరణను తెరవండి',
    'सत्यापन खोलें',
  );

  // ==========================================================
  // EMAIL VERIFICATION PAGE
  // ==========================================================

  String get verifyYourEmail => _t(
    'VERIFY YOUR EMAIL',
    'மின்னஞ்சலைச் சரிபார்க்கவும்',
    'మీ ఇమెయిల్‌ను ధృవీకరించండి',
    'अपना ईमेल सत्यापित करें',
  );
  String get noteToReaders => _t(
    'A NOTE TO OUR NEW READERS',
    'எங்கள் புதிய வாசகர்களுக்கு ஒரு குறிப்பு',
    'మా కొత్త పాఠకులకు ఒక గమనిక',
    'हमारे नए पाठकों के लिए एक संदेश',
  );
  String get confirmEmailAddress => _t(
    'Confirm your email address',
    'உங்கள் மின்னஞ்சல் முகவரியை உறுதிசெய்யுங்கள்',
    'మీ ఇమెయిల్ చిరునామాను నిర్ధారించండి',
    'अपने ईमेल पते की पुष्टि करें',
  );
  String get weSentLink => _t(
    'We sent a verification link to:',
    'சரிபார்ப்பு இணைப்பை இங்கு அனுப்பியுள்ளோம்:',
    'ధృవీకరణ లింక్‌ను ఇక్కడికి పంపాము:',
    'हमने सत्यापन लिंक यहां भेजा है:',
  );
  String get verifyInstructions => _t(
    'Open the email and follow its verification link. Then return here and tap “I HAVE VERIFIED”. Check your spam folder if you cannot find the message.',
    'மின்னஞ்சலைத் திறந்து அதிலுள்ள சரிபார்ப்பு இணைப்பைப் பின்பற்றவும். பின்னர் இங்கு திரும்பி “நான் சரிபார்த்துவிட்டேன்” என்பதைத் தட்டவும். மின்னஞ்சல் கிடைக்கவில்லை என்றால் ஸ்பேம் கோப்புறையைச் சரிபார்க்கவும்.',
    'ఇమెయిల్ తెరిచి అందులోని ధృవీకరణ లింక్‌ను అనుసరించండి. ఆ తర్వాత ఇక్కడికి తిరిగి వచ్చి “నేను ధృవీకరించాను” నొక్కండి. సందేశం కనిపించకపోతే స్పామ్ ఫోల్డర్‌ను తనిఖీ చేయండి.',
    'ईमेल खोलें और उसमें दिए सत्यापन लिंक पर क्लिक करें। फिर यहां लौटकर “मैंने सत्यापित कर लिया” दबाएं। संदेश न मिले तो स्पैम फ़ोल्डर देखें।',
  );
  String get iHaveVerified => _t(
    'I HAVE VERIFIED',
    'நான் சரிபார்த்துவிட்டேன்',
    'నేను ధృవీకరించాను',
    'मैंने सत्यापित कर लिया',
  );
  String get resendVerification => _t(
    'RESEND VERIFICATION EMAIL',
    'சரிபார்ப்பு மின்னஞ்சலை மீண்டும் அனுப்பு',
    'ధృవీకరణ ఇమెయిల్‌ను మళ్లీ పంపండి',
    'सत्यापन ईमेल दोबारा भेजें',
  );
  String get signOutBackToLogin => _t(
    'SIGN OUT / BACK TO LOGIN',
    'வெளியேறு / உள்நுழைவுக்குத் திரும்பு',
    'సైన్ అవుట్ / లాగిన్‌కు తిరిగి వెళ్లండి',
    'साइन आउट / लॉगिन पर वापस जाएं',
  );
  String get emailNotVerifiedYet => _t(
    'Email not verified yet. Please open the verification link first.',
    'மின்னஞ்சல் இன்னும் சரிபார்க்கப்படவில்லை. முதலில் சரிபார்ப்பு இணைப்பைத் திறக்கவும்.',
    'ఇమెయిల్ ఇంకా ధృవీకరించబడలేదు. ముందుగా ధృవీకరణ లింక్‌ను తెరవండి.',
    'ईमेल अभी सत्यापित नहीं हुआ है। कृपया पहले सत्यापन लिंक खोलें।',
  );
  String get verificationCheckFailed => _t(
    'Verification check failed',
    'சரிபார்ப்பு தோல்வியடைந்தது',
    'ధృవీకరణ తనిఖీ విఫలమైంది',
    'सत्यापन जांच विफल रही',
  );
  String get verificationResent => _t(
    'If your email is still unverified, a new verification link has been requested.',
    'உங்கள் மின்னஞ்சல் இன்னும் சரிபார்க்கப்படவில்லை என்றால், புதிய சரிபார்ப்பு இணைப்பு கோரப்பட்டுள்ளது.',
    'మీ ఇమెయిల్ ఇంకా ధృవీకరించబడకపోతే, కొత్త ధృవీకరణ లింక్ అభ్యర్థించబడింది.',
    'यदि आपका ईमेल अभी भी सत्यापित नहीं है, तो नया सत्यापन लिंक भेजने का अनुरोध किया गया है।',
  );

  // ==========================================================
  // SAVED ARTICLES (FIRESTORE) + TEXT TO SPEECH
  // ==========================================================

  String get couldNotUpdateSaved => _t(
    'Could not update your saved articles. Please try again.',
    'சேமித்த கட்டுரைகளை புதுப்பிக்க முடியவில்லை. மீண்டும் முயற்சிக்கவும்.',
    'సేవ్ చేసిన వార్తలను అప్‌డేట్ చేయలేకపోయాము. మళ్లీ ప్రయత్నించండి.',
    'सहेजे गए लेख अपडेट नहीं हो सके। कृपया पुनः प्रयास करें।',
  );
  String get couldNotLoadSaved => _t(
    'Could not load your saved articles.',
    'சேமித்த கட்டுரைகளை ஏற்ற முடியவில்லை.',
    'సేవ్ చేసిన వార్తలను లోడ్ చేయలేకపోయాము.',
    'सहेजे गए लेख लोड नहीं हो सके।',
  );
  String get signInToSave => _t(
    'Please sign in to save articles.',
    'கட்டுரைகளைச் சேமிக்க உள்நுழையவும்.',
    'వార్తలను సేవ్ చేయడానికి సైన్ ఇన్ చేయండి.',
    'लेख सहेजने के लिए साइन इन करें।',
  );
  String get listen => _t(
    'Listen',
    'கேளுங்கள்',
    'వినండి',
    'सुनें',
  );
  String get stopListening => _t(
    'Stop',
    'நிறுத்து',
    'ఆపండి',
    'रोकें',
  );
  String get voiceNotAvailable => _t(
    'A voice for this language is not installed on your device. Install it in your phone\'s Text-to-speech settings.',
    'இந்த மொழிக்கான குரல் உங்கள் சாதனத்தில் நிறுவப்படவில்லை. தொலைபேசியின் Text-to-speech அமைப்புகளில் நிறுவவும்.',
    'ఈ భాషకు వాయిస్ మీ పరికరంలో ఇన్‌స్టాల్ చేయబడలేదు. ఫోన్ Text-to-speech సెట్టింగ్స్‌లో ఇన్‌స్టాల్ చేయండి.',
    'इस भाषा की आवाज़ आपके डिवाइस में इंस्टॉल नहीं है। फ़ोन की Text-to-speech सेटिंग्स में इसे इंस्टॉल करें।',
  );
  String get voiceFailed => _t(
    'Could not read the summary aloud.',
    'சுருக்கத்தை வாசிக்க முடியவில்லை.',
    'సారాంశాన్ని చదివి వినిపించలేకపోయాము.',
    'सारांश पढ़कर नहीं सुनाया जा सका।',
  );
}