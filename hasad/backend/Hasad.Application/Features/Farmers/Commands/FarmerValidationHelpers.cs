using System;

namespace Hasad.Application.Features.Farmers.Commands;

public static class FarmerValidationHelpers
{
    public static bool ValidatePalestinianId(string idNumber)
    {
        if (string.IsNullOrWhiteSpace(idNumber))
            return false;

        idNumber = idNumber.Trim();
        if (idNumber.Length != 9)
            return false;

        if (!long.TryParse(idNumber, out _))
            return false;

        var digits = idNumber.ToCharArray();
        int formula = 0;

        for (int i = 0; i <= digits.Length - 2; i++)
        {
            int digit = int.Parse(digits[i].ToString());

            if (i % 2 == 0)
            {
                formula += digit * 1;
            }
            else
            {
                int temp = digit * 2;

                if (temp >= 10)
                    temp -= 9;

                formula += temp;
            }
        }

        formula += int.Parse(digits[8].ToString());

        return formula % 10 == 0;
    }

    public static bool IsNumeric(string value)
    {
        return !string.IsNullOrWhiteSpace(value) && long.TryParse(value, out _);
    }

    public static bool IsAlphanumeric(string value)
    {
        if (string.IsNullOrWhiteSpace(value)) return false;
        foreach (char c in value)
        {
            if (!char.IsLetterOrDigit(c))
                return false;
        }
        return true;
    }

    public static bool IsAtLeast18(DateOnly birthDate)
    {
        var today = DateOnly.FromDateTime(DateTime.UtcNow);
        int age = today.Year - birthDate.Year;

        if (birthDate > today.AddYears(-age)) age--;

        return age >= 18;
    }
}
