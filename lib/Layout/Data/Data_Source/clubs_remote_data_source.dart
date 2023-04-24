import 'package:bader_user_app/Layout/Domain/Entities/club_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../Core/Constants/constants.dart';
import '../Models/club_model.dart';

class ClubsRemoteDataSource{
  // TODO: Include everything related to Clubs

  // TODO: Get Clubs from Firestore
  Future<List<ClubEntity>> getAllClubs() async {
    List<ClubEntity> clubs = [];
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection(Constants.kClubsCollectionName).get();
    for( var item in querySnapshot.docs )
    {
      clubs.add(ClubModel.fromJson(json: item.data()));
    }
    return clubs;
  }

}