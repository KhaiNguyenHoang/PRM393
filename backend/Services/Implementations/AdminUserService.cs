using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using Netmu.Data;
using Netmu.Dtos;
using Netmu.Exceptions;
using Netmu.Models;
using Netmu.Services.Contracts;

namespace Netmu.Services.Implementations;

public class AdminUserService(
    UserManager<ApplicationUser> userManager,
    AppDbContext context) : IAdminUserService
{
    public async Task<IEnumerable<UserAdminDto>> GetAllAsync()
    {
        var users = userManager.Users.ToList();
        var result = new List<UserAdminDto>();
        foreach (var user in users)
        {
            var roles = await userManager.GetRolesAsync(user);
            result.Add(new UserAdminDto
            {
                Id = user.Id,
                Username = user.UserName!,
                Email = user.Email!,
                Role = roles.FirstOrDefault() ?? "user",
                Status = user.Status,
            });
        }
        return result;
    }

    public async Task BanAsync(Guid id)
    {
        var user = await userManager.FindByIdAsync(id.ToString());
        if (user == null) throw new NotFoundException("User not found");
        user.Status = UserStatus.Banned;
        var res = await userManager.UpdateAsync(user);
        if (!res.Succeeded) throw new InternalServerErrorException("Failed to ban user");
    }

    public async Task UnbanAsync(Guid id)
    {
        var user = await userManager.FindByIdAsync(id.ToString());
        if (user == null) throw new NotFoundException("User not found");
        user.Status = UserStatus.Active;
        var res = await userManager.UpdateAsync(user);
        if (!res.Succeeded) throw new InternalServerErrorException("Failed to unban user");
    }

    public async Task<AnalyticsDto> GetAnalyticsAsync()
    {
        var totalUsers = await userManager.Users.CountAsync();
        var totalMovies = await context.Movies.CountAsync(m => !m.IsDeleted);
        var totalViews = await context.Histories.CountAsync(h => !h.IsDeleted);
        var bannedCount = await userManager.Users.CountAsync(u => u.Status == UserStatus.Banned);

        return new AnalyticsDto
        {
            TotalUsers = totalUsers,
            TotalMovies = totalMovies,
            TotalViews = totalViews,
            BannedCount = bannedCount,
        };
    }
}
