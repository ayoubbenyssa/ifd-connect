
class Validators{
  Validators({this.context});
  var context;


  String validatedesc(String value) {
    if (value.length > 0) {
      return null;
    }
    return "S'il vous plait entrez la description";
  }


  String validateid(String value) {
    if (value.isEmpty) return "S'il vous plaît, entrez l'identifiant";
    /*final RegExp nameExp = new RegExp(r'^[A-Za-z ]+$');
    if (!nameExp.hasMatch(value))
      return LoDocText.of(context).alpha_n();*/
    return null;
  }

  String validateid_codeVerification(String value) {
    if (value.isEmpty) return "S'il vous plaît, entrez code de verification";
    /*final RegExp nameExp = new RegExp(r'^[A-Za-z ]+$');
    if (!nameExp.hasMatch(value))
      return LoDocText.of(context).alpha_n();*/
    return null;
  }

  String validateid_password(String value) {
    if (value.isEmpty) return "S'il vous plaît, entrez votre nouveau mot de pass";
    /*final RegExp nameExp = new RegExp(r'^[A-Za-z ]+$');
    if (!nameExp.hasMatch(value))
      return LoDocText.of(context).alpha_n();*/
    return null;
  }


  String validateEmail(String value) {
    if (value.isEmpty) {
      // The form is empty
      return "Entrez votre email s'il vous plait";
    }
    // This is just a regular expression for email addresses
    String p = "[a-zA-Z0-9\+\.\_\%\-\+]{1,256}" +
        "\\@" +
        "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,64}" +
        "(" +
        "\\." +
        "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,25}" +
        ")+";
    RegExp regExp = new RegExp(p);

    if (regExp.hasMatch(value)) {
      // So, the email is valid
      return null;
    }
    return "L'email n'est pas valide";
  }


  String validatePassword(String value) {
    if (value.length > 2) {
      return null;
    }
    return "Le mot de passe doit être jusqu'à 6 caractères ";
  }

  String validatename(String value) {
    if (value.isEmpty) return "S'il vous plaît, entrez votre nom";
    /*final RegExp nameExp = new RegExp(r'^[A-Za-z ]+$');
    if (!nameExp.hasMatch(value))
      return LoDocText.of(context).alpha_n();*/
    return null;
  }


  String valprofile(String value) {
    if (value.length <=0) return "S'il vous plaît, entrez le titre de votre profile";
    /*final RegExp nameExp = new RegExp(r'^[A-Za-z ]+$');
    if (!nameExp.hasMatch(value))
      return LoDocText.of(context).alpha_n();*/
    return null;
  }



  String valorganisme(String value) {
    //if (value.length <=0) return "S'il vous plaît, entrez l'organisme actuel";
    /*final RegExp nameExp = new RegExp(r'^[A-Za-z ]+$');
    if (!nameExp.hasMatch(value))
      return LoDocText.of(context).alpha_n();*/
    return null;
  }


  String titrre(String value) {
    if (value.length <=0) return "S'il vous plaît, entrez le titre";
    /*final RegExp nameExp = new RegExp(r'^[A-Za-z ]+$');
    if (!nameExp.hasMatch(value))
      return LoDocText.of(context).alpha_n();*/
    return null;
  }


  String descc(String value) {
    if (value.length <=0) return "S'il vous plaît, entrez une description";
    /*final RegExp nameExp = new RegExp(r'^[A-Za-z ]+$');
    if (!nameExp.hasMatch(value))
      return LoDocText.of(context).alpha_n();*/
    return null;
  }

  String addre(String value) {
    if (value.length <=0) return "S'il vous plaît, entrez l'adresse";
    /*final RegExp nameExp = new RegExp(r'^[A-Za-z ]+$');
    if (!nameExp.hasMatch(value))
      return LoDocText.of(context).alpha_n();*/
    return null;
  }

  String validatephonenumber(String value) {
    if (value.length > 0) {
      return null;
    }
    return "Numéro de téléphonne";
  }


  String validatetitre(String value) {
    if (value.length > 0) {
      return null;
    }
    return "S'il vous plait entrer votre organisme";
  }

  String validateorganisme(String value) {
    if (value.length > 0) {
      return null;
    }
    return "S'il vous plait entrer votre organisme";
  }


  String validateAddress(String value) {
    if (value.length > 0) {
      return null;
    }
    return "S'il vous plait entrez l'adresse";
  }




}