class Etudiant {
  final String type_concours;
  final String religion;
  final String annee_bac;
  final String last_name;
  final String sanitaire_scan_content_type;
  final String rib;
  final String recu_scan_file_name;
  final String prob_sante;
  final String cin_scan_content_type;
  final int photo_file_size;
  final bool contractuel;
  final bool is_active;
  final String photo_content_type;
  final String created_at;
  final String first_name;
  final String address_line2;
  final String city;
  final String mention_bac;
  final String date_of_birth;
  final String sanitaire_extrait_content_type;
  final String cin;
  final String matricule;
  final String type_bac;
  final String status_description;
  final String recu_scan_content_type;
  final String gender;
  final String group_td;
  final String num_baccalaureat;
  final String bourse_org;
  final String middle_name;
  final String agence;
  final int school_year;
  final String group_lang;
  final String num_bourse_contrat;
  final String medical_scan_file_name;
  final String student_category_id;
  final String phone2;
  final String pin_code;
  final String engagement_scan_file_name;
  final String prenom_ar;
  final String sanitaire_extrait_file_name;
  final String medical_scan_content_type;
  final String cin_scan_file_name;
  final String engagement_scan_content_type;
  final bool bourse;
  final String photo_data;
  final String address_line1;
  final String picture;
  final String email;
  final String lieu_naissance_ar;
  final String blood_group;
  final String type_ens;
  final String section;
  final bool is_sms_enabled;
  final String language;
  final String bac_scan_file_name;
  final String cin_lieu;
  final String school_field;
  final bool has_paid_fees;
  final bool is_deleted;
  final String bac_scan_content_type;
  final String admission_no;
  final int nbre_freres;
  final String ordre;
  final String updated_at;
  final String state;
  final String rang_concours;
  final String birth_place;
  final int id;
  final String phone1;
  final String nom_ar;
  final int batch_id;
  final String ville_bac;
  final int user_id;
  final int class_roll_no;
  final int country_id;
  final int immediate_contact_id;
  final String adr_agence;
  final int nationality_id;
  final String pays_bac;
  final String sanitaire_scan_file_name;
  final String filiere;
  final String admission_date;
  final String cin_debut;
  final String lycee;
  final String contrat_org;
  final String photo_file_name;

  Etudiant(
      {this.type_concours,
      this.religion,
      this.annee_bac,
      this.last_name,
      this.sanitaire_scan_content_type,
      this.rib,
      this.recu_scan_file_name,
      this.prob_sante,
      this.cin_scan_content_type,
      this.photo_file_size,
      this.contractuel,
      this.is_active,
      this.photo_content_type,
      this.created_at,
      this.first_name,
      this.address_line2,
      this.city,
      this.mention_bac,
      this.date_of_birth,
      this.sanitaire_extrait_content_type,
      this.cin,
      this.matricule,
      this.type_bac,
      this.status_description,
      this.recu_scan_content_type,
      this.gender,
      this.group_td,
      this.num_baccalaureat,
      this.bourse_org,
      this.middle_name,
      this.agence,
      this.school_year,
      this.group_lang,
      this.num_bourse_contrat,
      this.medical_scan_file_name,
      this.student_category_id,
      this.phone2,
      this.pin_code,
      this.engagement_scan_file_name,
      this.prenom_ar,
      this.sanitaire_extrait_file_name,
      this.medical_scan_content_type,
      this.cin_scan_file_name,
      this.engagement_scan_content_type,
      this.bourse,
      this.photo_data,
      this.address_line1,
      this.picture,
      this.email,
      this.lieu_naissance_ar,
      this.blood_group,
      this.type_ens,
      this.section,
      this.is_sms_enabled,
      this.language,
      this.bac_scan_file_name,
      this.cin_lieu,
      this.school_field,
      this.has_paid_fees,
      this.is_deleted,
      this.bac_scan_content_type,
      this.admission_no,
      this.nbre_freres,
      this.ordre,
      this.updated_at,
      this.state,
      this.rang_concours,
      this.birth_place,
      this.id,
      this.phone1,
      this.nom_ar,
      this.batch_id,
      this.ville_bac,
      this.user_id,
      this.class_roll_no,
      this.country_id,
      this.immediate_contact_id,
      this.adr_agence,
      this.nationality_id,
      this.pays_bac,
      this.sanitaire_scan_file_name,
      this.filiere,
      this.admission_date,
      this.cin_debut,
      this.lycee,
      this.contrat_org,
      this.photo_file_name});

