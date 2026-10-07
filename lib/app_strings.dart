class AppStrings {
  final String language;

  AppStrings(this.language);

  // ==========================================================
  // BOTTOM NAVIGATION
  // ==========================================================

  String get home {
    switch (language) {
      case "Tamil":
        return "முகப்பு";
      case "Telugu":
        return "హోమ్";
      case "Hindi":
        return "होम";
      default:
        return "Home";
    }
  }

  String get saved {
    switch (language) {
      case "Tamil":
        return "சேமித்தவை";
      case "Telugu":
        return "సేవ్ చేసినవి";
      case "Hindi":
        return "सहेजे गए";
      default:
        return "Saved";
    }
  }

  String get profile {
    switch (language) {
      case "Tamil":
        return "சுயவிவரம்";
      case "Telugu":
        return "ప్రొఫైల్";
      case "Hindi":
        return "प्रोफ़ाइल";
      default:
        return "Profile";
    }
  }

  String get settings {
    switch (language) {
      case "Tamil":
        return "அமைப்புகள்";
      case "Telugu":
        return "సెట్టింగ్స్";
      case "Hindi":
        return "सेटिंग्स";
      default:
        return "Settings";
    }
  }

  // ==========================================================
  // GENERAL
  // ==========================================================

  String get notifications {
    switch (language) {
      case "Tamil":
        return "அறிவிப்புகள்";
      case "Telugu":
        return "నోటిఫికేషన్లు";
      case "Hindi":
        return "सूचनाएं";
      default:
        return "Notifications";
    }
  }

  String get languageText {
    switch (language) {
      case "Tamil":
        return "மொழி";
      case "Telugu":
        return "భాష";
      case "Hindi":
        return "भाषा";
      default:
        return "Language";
    }
  }

  String get savedArticles {
    switch (language) {
      case "Tamil":
        return "சேமித்த கட்டுரைகள்";
      case "Telugu":
        return "సేవ్ చేసిన కథనాలు";
      case "Hindi":
        return "सहेजे गए लेख";
      default:
        return "Saved Articles";
    }
  }

  String get details {
    switch (language) {
      case "Tamil":
        return "விவரங்கள்";
      case "Telugu":
        return "వివరాలు";
      case "Hindi":
        return "विवरण";
      default:
        return "Details";
    }
  }

  String get aboutUs {
    switch (language) {
      case "Tamil":
        return "எங்களைப் பற்றி";
      case "Telugu":
        return "మా గురించి";
      case "Hindi":
        return "हमारे बारे में";
      default:
        return "About Us";
    }
  }

  String get logout {
    switch (language) {
      case "Tamil":
        return "வெளியேறு";
      case "Telugu":
        return "లాగ్ అవుట్";
      case "Hindi":
        return "लॉग आउट";
      default:
        return "Logout";
    }
  }

  // ==========================================================
  // PASSWORD
  // ==========================================================

  String get changePassword {
    switch (language) {
      case "Tamil":
        return "கடவுச்சொல்லை மாற்று";
      case "Telugu":
        return "పాస్‌వర్డ్ మార్చండి";
      case "Hindi":
        return "पासवर्ड बदलें";
      default:
        return "Change Password";
    }
  }

  String get newPassword {
    switch (language) {
      case "Tamil":
        return "புதிய கடவுச்சொல்";
      case "Telugu":
        return "కొత్త పాస్‌వర్డ్";
      case "Hindi":
        return "नया पासवर्ड";
      default:
        return "New Password";
    }
  }

  String get cancel {
    switch (language) {
      case "Tamil":
        return "ரத்து செய்";
      case "Telugu":
        return "రద్దు";
      case "Hindi":
        return "रद्द करें";
      default:
        return "Cancel";
    }
  }

  String get update {
    switch (language) {
      case "Tamil":
        return "புதுப்பிக்கவும்";
      case "Telugu":
        return "నవీకరించు";
      case "Hindi":
        return "अपडेट करें";
      default:
        return "Update";
    }
  }

  String get passwordUpdatedSuccessfully {
    switch (language) {
      case "Tamil":
        return "கடவுச்சொல் வெற்றிகரமாக மாற்றப்பட்டது.";
      case "Telugu":
        return "పాస్‌వర్డ్ విజయవంతంగా మార్చబడింది.";
      case "Hindi":
        return "पासवर्ड सफलतापूर्वक अपडेट किया गया.";
      default:
        return "Password updated successfully.";
    }
  }

  String get unableToUpdatePassword {
    switch (language) {
      case "Tamil":
        return "கடவுச்சொல்லை மாற்ற முடியவில்லை.";
      case "Telugu":
        return "పాస్‌వర్డ్‌ను మార్చడం సాధ్యం కాలేదు.";
      case "Hindi":
        return "पासवर्ड अपडेट नहीं किया जा सका.";
      default:
        return "Unable to update password.";
    }
  }

  String get samePasswordError {
    switch (language) {
      case "Tamil":
        return "புதிய கடவுச்சொல் தற்போதைய கடவுச்சொல்லைப் போல இருக்கக்கூடாது.";
      case "Telugu":
        return "కొత్త పాస్‌వర్డ్ ప్రస్తుత పాస్‌వర్డ్‌లా ఉండకూడదు.";
      case "Hindi":
        return "नया पासवर्ड वर्तमान पासवर्ड जैसा नहीं होना चाहिए.";
      default:
        return "New password cannot be the same as your current password.";
    }
  }

  String get passwordCannotBeEmpty {
    switch (language) {
      case "Tamil":
        return "கடவுச்சொல் காலியாக இருக்கக்கூடாது.";
      case "Telugu":
        return "పాస్‌వర్డ్ ఖాళీగా ఉండకూడదు.";
      case "Hindi":
        return "पासवर्ड खाली नहीं हो सकता.";
      default:
        return "Password cannot be empty.";
    }
  }

  // ==========================================================
  // DARK MODE
  // ==========================================================

  String get darkMode {
    switch (language) {
      case "Tamil":
        return "இருண்ட பயன்முறை";
      case "Telugu":
        return "డార్క్ మోడ్";
      case "Hindi":
        return "डार्क मोड";
      default:
        return "Dark Mode";
    }
  }

  String get darkThemeEnabled {
    switch (language) {
      case "Tamil":
        return "இருண்ட தீம் இயக்கப்பட்டுள்ளது";
      case "Telugu":
        return "డార్క్ థీమ్ இயக்கించబడింది";
      case "Hindi":
        return "डार्क थीम चालू है";
      default:
        return "Dark theme is enabled";
    }
  }

  String get lightThemeEnabled {
    switch (language) {
      case "Tamil":
        return "ஒளி தீம் இயக்கப்பட்டுள்ளது";
      case "Telugu":
        return "లైట్ థీమ్ ఉపయోగించబడుతోంది";
      case "Hindi":
        return "लाइट थीम चालू है";
      default:
        return "Light theme is enabled";
    }
  }

  // ==========================================================
  // TEXT SIZE
  // ==========================================================

  String get textSize {
    switch (language) {
      case "Tamil":
        return "எழுத்து அளவு";
      case "Telugu":
        return "వచన పరిమాణం";
      case "Hindi":
        return "टेक्स्ट आकार";
      default:
        return "Text Size";
    }
  }

  String get adjustReadingTextSize {
    switch (language) {
      case "Tamil":
        return "வாசிப்பு எழுத்து அளவை மாற்றவும்";
      case "Telugu":
        return "చదివే వచన పరిమాణాన్ని మార్చండి";
      case "Hindi":
        return "पढ़ने के लिए टेक्स्ट आकार बदलें";
      default:
        return "Adjust reading text size";
    }
  }

  String get small {
    switch (language) {
      case "Tamil":
        return "சிறியது";
      case "Telugu":
        return "చిన్నది";
      case "Hindi":
        return "छोटा";
      default:
        return "Small";
    }
  }

  String get normal {
    switch (language) {
      case "Tamil":
        return "இயல்பானது";
      case "Telugu":
        return "సాధారణం";
      case "Hindi":
        return "सामान्य";
      default:
        return "Normal";
    }
  }

  String get large {
    switch (language) {
      case "Tamil":
        return "பெரியது";
      case "Telugu":
        return "పెద్దది";
      case "Hindi":
        return "बड़ा";
      default:
        return "Large";
    }
  }

  // ==========================================================
  // NEWS NOTIFICATIONS
  // ==========================================================

  String get manageNewsNotifications {
    switch (language) {
      case "Tamil":
        return "செய்தி அறிவிப்புகளை நிர்வகிக்கவும்";
      case "Telugu":
        return "వార్తా నోటిఫికేషన్లను నిర్వహించండి";
      case "Hindi":
        return "समाचार सूचनाएं प्रबंधित करें";
      default:
        return "Manage news notifications";
    }
  }

  String get newsNotificationsEnabled {
    switch (language) {
      case "Tamil":
        return "செய்தி அறிவிப்புகள் இயக்கப்பட்டுள்ளன";
      case "Telugu":
        return "వార్తా నోటిఫికేషన్లు ప్రారంభించబడ్డాయి";
      case "Hindi":
        return "समाचार सूचनाएं चालू हैं";
      default:
        return "News notifications are enabled";
    }
  }

  String get newsNotificationsDisabled {
    switch (language) {
      case "Tamil":
        return "செய்தி அறிவிப்புகள் முடக்கப்பட்டுள்ளன";
      case "Telugu":
        return "వార్తా నోటిఫికేషన్లు నిలిపివేయబడ్డాయి";
      case "Hindi":
        return "समाचार सूचनाएं बंद हैं";
      default:
        return "News notifications are disabled";
    }
  }

  // ==========================================================
  // USER DETAILS
  // ==========================================================

  String get viewUsernameEmail {
    switch (language) {
      case "Tamil":
        return "பயனர்பெயர் மற்றும் மின்னஞ்சலைப் பார்க்கவும்";
      case "Telugu":
        return "వినియోగదారు పేరు మరియు ఇమెయిల్ చూడండి";
      case "Hindi":
        return "उपयोगकर्ता नाम और ईमेल देखें";
      default:
        return "View username and email";
    }
  }

  // ==========================================================
  // ABOUT
  // ==========================================================

  String get aboutCleanNews {
    switch (language) {
      case "Tamil":
        return "க்ளீன் நியூஸ் குளோபல் பற்றி";
      case "Telugu":
        return "ది క్లీన్ న్యూస్ గ్లోబల్ గురించి";
      case "Hindi":
        return "द क्लीन न्यूज़ ग्लोबल के बारे में";
      default:
        return "About The Clean News Global";
    }
  }

  String get aboutCleanNewsDescription {
    switch (language) {
      case "Tamil":
        return "தி க்ளீன் நியூஸ் குளோபல் இந்தியா மற்றும் உலகம் முழுவதிலிருந்தும் செய்திகளை எளிமையாகவும் சுத்தமாகவும் படிக்க உதவுகிறது.";
      case "Telugu":
        return "ది క్లీన్ న్యూస్ గ్లోబల్ భారతదేశం మరియు ప్రపంచవ్యాప్తంగా వార్తలను సులభంగా మరియు సరళంగా తెలుసుకోవడానికి సహాయపడుతుంది.";
      case "Hindi":
        return "द क्लीन न्यूज़ ग्लोबल भारत और दुनिया भर की खबरों को सरल और साफ तरीके से पढ़ने की सुविधा देता है.";
      default:
        return "The Clean News Global provides a clean and simple way to discover and read news from India and around the world.";
    }
  }

  // ==========================================================
  // PRIVACY
  // ==========================================================

  String get privacyPolicy {
    switch (language) {
      case "Tamil":
        return "தனியுரிமைக் கொள்கை";
      case "Telugu":
        return "గోప్యతా విధానం";
      case "Hindi":
        return "गोपनीयता नीति";
      default:
        return "Privacy Policy";
    }
  }

  String get privacyPolicyDescription {
    switch (language) {
      case "Tamil":
        return "உங்கள் கணக்கு தகவல்கள் தி க்ளீன் நியூஸ் குளோபலின் அம்சங்களை வழங்குவதற்காக மட்டுமே பயன்படுத்தப்படுகின்றன. உங்கள் தனிப்பட்ட கணக்கு தகவல்கள் பொதுவாக வெளியிடப்படாது.";
      case "Telugu":
        return "మీ ఖాతా సమాచారం ది క్లీన్ న్యూస్ గ్లోబల్ ఫీచర్లను అందించడానికి మాత్రమే ఉపయోగించబడుతుంది. మీ వ్యక్తిగత ఖాతా సమాచారం పబ్లిక్‌గా ప్రదర్శించబడదు.";
      case "Hindi":
        return "आपकी खाता जानकारी का उपयोग केवल द क्लीन न्यूज़ ग्लोबल की सुविधाएं प्रदान करने के लिए किया जाता है. आपकी निजी खाता जानकारी सार्वजनिक रूप से प्रदर्शित नहीं की जाती.";
      default:
        return "Your account information is used only to provide the features of The Clean News Global. We do not display your private account information publicly.";
    }
  }

  // ==========================================================
  // DIALOG BUTTONS
  // ==========================================================

  String get okay {
    switch (language) {
      case "Tamil":
        return "சரி";
      case "Telugu":
        return "సరే";
      case "Hindi":
        return "ठीक है";
      default:
        return "Okay";
    }
  }

  String get close {
    switch (language) {
      case "Tamil":
        return "மூடு";
      case "Telugu":
        return "మూసివేయి";
      case "Hindi":
        return "बंद करें";
      default:
        return "Close";
    }
  }

  String get selectLanguage {
    switch (language) {
      case "Tamil":
        return "மொழியைத் தேர்ந்தெடுக்கவும்";
      case "Telugu":
        return "భాషను ఎంచుకోండి";
      case "Hindi":
        return "भाषा चुनें";
      default:
        return "Select Language";
    }
  }
}
