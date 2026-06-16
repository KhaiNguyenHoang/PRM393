using Netmu.Models;

namespace Netmu.Repositories.Contracts;

public interface IUnitOfWork : IDisposable
{
    IGenericRepository<T> Repo<T>() where T : Base;
    Task<int> SaveChangesAsync(CancellationToken cancellationToken = default);
}