  factory Etudiant.fromJson(Map<String, dynamic> parsedJson) {
    return Etudiant(
        type_concours: parsedJson["type_concours"].toString(),
        religion: parsedJson["religion"].toString(),
        annee_bac: parsedJson["annee_bac"].toString(),
        last_name: parsedJson["last_name"].toString(),
        sanitaire_scan_content_type: parsedJson["sanitaire_scan_content_type"].toString(),
        rib: parsedJson["rib"].toString(),
        recu_scan_file_name: parsedJson["recu_scan_file_name"].toString(),
        prob_sante: parsedJson["prob_sante"].toString(),
        cin_scan_content_type: parsedJson["cin_scan_content_type"].toString(),
        photo_file_size: parsedJson["photo_file_size"],
        contractuel: parsedJson["contractuel"],
        is_active: parsedJson["is_active"],
        photo_content_type: parsedJson["photo_content_type"].toString(),
        created_at: parsedJson["created_at"].toString(),
        first_name: parsedJson["first_name"].toString(),
        address_line2: parsedJson["address_line2"].toString(),
        city: parsedJson["city"].toString(),
        mention_bac: parsedJson["mention_bac"].toString(),
        date_of_birth: parsedJson["date_of_birth"].toString(),
        sanitaire_extrait_content_type:
            parsedJson["sanitaire_extrait_content_type"].toString(),
        cin: parsedJson["cin"].toString(),
        matricule: parsedJson["matricule"].toString(),
        type_bac: parsedJson["type_bac"].toString(),
        status_description: parsedJson["status_description"].toString(),
        recu_scan_content_type: parsedJson["recu_scan_content_type"].toString(),
        gender: parsedJson["gender"].toString(),
        group_td: parsedJson["group_td"].toString(),
        num_baccalaureat: parsedJson["num_baccalaureat"].toString(),
        bourse_org: parsedJson["bourse_org"].toString(),
        middle_name: parsedJson["middle_name"].toString(),
        agence: parsedJson["agence"].toString(),
        school_year: parsedJson["school_year"],
        group_lang: parsedJson["group_lang"].toString(),
        num_bourse_contrat: parsedJson["num_bourse_contrat"].toString(),
        medical_scan_file_name: parsedJson["medical_scan_file_name"].toString(),
        student_category_id: parsedJson["student_category_id"].toString(),
        phone2: parsedJson["phone2"].toString(),
        pin_code: parsedJson["pin_code"].toString(),
        engagement_scan_file_name: parsedJson["engagement_scan_file_name"].toString(),
        prenom_ar: parsedJson["prenom_ar"].toString(),
        sanitaire_extrait_file_name: parsedJson["sanitaire_extrait_file_name"].toString(),
        medical_scan_content_type: parsedJson["medical_scan_content_type"].toString(),
        cin_scan_file_name: parsedJson["cin_scan_file_name"].toString(),
        engagement_scan_content_type:
            parsedJson["engagement_scan_content_type"].toString(),
        bourse: parsedJson["bourse"],
        photo_data: parsedJson["photo_data"].toString(),
        address_line1: parsedJson["address_line1"].toString(),
        picture: parsedJson["picture"].toString(),
        email: parsedJson["email"].toString(),
        lieu_naissance_ar: parsedJson["lieu_naissance_ar"].toString(),
        blood_group: parsedJson["blood_group"].toString(),
        type_ens: parsedJson["type_ens"].toString(),
        section: parsedJson["section"].toString(),
        is_sms_enabled: parsedJson["is_sms_enabled"],
        language: parsedJson["language"].toString(),
        bac_scan_file_name: parsedJson["bac_scan_file_name"].toString(),
        cin_lieu: parsedJson["cin_lieu"].toString(),
        school_field: parsedJson["school_field"].toString(),
        has_paid_fees: parsedJson["has_paid_fees"],
        is_deleted: parsedJson["is_deleted"],
        bac_scan_content_type: parsedJson["bac_scan_content_type"].toString(),
        admission_no: parsedJson["admission_no"].toString(),
        nbre_freres: parsedJson["nbre_freres"],
        ordre: parsedJson["ordre"].toString(),
        updated_at: parsedJson["updated_at"].toString(),
        state: parsedJson["state"].toString(),
        rang_concours: parsedJson["rang_concours"].toString(),
        birth_place: parsedJson["birth_place"].toString(),
        id: parsedJson["id"],
        phone1: parsedJson["phone1"].toString(),
        nom_ar: parsedJson["nom_ar"].toString(),
        batch_id: parsedJson["batch_id"],
        ville_bac: parsedJson["ville_bac"].toString(),
        user_id: parsedJson["user_id"],
        class_roll_no: parsedJson["class_roll_no"],
        country_id: parsedJson["country_id"],
        immediate_contact_id: parsedJson["immediate_contact_id"],
        adr_agence: parsedJson["adr_agence"].toString(),
        nationality_id: parsedJson["nationality_id"],
        pays_bac: parsedJson["pays_bac"].toString(),
        sanitaire_scan_file_name: parsedJson["sanitaire_scan_file_name"].toString(),
        filiere: parsedJson["filiere"].toString(),
        admission_date: parsedJson["admission_date"].toString(),
        cin_debut: parsedJson["cin_debut"].toString(),
        lycee: parsedJson["lycee"].toString(),
        contrat_org: parsedJson["contrat_org"].toString(),
        photo_file_name: parsedJson["photo_file_name"]);
  }
}
