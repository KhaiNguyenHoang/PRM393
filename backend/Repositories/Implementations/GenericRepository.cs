using Microsoft.EntityFrameworkCore;
using Netmu.Data;
using Netmu.Models;
using Netmu.Repositories.Contracts;
using X.PagedList;
using X.PagedList.EF;

namespace Netmu.Repositories.Implementations;

public class GenericRepository<T>(AppDbContext context) : IGenericRepository<T> where T : Base
{
    public async Task CreateAsync(T entity)
    {
        await context.Set<T>().AddAsync(entity);
    }

    public async Task<T?> GetByIdAsync(Guid id)
    {
        return await context.Set<T>().FirstOrDefaultAsync(x => x.Id == id && !x.IsDeleted);
    }

    public async Task<IPagedList<T>> GetPagedListAsync(int page, int size)
    {
        return await context.Set<T>()
        .Where(x => !x.IsDeleted)
        .OrderByDescending(x => x.UpdatedAt)
        .ToPagedListAsync(page, size);
    }

    public void Update(T entity, bool isEntityTracked = true)
    {
        entity.UpdatedAt = DateTimeOffset.UtcNow;
        if (!isEntityTracked)
        {
            context.Set<T>().Update(entity);
        }
    }

    public void SoftDelete(T entity)
    {
        entity.IsDeleted = true;
        entity.UpdatedAt = DateTimeOffset.UtcNow;
        context.Set<T>().Update(entity);
    }
}