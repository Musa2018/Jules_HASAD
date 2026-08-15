# إضافة حقل إجمالي الضرر (TotalDamage) لتقارير الضرر

تتضمن هذه الخطة إضافة حقل `TotalDamage` إلى جدول `DamageReports` في قاعدة البيانات (SQL Server)، وتحديث منطق العمل في الخلفية (Backend) لحساب هذا الإجمالي بناءً على بنود التقرير، وتحديث تطبيق الموبايل لعرض هذا الحقل مع رمز اليورو بجانب القيمة.

## User Review Required

> [!IMPORTANT]
> سيتم حساب إجمالي الضرر تلقائياً في السيرفر عند إنشاء أو تحديث أي بند في التقرير لضمان دقة البيانات وتجنب مشاكل المزامنة. الحقل سيكون للقراءة فقط في واجهة المستخدم.

## Proposed Changes

### [Component] Backend (ASP.NET Core & SQL Server)

تحديث قاعدة البيانات ومنطق العمل لحساب إجمالي الضرر.

#### [MODIFY] [DamageReport.cs](file:///C:/Users/musa_/AndroidStudioProjects/Jules_HASAD/hasad/backend/Hasad.Domain/Entities/DamageReport.cs)
- إضافة حقل `public decimal TotalDamage { get; set; }`.

#### [MODIFY] [DamageReportDto.cs](file:///C:/Users/musa_/AndroidStudioProjects/Jules_HASAD/hasad/backend/Hasad.Application/Features/DamageReports/Models/DamageReportDto.cs)
- إضافة حقل `public decimal TotalDamage { get; set; }`.

#### [MODIFY] [ApplicationDbContext.cs](file:///C:/Users/musa_/AndroidStudioProjects/Jules_HASAD/hasad/backend/Hasad.Infrastructure/Persistence/ApplicationDbContext.cs)
- تهيئة الحقل `TotalDamage` بدقة (18, 2).

#### [MODIFY] [CreateDamageReportCommandHandler.cs](file:///C:/Users/musa_/AndroidStudioProjects/Jules_HASAD/hasad/backend/Hasad.Application/Features/DamageReports/Commands/CreateDamageReport/CreateDamageReportCommand.cs)
- حساب `TotalDamage = items.Sum(i => i.EstimatedLoss)` عند إنشاء التقرير.

#### [MODIFY] [AddDamageItemCommandHandler.cs](file:///C:/Users/musa_/AndroidStudioProjects/Jules_HASAD/hasad/backend/Hasad.Application/Features/DamageReports/Commands/AddDamageItem/AddDamageItemCommand.cs)
- إعادة حساب `TotalDamage` للتقرير المرتبط بعد إضافة بند جديد.

#### [MODIFY] [UpdateDamageItemCommandHandler.cs](file:///C:/Users/musa_/AndroidStudioProjects/Jules_HASAD/hasad/backend/Hasad.Application/Features/DamageReports/Commands/UpdateDamageItem/UpdateDamageItemCommand.cs)
- إعادة حساب `TotalDamage` للتقرير المرتبط بعد تحديث بند.

#### [MODIFY] [DeleteDamageItemCommandHandler.cs](file:///C:/Users/musa_/AndroidStudioProjects/Jules_HASAD/hasad/backend/Hasad.Application/Features/DamageReports/Commands/DeleteDamageItem/DeleteDamageItemCommand.cs)
- إعادة حساب `TotalDamage` للتقرير المرتبط بعد حذف بند.

---

### [Component] Mobile Application (Flutter & Drift)

تحديث قاعدة البيانات المحلية وواجهة المستخدم.

#### [MODIFY] [database.dart](file:///C:/Users/musa_/AndroidStudioProjects/Jules_HASAD/hasad/mobile/lib/core/storage/database.dart)
- إضافة `RealColumn get totalDamage => real().withDefault(const Constant(0.0))();` إلى جدول `DamageReports`.
- تحديث `schemaVersion` إلى 33.
- إضافة منطق الهجرة (Migration) لإضافة العمود الجديد.

#### [MODIFY] [damage_report.dart](file:///C:/Users/musa_/AndroidStudioProjects/Jules_HASAD/hasad/mobile/lib/features/damage_reports/domain/models/damage_report.dart)
- إضافة `@Default(0.0) double totalDamage` إلى نموذج `DamageReport`.

#### [MODIFY] [damage_report_sync_dto.dart](file:///C:/Users/musa_/AndroidStudioProjects/Jules_HASAD/hasad/mobile/lib/features/damage_reports/data/dto/damage_report_sync_dto.dart)
- تحديث الـ DTO ليشمل `totalDamage` عند المزامنة من السيرفر.

#### [MODIFY] [damage_report_details_screen.dart](file:///C:/Users/musa_/AndroidStudioProjects/Jules_HASAD/hasad/mobile/lib/features/damage_reports/presentation/screens/damage_report_details_screen.dart)
- عرض "إجمالي الضرر" في قسم التفاصيل مع رمز اليورو (€).

## Verification Plan

### Automated Tests
- اختبار الـ Backend: التأكد من أن `TotalDamage` يتم تحديثه بشكل صحيح عند إضافة/حذف بنود.
- اختبار الـ Mobile: التأكد من أن عملية الهجرة (Migration) لقاعدة البيانات تتم بنجاح.

### Manual Verification
- إنشاء تقرير ضرر جديد وإضافة عدة بنود، والتحقق من ظهور الإجمالي الصحيح في الموبايل.
- التأكد من ظهور رمز اليورو بجانب القيمة.
