using Netmu.Models;

namespace Netmu.Repositories.Contracts;

public interface INotificationRepository : IGenericRepository<Notification>
{
    Task CreateBatchAsync(IEnumerable<Notification> notifications);
    Task<IEnumerable<Notification>> GetAllAsync(Guid receiverId);
}