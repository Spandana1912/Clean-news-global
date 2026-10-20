import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/article.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createUserProfile({
    required String uid,
    required String username,
    required String email,
  }) async {
    await _firestore.collection('users').doc(uid).set({
      'username': username.trim(),
      'username_lowercase': username.trim().toLowerCase(),
      'email': email.trim(),
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getUserProfile(
    String uid,
  ) async {
    return await _firestore.collection('users').doc(uid).get();
  }

  Future<String?> getEmailByUsername(String username) async {
    final cleanUsername = username.trim();
    final lowerUsername = cleanUsername.toLowerCase();

    try {
      // 1. Search by username_lowercase
      var querySnapshot = await _firestore
          .collection('users')
          .where('username_lowercase', isEqualTo: lowerUsername)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs.first.data()['email'] as String?;
      }

      // 2. Search by exact username
      querySnapshot = await _firestore
          .collection('users')
          .where('username', isEqualTo: cleanUsername)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs.first.data()['email'] as String?;
      }

      // 3. Search by email as fallback
      querySnapshot = await _firestore
          .collection('users')
          .where('email', isEqualTo: cleanUsername)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs.first.data()['email'] as String?;
      }
    } catch (e) {
      debugPrint('Firestore query error: $e');
    }

    return null;
  }

  // ------------------------------------------------------------
  // SAVED ARTICLES  (users/{uid}/savedArticles/{sha1(articleUrl)})
  // ------------------------------------------------------------

  CollectionReference<Map<String, dynamic>> _savedRef(String uid) {
    return _firestore.collection('users').doc(uid).collection('savedArticles');
  }

  /// Stable document id for an article, so saving the same article twice
  /// never creates a duplicate.
  static String savedDocId(String articleUrl) {
    return sha1.convert(utf8.encode(articleUrl.trim())).toString();
  }

  Future<void> saveArticle(String uid, Article article) async {
    await _savedRef(uid).doc(savedDocId(article.articleUrl)).set({
      ...article.toMap(),
      'savedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> removeSavedArticle(String uid, String articleUrl) async {
    await _savedRef(uid).doc(savedDocId(articleUrl)).delete();
  }

  /// Live list of the user's saved articles, newest first.
  Stream<List<Article>> savedArticlesStream(String uid) {
    return _savedRef(uid)
        .orderBy('savedAt', descending: true)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => Article.fromMap(doc.data())).toList(),
        );
  }
}