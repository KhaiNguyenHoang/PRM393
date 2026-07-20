using Netmu.Models;
using X.PagedList;

namespace Netmu.Repositories.Contracts;

public interface IGenericRepository<T> where T : Base
{
    Task CreateAsync(T entity);
    Task<T?> GetByIdAsync(Guid id);
    Task<IPagedList<T>> GetPagedListAsync(int page, int size, System.Linq.Expressions.Expression<Func<T, bool>>? predicate = null);
    void Update(T entity, bool isEntityTracked = true);
    void SoftDelete(T entity);
    void HardDelete(T entity);
}