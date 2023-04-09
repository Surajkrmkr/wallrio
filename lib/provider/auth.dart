import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../constants.dart';
import '../model/user_profile_model.dart';
import '../ui/oauth/login_page.dart';
import '../ui/widgets/toast_widget.dart';

class AuthProvider with ChangeNotifier {
  bool isLoading = false;

  SupabaseClient supabase = Supabase.instance.client;

  UserProfile user = UserProfile();

  set setUser(val) {
    user = val;
    notifyListeners();
  }

  set setIsLoading(val) {
    isLoading = val;
    notifyListeners();
  }

  Future<void> signIn() async {
    setIsLoading = true;
    try {
      await supabase.auth
          .signInWithOAuth(Provider.google, redirectTo: Constants.redirectUri);
    } on AuthException catch (error) {
      ToastWidget.showToast(error.message);
    } catch (error) {
      debugPrint(error.toString());
      ToastWidget.showToast('Unexpected error occurred');
    }
    setIsLoading = false;
  }

  Future<void> signOut(context) async {
    setIsLoading = true;
    try {
      await supabase.auth.signOut();
      ToastWidget.showToast("Logged Out");
    } on AuthException catch (error) {
      ToastWidget.showToast(error.message);
    } catch (error) {
      debugPrint(error.toString());
      ToastWidget.showToast('Unexpected error occurred');
    }
    setIsLoading = false;
  }

  void setUserProfileData() {
    bool userLoggedIn = false;
    if (supabase.auth.currentUser != null) {
      userLoggedIn = true;
    }
    if (userLoggedIn) {
      setUser =
          UserProfile.fromJson(supabase.auth.currentUser!.userMetadata ?? {});
    }
  }
}
