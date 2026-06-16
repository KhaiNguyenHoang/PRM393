using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;
using Microsoft.IdentityModel.Tokens;

namespace Netmu.Utils.Security;

public class JwtParams
{
    public string Identifier { get; set; } = "";
    public string Name { get; set; } = "";
    public IEnumerable<string> Roles { get; set; } = [];
    public string Issuer { get; set; } = "Netmu";
    public string Audience { get; set; } = "Netmu-Mobile";
    public int ExpiresInMinutes { get; set; } = 60;
}

public static class Token
{
    public static string GenerateJwtToken(JwtParams param, string secret)
    {
        var claims = new List<Claim>
        {
            new(ClaimTypes.NameIdentifier, param.Identifier),
            new(ClaimTypes.Name, param.Name),
        };

        claims.AddRange(param.Roles.Select(role => new Claim(ClaimTypes.Role, role)));

        var key = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(secret));
        var credentials = new SigningCredentials(key, SecurityAlgorithms.HmacSha256);
        var expired = DateTime.UtcNow.AddMinutes(param.ExpiresInMinutes);

        var token = new JwtSecurityToken(
            issuer: param.Issuer,
            audience: param.Audience,
            claims: claims,
            expires: expired,
            signingCredentials: credentials
        );
        return new JwtSecurityTokenHandler().WriteToken(token);
    }
}

