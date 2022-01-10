abstract class AppStates {}

class AppInitialState extends AppStates {}

class AppLoadingState extends AppStates {}

class AppChangeGrantedValueState extends AppStates {}

class AppEncryptionFileLoadingState extends AppStates {}

class AppEncryptionFileSuccessState extends AppStates {}

class AppEncryptionFileErrorState extends AppStates {
  final String error;

  AppEncryptionFileErrorState(this.error);
}

class AppDecryptionFileLoadingState extends AppStates {}

class AppDecryptionFileSuccessState extends AppStates {}

class AppDecryptionFileErrorState extends AppStates {
  final String error;

  AppDecryptionFileErrorState(this.error);
}
