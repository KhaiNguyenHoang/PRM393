using Microsoft.EntityFrameworkCore;
using Netmu.Dtos;
using Netmu.Exceptions;
using Netmu.Models;
using Netmu.Repositories.Contracts;
using Netmu.Services.Contracts;

namespace Netmu.Services.Implementations;

public class HistoryService(IUnitOfWork uow) : IHistoryService
{
    public async Task CreateAsync(Guid userId, CreateHistoryDto dto)
    {
        var movie = await uow.Repo<Movie>().GetByIdAsync(dto.MovieId);
        if (movie == null) throw new NotFoundException("Movie not found");

        var history = new History
        {
            UserId = userId,
            MovieId = dto.MovieId,
            ProgressInSeconds = dto.ProgressInSeconds,
            WatchedAt = DateTimeOffset.UtcNow,
        };
        await uow.Repo<History>().CreateAsync(history);
        await uow.SaveChangesAsync();
    }

    public async Task<IEnumerable<HistoryDto>> GetByUserAsync(Guid userId)
    {
        var histories = await uow.Repo<History>().GetPagedListAsync(1, int.MaxValue, x => x.UserId == userId);
        var result = new List<HistoryDto>();
        foreach (var h in histories)
        {
            var movie = await uow.Repo<Movie>().GetByIdAsync(h.MovieId);
            result.Add(new HistoryDto
            {
                Id = h.Id,
                MovieId = h.MovieId,
                MovieTitle = movie?.Title ?? string.Empty,
                MovieImageUrl = movie?.ImageUrl ?? string.Empty,
                WatchedAt = h.WatchedAt,
                ProgressInSeconds = h.ProgressInSeconds,
            });
        }
        return result.OrderByDescending(x => x.WatchedAt);
    }
}
