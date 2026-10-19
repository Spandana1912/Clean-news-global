class AppStrings {
  final String language;

  AppStrings(this.language);

  // ==========================================================
  // BOTTOM NAVIGATION
  // ==========================================================

  String get home {
    switch (language) {
      case "Tamil":
        return "à®®à¯à®•à®ªà¯à®ªà¯";
      case "Telugu":
        return "à°¹à±‹à°®à±";
      case "Hindi":
        return "à¤¹à¥‹à¤®";
      default:
        return "Home";
    }
  }

  String get saved {
    switch (language) {
      case "Tamil":
        return "à®šà¯‡à®®à®¿à®¤à¯à®¤à®µà¯ˆ";
      case "Telugu":
        return "à°¸à±‡à°µà± à°šà±‡à°¸à°¿à°¨à°µà°¿";
      case "Hindi":
        return "à¤¸à¤¹à¥‡à¤œà¥‡ à¤—à¤";
      default:
        return "Saved";
    }
  }

  String get profile {
    switch (language) {
      case "Tamil":
        return "à®šà¯à®¯à®µà®¿à®µà®°à®®à¯";
      case "Telugu":
        return "à°ªà±à°°à±Šà°«à±ˆà°²à±";
      case "Hindi":
        return "à¤ªà¥à¤°à¥‹à¤«à¤¼à¤¾à¤‡à¤²";
      default:
        return "Profile";
    }
  }

  String get settings {
    switch (language) {
      case "Tamil":
        return "à®…à®®à¯ˆà®ªà¯à®ªà¯à®•à®³à¯";
      case "Telugu":
        return "à°¸à±†à°Ÿà±à°Ÿà°¿à°‚à°—à±à°¸à±";
      case "Hindi":
        return "à¤¸à¥‡à¤Ÿà¤¿à¤‚à¤—à¥à¤¸";
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
        return "à®…à®±à®¿à®µà®¿à®ªà¯à®ªà¯à®•à®³à¯";
      case "Telugu":
        return "à°¨à±‹à°Ÿà°¿à°«à°¿à°•à±‡à°·à°¨à±à°²à±";
      case "Hindi":
        return "à¤¸à¥‚à¤šà¤¨à¤¾à¤à¤‚";
      default:
        return "Notifications";
    }
  }

  String get languageText {
    switch (language) {
      case "Tamil":
        return "à®®à¯Šà®´à®¿";
      case "Telugu":
        return "à°­à°¾à°·";
      case "Hindi":
        return "à¤­à¤¾à¤·à¤¾";
      default:
        return "Language";
    }
  }

  String get savedArticles {
    switch (language) {
      case "Tamil":
        return "à®šà¯‡à®®à®¿à®¤à¯à®¤ à®•à®Ÿà¯à®Ÿà¯à®°à¯ˆà®•à®³à¯";
      case "Telugu":
        return "à°¸à±‡à°µà± à°šà±‡à°¸à°¿à°¨ à°•à°¥à°¨à°¾à°²à±";
      case "Hindi":
        return "à¤¸à¤¹à¥‡à¤œà¥‡ à¤—à¤ à¤²à¥‡à¤–";
      default:
        return "Saved Articles";
    }
  }

  String get details {
    switch (language) {
      case "Tamil":
        return "à®µà®¿à®µà®°à®™à¯à®•à®³à¯";
      case "Telugu":
        return "à°µà°¿à°µà°°à°¾à°²à±";
      case "Hindi":
        return "à¤µà¤¿à¤µà¤°à¤£";
      default:
        return "Details";
    }
  }

  String get aboutUs {
    switch (language) {
      case "Tamil":
        return "à®Žà®™à¯à®•à®³à¯ˆà®ªà¯ à®ªà®±à¯à®±à®¿";
      case "Telugu":
        return "à°®à°¾ à°—à±à°°à°¿à°‚à°šà°¿";
      case "Hindi":
        return "à¤¹à¤®à¤¾à¤°à¥‡ à¤¬à¤¾à¤°à¥‡ à¤®à¥‡à¤‚";
      default:
        return "About Us";
    }
  }

  String get logout {
    switch (language) {
      case "Tamil":
        return "à®µà¯†à®³à®¿à®¯à¯‡à®±à¯";
      case "Telugu":
        return "à°²à°¾à°—à± à°…à°µà±à°Ÿà±";
      case "Hindi":
        return "à¤²à¥‰à¤— à¤†à¤‰à¤Ÿ";
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
        return "à®•à®Ÿà®µà¯à®šà¯à®šà¯Šà®²à¯à®²à¯ˆ à®®à®¾à®±à¯à®±à¯";
      case "Telugu":
        return "à°ªà°¾à°¸à±â€Œà°µà°°à±à°¡à± à°®à°¾à°°à±à°šà°‚à°¡à°¿";
      case "Hindi":
        return "à¤ªà¤¾à¤¸à¤µà¤°à¥à¤¡ à¤¬à¤¦à¤²à¥‡à¤‚";
      default:
        return "Change Password";
    }
  }

  String get newPassword {
    switch (language) {
      case "Tamil":
        return "à®ªà¯à®¤à®¿à®¯ à®•à®Ÿà®µà¯à®šà¯à®šà¯Šà®²à¯";
      case "Telugu":
        return "à°•à±Šà°¤à±à°¤ à°ªà°¾à°¸à±â€Œà°µà°°à±à°¡à±";
      case "Hindi":
        return "à¤¨à¤¯à¤¾ à¤ªà¤¾à¤¸à¤µà¤°à¥à¤¡";
      default:
        return "New Password";
    }
  }

  String get cancel {
    switch (language) {
      case "Tamil":
        return "à®°à®¤à¯à®¤à¯ à®šà¯†à®¯à¯";
      case "Telugu":
        return "à°°à°¦à±à°¦à±";
      case "Hindi":
        return "à¤°à¤¦à¥à¤¦ à¤•à¤°à¥‡à¤‚";
      default:
        return "Cancel";
    }
  }

  String get update {
    switch (language) {
      case "Tamil":
        return "à®ªà¯à®¤à¯à®ªà¯à®ªà®¿à®•à¯à®•à®µà¯à®®à¯";
      case "Telugu":
        return "à°¨à°µà±€à°•à°°à°¿à°‚à°šà±";
      case "Hindi":
        return "à¤…à¤ªà¤¡à¥‡à¤Ÿ à¤•à¤°à¥‡à¤‚";
      default:
        return "Update";
    }
  }

  String get passwordUpdatedSuccessfully {
    switch (language) {
      case "Tamil":
        return "à®•à®Ÿà®µà¯à®šà¯à®šà¯Šà®²à¯ à®µà¯†à®±à¯à®±à®¿à®•à®°à®®à®¾à®• à®®à®¾à®±à¯à®±à®ªà¯à®ªà®Ÿà¯à®Ÿà®¤à¯.";
      case "Telugu":
        return "à°ªà°¾à°¸à±â€Œà°µà°°à±à°¡à± à°µà°¿à°œà°¯à°µà°‚à°¤à°‚à°—à°¾ à°®à°¾à°°à±à°šà°¬à°¡à°¿à°‚à°¦à°¿.";
      case "Hindi":
        return "à¤ªà¤¾à¤¸à¤µà¤°à¥à¤¡ à¤¸à¤«à¤²à¤¤à¤¾à¤ªà¥‚à¤°à¥à¤µà¤• à¤…à¤ªà¤¡à¥‡à¤Ÿ à¤•à¤¿à¤¯à¤¾ à¤—à¤¯à¤¾.";
      default:
        return "Password updated successfully.";
    }
  }

  String get unableToUpdatePassword {
    switch (language) {
      case "Tamil":
        return "à®•à®Ÿà®µà¯à®šà¯à®šà¯Šà®²à¯à®²à¯ˆ à®®à®¾à®±à¯à®± à®®à¯à®Ÿà®¿à®¯à®µà®¿à®²à¯à®²à¯ˆ.";
      case "Telugu":
        return "à°ªà°¾à°¸à±â€Œà°µà°°à±à°¡à±â€Œà°¨à± à°®à°¾à°°à±à°šà°¡à°‚ à°¸à°¾à°§à±à°¯à°‚ à°•à°¾à°²à±‡à°¦à±.";
      case "Hindi":
        return "à¤ªà¤¾à¤¸à¤µà¤°à¥à¤¡ à¤…à¤ªà¤¡à¥‡à¤Ÿ à¤¨à¤¹à¥€à¤‚ à¤•à¤¿à¤¯à¤¾ à¤œà¤¾ à¤¸à¤•à¤¾.";
      default:
        return "Unable to update password.";
    }
  }

  String get samePasswordError {
    switch (language) {
      case "Tamil":
        return "à®ªà¯à®¤à®¿à®¯ à®•à®Ÿà®µà¯à®šà¯à®šà¯Šà®²à¯ à®¤à®±à¯à®ªà¯‹à®¤à¯ˆà®¯ à®•à®Ÿà®µà¯à®šà¯à®šà¯Šà®²à¯à®²à¯ˆà®ªà¯ à®ªà¯‹à®² à®‡à®°à¯à®•à¯à®•à®•à¯à®•à¯‚à®Ÿà®¾à®¤à¯.";
      case "Telugu":
        return "à°•à±Šà°¤à±à°¤ à°ªà°¾à°¸à±â€Œà°µà°°à±à°¡à± à°ªà±à°°à°¸à±à°¤à±à°¤ à°ªà°¾à°¸à±â€Œà°µà°°à±à°¡à±â€Œà°²à°¾ à°‰à°‚à°¡à°•à±‚à°¡à°¦à±.";
      case "Hindi":
        return "à¤¨à¤¯à¤¾ à¤ªà¤¾à¤¸à¤µà¤°à¥à¤¡ à¤µà¤°à¥à¤¤à¤®à¤¾à¤¨ à¤ªà¤¾à¤¸à¤µà¤°à¥à¤¡ à¤œà¥ˆà¤¸à¤¾ à¤¨à¤¹à¥€à¤‚ à¤¹à¥‹à¤¨à¤¾ à¤šà¤¾à¤¹à¤¿à¤.";
      default:
        return "New password cannot be the same as your current password.";
    }
  }

  String get passwordCannotBeEmpty {
    switch (language) {
      case "Tamil":
        return "à®•à®Ÿà®µà¯à®šà¯à®šà¯Šà®²à¯ à®•à®¾à®²à®¿à®¯à®¾à®• à®‡à®°à¯à®•à¯à®•à®•à¯à®•à¯‚à®Ÿà®¾à®¤à¯.";
      case "Telugu":
        return "à°ªà°¾à°¸à±â€Œà°µà°°à±à°¡à± à°–à°¾à°³à±€à°—à°¾ à°‰à°‚à°¡à°•à±‚à°¡à°¦à±.";
      case "Hindi":
        return "à¤ªà¤¾à¤¸à¤µà¤°à¥à¤¡ à¤–à¤¾à¤²à¥€ à¤¨à¤¹à¥€à¤‚ à¤¹à¥‹ à¤¸à¤•à¤¤à¤¾.";
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
        return "à®‡à®°à¯à®£à¯à®Ÿ à®ªà®¯à®©à¯à®®à¯à®±à¯ˆ";
      case "Telugu":
        return "à°¡à°¾à°°à±à°•à± à°®à±‹à°¡à±";
      case "Hindi":
        return "à¤¡à¤¾à¤°à¥à¤• à¤®à¥‹à¤¡";
      default:
        return "Dark Mode";
    }
  }

  String get darkThemeEnabled {
    switch (language) {
      case "Tamil":
        return "à®‡à®°à¯à®£à¯à®Ÿ à®¤à¯€à®®à¯ à®‡à®¯à®•à¯à®•à®ªà¯à®ªà®Ÿà¯à®Ÿà¯à®³à¯à®³à®¤à¯";
      case "Telugu":
        return "à°¡à°¾à°°à±à°•à± à°¥à±€à°®à± à®‡à®¯à®•à¯à®•à°¿à°‚à°šà°¬à°¡à°¿à°‚à°¦à°¿";
      case "Hindi":
        return "à¤¡à¤¾à¤°à¥à¤• à¤¥à¥€à¤® à¤šà¤¾à¤²à¥‚ à¤¹à¥ˆ";
      default:
        return "Dark theme is enabled";
    }
  }

  String get lightThemeEnabled {
    switch (language) {
      case "Tamil":
        return "à®’à®³à®¿ à®¤à¯€à®®à¯ à®‡à®¯à®•à¯à®•à®ªà¯à®ªà®Ÿà¯à®Ÿà¯à®³à¯à®³à®¤à¯";
      case "Telugu":
        return "à°²à±ˆà°Ÿà± à°¥à±€à°®à± à°‰à°ªà°¯à±‹à°—à°¿à°‚à°šà°¬à°¡à±à°¤à±‹à°‚à°¦à°¿";
      case "Hindi":
        return "à¤²à¤¾à¤‡à¤Ÿ à¤¥à¥€à¤® à¤šà¤¾à¤²à¥‚ à¤¹à¥ˆ";
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
        return "à®Žà®´à¯à®¤à¯à®¤à¯ à®…à®³à®µà¯";
      case "Telugu":
        return "à°µà°šà°¨ à°ªà°°à°¿à°®à°¾à°£à°‚";
      case "Hindi":
        return "à¤Ÿà¥‡à¤•à¥à¤¸à¥à¤Ÿ à¤†à¤•à¤¾à¤°";
      default:
        return "Text Size";
    }
  }

  String get adjustReadingTextSize {
    switch (language) {
      case "Tamil":
        return "à®µà®¾à®šà®¿à®ªà¯à®ªà¯ à®Žà®´à¯à®¤à¯à®¤à¯ à®…à®³à®µà¯ˆ à®®à®¾à®±à¯à®±à®µà¯à®®à¯";
      case "Telugu":
        return "à°šà°¦à°¿à°µà±‡ à°µà°šà°¨ à°ªà°°à°¿à°®à°¾à°£à°¾à°¨à±à°¨à°¿ à°®à°¾à°°à±à°šà°‚à°¡à°¿";
      case "Hindi":
        return "à¤ªà¤¢à¤¼à¤¨à¥‡ à¤•à¥‡ à¤²à¤¿à¤ à¤Ÿà¥‡à¤•à¥à¤¸à¥à¤Ÿ à¤†à¤•à¤¾à¤° à¤¬à¤¦à¤²à¥‡à¤‚";
      default:
        return "Adjust reading text size";
    }
  }

  String get small {
    switch (language) {
      case "Tamil":
        return "à®šà®¿à®±à®¿à®¯à®¤à¯";
      case "Telugu":
        return "à°šà°¿à°¨à±à°¨à°¦à°¿";
      case "Hindi":
        return "à¤›à¥‹à¤Ÿà¤¾";
      default:
        return "Small";
    }
  }

  String get normal {
    switch (language) {
      case "Tamil":
        return "à®‡à®¯à®²à¯à®ªà®¾à®©à®¤à¯";
      case "Telugu":
        return "à°¸à°¾à°§à°¾à°°à°£à°‚";
      case "Hindi":
        return "à¤¸à¤¾à¤®à¤¾à¤¨à¥à¤¯";
      default:
        return "Normal";
    }
  }

  String get large {
    switch (language) {
      case "Tamil":
        return "à®ªà¯†à®°à®¿à®¯à®¤à¯";
      case "Telugu":
        return "à°ªà±†à°¦à±à°¦à°¦à°¿";
      case "Hindi":
        return "à¤¬à¤¡à¤¼à¤¾";
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
        return "à®šà¯†à®¯à¯à®¤à®¿ à®…à®±à®¿à®µà®¿à®ªà¯à®ªà¯à®•à®³à¯ˆ à®¨à®¿à®°à¯à®µà®•à®¿à®•à¯à®•à®µà¯à®®à¯";
      case "Telugu":
        return "à°µà°¾à°°à±à°¤à°¾ à°¨à±‹à°Ÿà°¿à°«à°¿à°•à±‡à°·à°¨à±à°²à°¨à± à°¨à°¿à°°à±à°µà°¹à°¿à°‚à°šà°‚à°¡à°¿";
      case "Hindi":
        return "à¤¸à¤®à¤¾à¤šà¤¾à¤° à¤¸à¥‚à¤šà¤¨à¤¾à¤à¤‚ à¤ªà¥à¤°à¤¬à¤‚à¤§à¤¿à¤¤ à¤•à¤°à¥‡à¤‚";
      default:
        return "Manage news notifications";
    }
  }

  String get newsNotificationsEnabled {
    switch (language) {
      case "Tamil":
        return "à®šà¯†à®¯à¯à®¤à®¿ à®…à®±à®¿à®µà®¿à®ªà¯à®ªà¯à®•à®³à¯ à®‡à®¯à®•à¯à®•à®ªà¯à®ªà®Ÿà¯à®Ÿà¯à®³à¯à®³à®©";
      case "Telugu":
        return "à°µà°¾à°°à±à°¤à°¾ à°¨à±‹à°Ÿà°¿à°«à°¿à°•à±‡à°·à°¨à±à°²à± à°ªà±à°°à°¾à°°à°‚à°­à°¿à°‚à°šà°¬à°¡à±à°¡à°¾à°¯à°¿";
      case "Hindi":
        return "à¤¸à¤®à¤¾à¤šà¤¾à¤° à¤¸à¥‚à¤šà¤¨à¤¾à¤à¤‚ à¤šà¤¾à¤²à¥‚ à¤¹à¥ˆà¤‚";
      default:
        return "News notifications are enabled";
    }
  }

  String get newsNotificationsDisabled {
    switch (language) {
      case "Tamil":
        return "à®šà¯†à®¯à¯à®¤à®¿ à®…à®±à®¿à®µà®¿à®ªà¯à®ªà¯à®•à®³à¯ à®®à¯à®Ÿà®•à¯à®•à®ªà¯à®ªà®Ÿà¯à®Ÿà¯à®³à¯à®³à®©";
      case "Telugu":
        return "à°µà°¾à°°à±à°¤à°¾ à°¨à±‹à°Ÿà°¿à°«à°¿à°•à±‡à°·à°¨à±à°²à± à°¨à°¿à°²à°¿à°ªà°¿à°µà±‡à°¯à°¬à°¡à±à°¡à°¾à°¯à°¿";
      case "Hindi":
        return "à¤¸à¤®à¤¾à¤šà¤¾à¤° à¤¸à¥‚à¤šà¤¨à¤¾à¤à¤‚ à¤¬à¤‚à¤¦ à¤¹à¥ˆà¤‚";
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
        return "à®ªà®¯à®©à®°à¯à®ªà¯†à®¯à®°à¯ à®®à®±à¯à®±à¯à®®à¯ à®®à®¿à®©à¯à®©à®žà¯à®šà®²à¯ˆà®ªà¯ à®ªà®¾à®°à¯à®•à¯à®•à®µà¯à®®à¯";
      case "Telugu":
        return "à°µà°¿à°¨à°¿à°¯à±‹à°—à°¦à°¾à°°à± à°ªà±‡à°°à± à°®à°°à°¿à°¯à± à°‡à°®à±†à°¯à°¿à°²à± à°šà±‚à°¡à°‚à°¡à°¿";
      case "Hindi":
        return "à¤‰à¤ªà¤¯à¥‹à¤—à¤•à¤°à¥à¤¤à¤¾ à¤¨à¤¾à¤® à¤”à¤° à¤ˆà¤®à¥‡à¤² à¤¦à¥‡à¤–à¥‡à¤‚";
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
        return "à®•à¯à®³à¯€à®©à¯ à®¨à®¿à®¯à¯‚à®¸à¯ à®•à¯à®³à¯‹à®ªà®²à¯ à®ªà®±à¯à®±à®¿";
      case "Telugu":
        return "à°¦à°¿ à°•à±à°²à±€à°¨à± à°¨à±à°¯à±‚à°¸à± à°—à±à°²à±‹à°¬à°²à± à°—à±à°°à°¿à°‚à°šà°¿";
      case "Hindi":
        return "à¤¦ à¤•à¥à¤²à¥€à¤¨ à¤¨à¥à¤¯à¥‚à¤œà¤¼ à¤—à¥à¤²à¥‹à¤¬à¤² à¤•à¥‡ à¤¬à¤¾à¤°à¥‡ à¤®à¥‡à¤‚";
      default:
        return "About The Clean News Global";
    }
  }

  String get aboutCleanNewsDescription {
    switch (language) {
      case "Tamil":
        return "à®¤à®¿ à®•à¯à®³à¯€à®©à¯ à®¨à®¿à®¯à¯‚à®¸à¯ à®•à¯à®³à¯‹à®ªà®²à¯ à®‡à®¨à¯à®¤à®¿à®¯à®¾ à®®à®±à¯à®±à¯à®®à¯ à®‰à®²à®•à®®à¯ à®®à¯à®´à¯à®µà®¤à®¿à®²à®¿à®°à¯à®¨à¯à®¤à¯à®®à¯ à®šà¯†à®¯à¯à®¤à®¿à®•à®³à¯ˆ à®Žà®³à®¿à®®à¯ˆà®¯à®¾à®•à®µà¯à®®à¯ à®šà¯à®¤à¯à®¤à®®à®¾à®•à®µà¯à®®à¯ à®ªà®Ÿà®¿à®•à¯à®• à®‰à®¤à®µà¯à®•à®¿à®±à®¤à¯.";
      case "Telugu":
        return "à°¦à°¿ à°•à±à°²à±€à°¨à± à°¨à±à°¯à±‚à°¸à± à°—à±à°²à±‹à°¬à°²à± à°­à°¾à°°à°¤à°¦à±‡à°¶à°‚ à°®à°°à°¿à°¯à± à°ªà±à°°à°ªà°‚à°šà°µà±à°¯à°¾à°ªà±à°¤à°‚à°—à°¾ à°µà°¾à°°à±à°¤à°²à°¨à± à°¸à±à°²à°­à°‚à°—à°¾ à°®à°°à°¿à°¯à± à°¸à°°à°³à°‚à°—à°¾ à°¤à±†à°²à±à°¸à±à°•à±‹à°µà°¡à°¾à°¨à°¿à°•à°¿ à°¸à°¹à°¾à°¯à°ªà°¡à±à°¤à±à°‚à°¦à°¿.";
      case "Hindi":
        return "à¤¦ à¤•à¥à¤²à¥€à¤¨ à¤¨à¥à¤¯à¥‚à¤œà¤¼ à¤—à¥à¤²à¥‹à¤¬à¤² à¤­à¤¾à¤°à¤¤ à¤”à¤° à¤¦à¥à¤¨à¤¿à¤¯à¤¾ à¤­à¤° à¤•à¥€ à¤–à¤¬à¤°à¥‹à¤‚ à¤•à¥‹ à¤¸à¤°à¤² à¤”à¤° à¤¸à¤¾à¤« à¤¤à¤°à¥€à¤•à¥‡ à¤¸à¥‡ à¤ªà¤¢à¤¼à¤¨à¥‡ à¤•à¥€ à¤¸à¥à¤µà¤¿à¤§à¤¾ à¤¦à¥‡à¤¤à¤¾ à¤¹à¥ˆ.";
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
        return "à®¤à®©à®¿à®¯à¯à®°à®¿à®®à¯ˆà®•à¯ à®•à¯Šà®³à¯à®•à¯ˆ";
      case "Telugu":
        return "à°—à±‹à°ªà±à°¯à°¤à°¾ à°µà°¿à°§à°¾à°¨à°‚";
      case "Hindi":
        return "à¤—à¥‹à¤ªà¤¨à¥€à¤¯à¤¤à¤¾ à¤¨à¥€à¤¤à¤¿";
      default:
        return "Privacy Policy";
    }
  }

  String get privacyPolicyDescription {
    switch (language) {
      case "Tamil":
        return "à®‰à®™à¯à®•à®³à¯ à®•à®£à®•à¯à®•à¯ à®¤à®•à®µà®²à¯à®•à®³à¯ à®¤à®¿ à®•à¯à®³à¯€à®©à¯ à®¨à®¿à®¯à¯‚à®¸à¯ à®•à¯à®³à¯‹à®ªà®²à®¿à®©à¯ à®…à®®à¯à®šà®™à¯à®•à®³à¯ˆ à®µà®´à®™à¯à®•à¯à®µà®¤à®±à¯à®•à®¾à®• à®®à®Ÿà¯à®Ÿà¯à®®à¯‡ à®ªà®¯à®©à¯à®ªà®Ÿà¯à®¤à¯à®¤à®ªà¯à®ªà®Ÿà¯à®•à®¿à®©à¯à®±à®©. à®‰à®™à¯à®•à®³à¯ à®¤à®©à®¿à®ªà¯à®ªà®Ÿà¯à®Ÿ à®•à®£à®•à¯à®•à¯ à®¤à®•à®µà®²à¯à®•à®³à¯ à®ªà¯Šà®¤à¯à®µà®¾à®• à®µà¯†à®³à®¿à®¯à®¿à®Ÿà®ªà¯à®ªà®Ÿà®¾à®¤à¯.";
      case "Telugu":
        return "à°®à±€ à°–à°¾à°¤à°¾ à°¸à°®à°¾à°šà°¾à°°à°‚ à°¦à°¿ à°•à±à°²à±€à°¨à± à°¨à±à°¯à±‚à°¸à± à°—à±à°²à±‹à°¬à°²à± à°«à±€à°šà°°à±à°²à°¨à± à°…à°‚à°¦à°¿à°‚à°šà°¡à°¾à°¨à°¿à°•à°¿ à°®à°¾à°¤à±à°°à°®à±‡ à°‰à°ªà°¯à±‹à°—à°¿à°‚à°šà°¬à°¡à±à°¤à±à°‚à°¦à°¿. à°®à±€ à°µà±à°¯à°•à±à°¤à°¿à°—à°¤ à°–à°¾à°¤à°¾ à°¸à°®à°¾à°šà°¾à°°à°‚ à°ªà°¬à±à°²à°¿à°•à±â€Œà°—à°¾ à°ªà±à°°à°¦à°°à±à°¶à°¿à°‚à°šà°¬à°¡à°¦à±.";
      case "Hindi":
        return "à¤†à¤ªà¤•à¥€ à¤–à¤¾à¤¤à¤¾ à¤œà¤¾à¤¨à¤•à¤¾à¤°à¥€ à¤•à¤¾ à¤‰à¤ªà¤¯à¥‹à¤— à¤•à¥‡à¤µà¤² à¤¦ à¤•à¥à¤²à¥€à¤¨ à¤¨à¥à¤¯à¥‚à¤œà¤¼ à¤—à¥à¤²à¥‹à¤¬à¤² à¤•à¥€ à¤¸à¥à¤µà¤¿à¤§à¤¾à¤à¤‚ à¤ªà¥à¤°à¤¦à¤¾à¤¨ à¤•à¤°à¤¨à¥‡ à¤•à¥‡ à¤²à¤¿à¤ à¤•à¤¿à¤¯à¤¾ à¤œà¤¾à¤¤à¤¾ à¤¹à¥ˆ. à¤†à¤ªà¤•à¥€ à¤¨à¤¿à¤œà¥€ à¤–à¤¾à¤¤à¤¾ à¤œà¤¾à¤¨à¤•à¤¾à¤°à¥€ à¤¸à¤¾à¤°à¥à¤µà¤œà¤¨à¤¿à¤• à¤°à¥‚à¤ª à¤¸à¥‡ à¤ªà¥à¤°à¤¦à¤°à¥à¤¶à¤¿à¤¤ à¤¨à¤¹à¥€à¤‚ à¤•à¥€ à¤œà¤¾à¤¤à¥€.";
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
        return "à®šà®°à®¿";
      case "Telugu":
        return "à°¸à°°à±‡";
      case "Hindi":
        return "à¤ à¥€à¤• à¤¹à¥ˆ";
      default:
        return "Okay";
    }
  }

  String get close {
    switch (language) {
      case "Tamil":
        return "à®®à¯‚à®Ÿà¯";
      case "Telugu":
        return "à°®à±‚à°¸à°¿à°µà±‡à°¯à°¿";
      case "Hindi":
        return "à¤¬à¤‚à¤¦ à¤•à¤°à¥‡à¤‚";
      default:
        return "Close";
    }
  }

  String get selectLanguage {
    switch (language) {
      case "Tamil":
        return "à®®à¯Šà®´à®¿à®¯à¯ˆà®¤à¯ à®¤à¯‡à®°à¯à®¨à¯à®¤à¯†à®Ÿà¯à®•à¯à®•à®µà¯à®®à¯";
      case "Telugu":
        return "à°­à°¾à°·à°¨à± à°Žà°‚à°šà±à°•à±‹à°‚à°¡à°¿";
      case "Hindi":
        return "à¤­à¤¾à¤·à¤¾ à¤šà¥à¤¨à¥‡à¤‚";
      default:
        return "Select Language";
    }
  }
}
