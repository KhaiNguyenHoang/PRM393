using Netmu.Models;
using X.PagedList;

namespace Netmu.Repositories.Contracts;

public interface IGenericRepository<T> where T : Base
{
    Task CreateAsync(T entity);
    Task<T?> GetByIdAsync(Guid id);
    Task<IPagedList<T>> GetPagedListAsync(int page, int size);
    void Update(T entity, bool isEntityTracked = true);
    void SoftDelete(T entity);
}