using Microsoft.EntityFrameworkCore;
using Netmu.Data;
using Netmu.Models;
using Netmu.Repositories.Contracts;
using X.PagedList;

namespace Netmu.Repositories.Implementations;

public class NotificationRepository(AppDbContext context) : INotificationRepository
{
    public async Task CreateBatchAsync(IEnumerable<Notification> notifications)
    {
        await context.Notifications.AddRangeAsync(notifications);
    }

    public async Task<IEnumerable<Notification>> GetAllAsync(Guid receiverId)
    {
        var notifications = await context.Notifications
            .Where(n => n.ReceiverId == receiverId)
            .OrderByDescending(n => n.CreatedAt)
            .Take(20)
            .ToListAsync();
        return notifications;
    }

    public Task CreateAsync(Notification entity)
    {
        throw new NotImplementedException();
    }

    public Task<Notification?> GetByIdAsync(Guid id)
    {
        throw new NotImplementedException();
    }

    public Task<IPagedList<Notification>> GetPagedListAsync(int page, int size)
    {
        throw new NotImplementedException();
    }

    public void Update(Notification entity, bool isEntityTracked = true)
    {
        throw new NotImplementedException();
    }

    public void SoftDelete(Notification entity)
    {
        throw new NotImplementedException();
    }
}