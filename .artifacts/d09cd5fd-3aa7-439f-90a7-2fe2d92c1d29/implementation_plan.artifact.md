# نظام التحقق من استمارات الضرر (مستوى المديرية)

تنفيذ نظام المراجعة والتحقق لاستمارات الضرر على مستوى المديرية، مع الالتزام بالصلاحيات والوركفلو المحدد.

## ملاحظات المستخدم
- تغيير نص "إرجاع للمسودة" ليصبح **"إرجاع إلى المهندس الزراعي في المديرية"**، للدلالة على أن الاستمارة ستعود لمرحلة التعديل من قبل المهندسين في المديرية.

## التغييرات المقترحة

### [Damage Report Module]

#### [MODIFY] [OfflineFirstDamageReportRepository](file:///C:/Users/musa_/StudioProjects/Jules_HASAD/hasad/mobile/lib/features/damage_reports/data/repositories/offline_first_damage_report_repository.dart)
- تحديث وظيفة `transitionReport` لإدراج سجل تاريخ (Workflow History) محلياً فور تنفيذ الحركة، لضمان ظهور الملاحظات والسجل للمستخدم فوراً حتى في وضع الأوفلاين.

#### [MODIFY] [DamageReportDetailsScreen](file:///C:/Users/musa_/StudioProjects/Jules_HASAD/hasad/mobile/lib/features/damage_reports/presentation/screens/damage_report_details_screen.dart)
- تحديث `_WorkflowActionBar` ليشمل الحالات التالية:
    - **المراجع الفني (TechnicalReviewer):**
        - اعتماد: نقل إلى "أرشفة المديرية" (`ArchiveDir`).
        - إرجاع: نقل إلى "مسودة" (`Draft`) مع التسمية: **"إرجاع إلى المهندس الزراعي في المديرية"**.
    - **موظف الأرشفة (ArchiveOfficer):**
        - اعتماد: نقل إلى "مدير المديرية" (`DirManager`).
        - إرجاع: نقل إلى "المراجعة الفنية" (`TechReview`).
    - **مدير المديرية (DirectorateManager):**
        - اعتماد: نقل إلى "مراجعة الوزارة" (`MinTechReview`).
        - إرجاع: نقل إلى "أرشفة المديرية" (`ArchiveDir`).
- جعل حقل "الملاحظات" إجبارياً عند اختيار أي عملية "إرجاع".

## خطة التحقق

### التحقق اليدوي
- تسجيل الدخول بالأدوار الثلاثة المختلفة.
- تجربة عملية الإرجاع والتأكد من ظهور نافذة التعليق.
- التأكد من أن نص الزر هو "إرجاع إلى المهندس الزراعي في المديرية" عند المراجعة الفنية.
- التأكد من تحديث سجل الحركات (History) أسفل الشاشة فوراً.
