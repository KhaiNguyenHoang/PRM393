using Netmu.Data;
using Netmu.Models;
using Netmu.Repositories.Contracts;

namespace Netmu.Repositories.Implementations;

public class UnitOfWork(AppDbContext context) : IUnitOfWork
{
    private readonly Dictionary<string, object> _repos = [];

    public void Dispose()
    {
        context.Dispose();
        GC.SuppressFinalize(this);
    }

    public IGenericRepository<T> Repo<T>() where T : Base
    {
        var type = typeof(T).Name;

        // Get cached repository
        if (_repos.TryGetValue(type, out var cachedRepo)) return (IGenericRepository<T>)cachedRepo;

        if (typeof(T).IsAssignableTo(typeof(Notification)))
        {
            var notiRepo = new NotificationRepository(context);
            _repos[type] = notiRepo;
            return (IGenericRepository<T>)notiRepo;
        }

        // If the model use GenericRepo
        var repo = new GenericRepository<T>(context);
        _repos.Add(type, repo);
        return repo;
    }

    public async Task<int> SaveChangesAsync(CancellationToken cancellationToken = default)
    {
        return await context.SaveChangesAsync(cancellationToken);
    }
}