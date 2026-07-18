namespace Hasad.Application.Features.Farmers.Models;

public class FarmerDto
{
    public Guid Id { get; set; }
    public Guid ClientId { get; set; }

    // الحقول المدمجة
    public string Name { get; set; } = string.Empty;
    public string NameEn { get; set; } = string.Empty;

    // الحقول الأساسية
    public string NationalId { get; set; } = string.Empty;
    public string PhoneNumber { get; set; } = string.Empty;
    public string Address { get; set; } = string.Empty;
    public string RowVersion { get; set; } = string.Empty;

    // ====== الحقول المضافة حديثاً ======
    public int IdTypeId { get; set; }
    public string GovernorateId { get; set; } = string.Empty;
    public string LocalityId { get; set; } = string.Empty;
    public DateOnly BirthDate { get; set; }

    // الأسماء المفصلة (عربي)
    public string FirstNameAr { get; set; } = string.Empty;
    public string FatherNameAr { get; set; } = string.Empty;
    public string GrandfatherNameAr { get; set; } = string.Empty;
    public string FamilyNameAr { get; set; } = string.Empty;

    // الأسماء المفصلة (إنجليزي)
    public string FirstNameEn { get; set; } = string.Empty;
    public string FatherNameEn { get; set; } = string.Empty;
    public string GrandfatherNameEn { get; set; } = string.Empty;
    public string FamilyNameEn { get; set; } = string.Empty;
}