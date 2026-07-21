using Netmu.Dtos;
using Netmu.Exceptions;
using Netmu.Models;
using Netmu.Repositories.Contracts;
using Netmu.Services.Contracts;

namespace Netmu.Services.Implementations;

public class GenreService(IUnitOfWork uow) : IGenreService
{
    public async Task<Guid> CreateAsync(GenreDtoRequest request)
    {
        var genre = new Genre { Name = request.Name };
        await uow.Repo<Genre>().CreateAsync(genre);
        await uow.SaveChangesAsync();
        return genre.Id;
    }

    public async Task<IEnumerable<GenreDto>> GetAllAsync()
    {
        var genres = await uow.Repo<Genre>().GetPagedListAsync(1, int.MaxValue);
        return genres.Select(x => new GenreDto { Id = x.Id, Name = x.Name });
    }

    public async Task<GenreDto> GetByIdAsync(Guid id)
    {
        var genre = await uow.Repo<Genre>().GetByIdAsync(id);
        if (genre == null) throw new NotFoundException("Genre not found");
        return new GenreDto { Id = genre.Id, Name = genre.Name };
    }

    public async Task<GenreDto> UpdateAsync(Guid id, GenreDtoRequest request)
    {
        var genre = await uow.Repo<Genre>().GetByIdAsync(id);
        if (genre == null) throw new NotFoundException("Genre not found");
        genre.Name = request.Name;
        uow.Repo<Genre>().Update(genre);
        await uow.SaveChangesAsync();
        return new GenreDto { Id = genre.Id, Name = genre.Name };
    }

    public async Task DeleteAsync(Guid id)
    {
        var genre = await uow.Repo<Genre>().GetByIdAsync(id);
        if (genre == null) throw new NotFoundException("Genre not found");
        uow.Repo<Genre>().SoftDelete(genre);
        await uow.SaveChangesAsync();
    }
}

public class DirectorService(IUnitOfWork uow) : IDirectorService
{
    public async Task<Guid> CreateAsync(DirectorDtoRequest request)
    {
        var director = new Director { Name = request.Name, Bio = request.Bio, ImageUrl = request.ImageUrl };
        await uow.Repo<Director>().CreateAsync(director);
        await uow.SaveChangesAsync();
        return director.Id;
    }

    public async Task<IEnumerable<DirectorDto>> GetAllAsync()
    {
        var list = await uow.Repo<Director>().GetPagedListAsync(1, int.MaxValue);
        return list.Select(x => new DirectorDto { Id = x.Id, Name = x.Name, Bio = x.Bio, ImageUrl = x.ImageUrl });
    }

    public async Task<DirectorDto> GetByIdAsync(Guid id)
    {
        var director = await uow.Repo<Director>().GetByIdAsync(id);
        if (director == null) throw new NotFoundException("Director not found");
        return new DirectorDto { Id = director.Id, Name = director.Name, Bio = director.Bio, ImageUrl = director.ImageUrl };
    }

    public async Task<DirectorDto> UpdateAsync(Guid id, DirectorDtoRequest request)
    {
        var director = await uow.Repo<Director>().GetByIdAsync(id);
        if (director == null) throw new NotFoundException("Director not found");
        director.Name = request.Name;
        director.Bio = request.Bio;
        director.ImageUrl = request.ImageUrl;
        uow.Repo<Director>().Update(director);
        await uow.SaveChangesAsync();
        return new DirectorDto { Id = director.Id, Name = director.Name, Bio = director.Bio, ImageUrl = director.ImageUrl };
    }

    public async Task DeleteAsync(Guid id)
    {
        var director = await uow.Repo<Director>().GetByIdAsync(id);
        if (director == null) throw new NotFoundException("Director not found");
        uow.Repo<Director>().SoftDelete(director);
        await uow.SaveChangesAsync();
    }
}

public class ActorService(IUnitOfWork uow) : IActorService
{
    public async Task<Guid> CreateAsync(ActorDtoRequest request)
    {
        var actor = new Actor { Name = request.Name, Bio = request.Bio, ImageUrl = request.ImageUrl };
        await uow.Repo<Actor>().CreateAsync(actor);
        await uow.SaveChangesAsync();
        return actor.Id;
    }

    public async Task<IEnumerable<ActorDto>> GetAllAsync()
    {
        var list = await uow.Repo<Actor>().GetPagedListAsync(1, int.MaxValue);
        return list.Select(x => new ActorDto { Id = x.Id, Name = x.Name, Bio = x.Bio, ImageUrl = x.ImageUrl });
    }

    public async Task<ActorDto> GetByIdAsync(Guid id)
    {
        var actor = await uow.Repo<Actor>().GetByIdAsync(id);
        if (actor == null) throw new NotFoundException("Actor not found");
        return new ActorDto { Id = actor.Id, Name = actor.Name, Bio = actor.Bio, ImageUrl = actor.ImageUrl };
    }

    public async Task<ActorDto> UpdateAsync(Guid id, ActorDtoRequest request)
    {
        var actor = await uow.Repo<Actor>().GetByIdAsync(id);
        if (actor == null) throw new NotFoundException("Actor not found");
        actor.Name = request.Name;
        actor.Bio = request.Bio;
        actor.ImageUrl = request.ImageUrl;
        uow.Repo<Actor>().Update(actor);
        await uow.SaveChangesAsync();
        return new ActorDto { Id = actor.Id, Name = actor.Name, Bio = actor.Bio, ImageUrl = actor.ImageUrl };
    }

    public async Task DeleteAsync(Guid id)
    {
        var actor = await uow.Repo<Actor>().GetByIdAsync(id);
        if (actor == null) throw new NotFoundException("Actor not found");
        uow.Repo<Actor>().SoftDelete(actor);
        await uow.SaveChangesAsync();
    }
}
