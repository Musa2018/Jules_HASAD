# خطة تنفيذ نظام الإشعارات المتكامل (داخلي + خارجي)

يهدف هذا التطوير إلى إضافة نظام تنبيهات يسمح بإرسال إشعارات للمستخدمين عند حدوث تغييرات في حالة المعاملات (Damage Reports)، بحيث تظهر داخل التطبيق (In-App) وكإشعارات دفع (Push Notifications) على الجهاز.

## مراجعة المستخدم مطلوبة

> [!IMPORTANT]
> يتطلب تفعيل إشعارات الدفع (Push Notifications) وجود حساب **Firebase Console** وربط التطبيق به، وتوفير ملف `google-services.json` للأندرويد.

## التغييرات المقترحة

### 1. السيرفر (Backend)

#### [MODIFY] [ApplicationUser.cs](hasad/backend/Hasad.Domain/Identity/ApplicationUser.cs)
- إضافة حقل `FcmToken` (string) لتخزين رمز جهاز المستخدم.

#### [NEW] `Notification.cs` (Domain)
- تعريف كيان التنبيه: `Id`, `UserId`, `Title`, `Message`, `CreatedAt`, `IsRead`, `Data` (JSON لتخزين معلومات الانتقال مثل ReportId).

#### [MODIFY] `IApplicationDbContext.cs` & `ApplicationDbContext.cs`
- إضافة جدول `Notifications` لقاعدة البيانات.

#### [NEW] `AddNotificationCommand` & `GetNotificationsQuery` (Application)
- عمليات إضافة وجلب التنبيهات مع دعم الترقيم (Pagination).

#### [MODIFY] [NotificationService.cs](hasad/backend/Hasad.Infrastructure/Services/NotificationService.cs)
- تحديث الخدمة لتقوم بـ:
  1. حفظ التنبيه في الجدول الجديد.
  2. إرسال إشعار عبر Firebase FCM (سيتم إضافة `FirebaseAdmin` SDK).

#### [NEW] `NotificationsController.cs` (API)
- نقاط نهاية (Endpoints) لجلب التنبيهات وتحديدها كـ "مقروءة".

---

### 2. التطبيق (Mobile)

#### [MODIFY] `pubspec.yaml`
- إضافة `firebase_core`, `firebase_messaging`, `flutter_local_notifications`.

#### [NEW] `NotificationModel` & `NotificationRepository`
- التعامل مع بيانات التنبيهات من السيرفر.

#### [NEW] `FcmService`
- تهيئة Firebase، طلب الصلاحيات من المستخدم، واستلام الرسائل في المقدمة (Foreground) والخلفية (Background).

#### [MODIFY] `AuthRepository`
- تحديث كود تسجيل الدخول ليرسل `FcmToken` للسيرفر فور الحصول عليه.

#### [MODIFY] `MainScreen` / `Home`
- إضافة أيقونة "الجرس" مع عداد للتنبيهات غير المقروءة.
- إضافة شاشة لعرض قائمة التنبيهات.

## خطة التحقق

### اختبارات آلية
- إضافة اختبارات وحدة في السيرفر لضمان حفظ التنبيهات بشكل صحيح.
- اختبار الـ API الخاص بجلب التنبيهات.

### التحقق اليدوي
1. تسجيل الدخول من جهازين مختلفين.
2. القيام بحركة على تقرير ضرر من الجهاز الأول (مثلاً تحويل للمراجعة).
3. التأكد من وصول إشعار فوراً للجهاز الثاني (المراجع).
4. التأكد من ظهور التنبيه في قائمة التنبيهات داخل التطبيق.
