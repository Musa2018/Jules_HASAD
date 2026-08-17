using System;

namespace Hasad.Domain.Entities;

public class DocumentType
{
    public int Id { get; set; }
    public string NameAr { get; set; } = string.Empty;
    public string NameEn { get; set; } = string.Empty;
    public bool IsActive { get; set; } = true;
    public bool IsRequired { get; set; } // For future business rules
}
