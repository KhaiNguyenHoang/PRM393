using Netmu.Dtos;

namespace Netmu.Services.Contracts;

public interface IUserService
{
    Task RegisterAsync(RegisterDto dto);
    Task<LoginDtoResponse> LoginAsync(LoginDtoRequest dto);
    Task ChangePasswordAsync(Guid id, string oldPassword, string newPassword);
    Task<UserProfileDto> GetProfileAsync(Guid id);
    Task UpdateProfileAsync(Guid id, UpdateProfileDto dto);
}