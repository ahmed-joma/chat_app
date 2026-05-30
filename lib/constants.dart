import 'package:flutter/material.dart';

/// لون الهوية الأساسي للتطبيق.
const kPrimaryColor = Color(0xff2B475E);

/// اسم مجموعة الرسائل في Firestore.
const kMessagesCollection = 'messages';

/// مفاتيح حقول مستند الرسالة في Firestore.
const kMessageField = 'message';
const kCreatedAtField = 'createdAt';

/// تاريخياً يُخزَّن بريد المرسِل في حقل اسمه 'id'؛ نُبقي القيمة كما هي
/// للتوافق مع البيانات الموجودة مسبقاً.
const kSenderField = 'id';
