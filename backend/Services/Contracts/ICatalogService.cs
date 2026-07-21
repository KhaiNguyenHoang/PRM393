using Netmu.Dtos;

namespace Netmu.Services.Contracts;

public interface IGenreService
{
    Task<Guid> CreateAsync(GenreDtoRequest request);
    Task<IEnumerable<GenreDto>> GetAllAsync();
    Task<GenreDto> GetByIdAsync(Guid id);
    Task<GenreDto> UpdateAsync(Guid id, GenreDtoRequest request);
    Task DeleteAsync(Guid id);
}

public interface IDirectorService
{
    Task<Guid> CreateAsync(DirectorDtoRequest request);
    Task<IEnumerable<DirectorDto>> GetAllAsync();
    Task<DirectorDto> GetByIdAsync(Guid id);
    Task<DirectorDto> UpdateAsync(Guid id, DirectorDtoRequest request);
    Task DeleteAsync(Guid id);
}

public interface IActorService
{
    Task<Guid> CreateAsync(ActorDtoRequest request);
    Task<IEnumerable<ActorDto>> GetAllAsync();
    Task<ActorDto> GetByIdAsync(Guid id);
    Task<ActorDto> UpdateAsync(Guid id, ActorDtoRequest request);
    Task DeleteAsync(Guid id);
}

public interface IHistoryService
{
    Task CreateAsync(Guid userId, CreateHistoryDto dto);
    Task<IEnumerable<HistoryDto>> GetByUserAsync(Guid userId);
}

public interface IAdminUserService
{
    Task<IEnumerable<UserAdminDto>> GetAllAsync();
    Task BanAsync(Guid id);
    Task UnbanAsync(Guid id);
    Task<AnalyticsDto> GetAnalyticsAsync();
}
