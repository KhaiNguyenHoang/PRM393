using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Identity.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore;
using Netmu.Models;

namespace Netmu.Data;

public class AppDbContext(DbContextOptions<AppDbContext> options) : IdentityDbContext<ApplicationUser, IdentityRole<Guid>, Guid>(options)
{
    public DbSet<Movie> Movies { get; set; }
    public DbSet<Notification> Notifications { get; set; }
    public DbSet<FavoriteMovie> FavoriteMovies { get; set; }
    public DbSet<Review> Reviews { get; set; }
    public DbSet<Genre> Genres { get; set; }
    public DbSet<Director> Directors { get; set; }
    public DbSet<Actor> Actors { get; set; }
    public DbSet<MovieGenre> MovieGenres { get; set; }
    public DbSet<MovieDirector> MovieDirectors { get; set; }
    public DbSet<MovieActor> MovieActors { get; set; }
    public DbSet<History> Histories { get; set; }

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        base.OnModelCreating(modelBuilder);

        modelBuilder.Entity<Movie>().ToTable("movies");
        modelBuilder.Entity<Notification>().ToTable("notifications");
        modelBuilder.Entity<FavoriteMovie>().ToTable("favorite_movies");
        modelBuilder.Entity<Review>().ToTable("reviews");
        modelBuilder.Entity<Genre>().ToTable("genres");
        modelBuilder.Entity<Director>().ToTable("directors");
        modelBuilder.Entity<Actor>().ToTable("actors");
        modelBuilder.Entity<MovieGenre>().ToTable("movie_genres");
        modelBuilder.Entity<MovieDirector>().ToTable("movie_directors");
        modelBuilder.Entity<MovieActor>().ToTable("movie_actors");
        modelBuilder.Entity<History>().ToTable("histories");

        modelBuilder.Entity<MovieGenre>()
            .HasOne(x => x.Movie)
            .WithMany(x => x.MovieGenres)
            .HasForeignKey(x => x.MovieId);
        modelBuilder.Entity<MovieGenre>()
            .HasOne(x => x.Genre)
            .WithMany()
            .HasForeignKey(x => x.GenreId);

        modelBuilder.Entity<MovieDirector>()
            .HasOne(x => x.Movie)
            .WithMany(x => x.MovieDirectors)
            .HasForeignKey(x => x.MovieId);
        modelBuilder.Entity<MovieDirector>()
            .HasOne(x => x.Director)
            .WithMany()
            .HasForeignKey(x => x.DirectorId);

        modelBuilder.Entity<MovieActor>()
            .HasOne(x => x.Movie)
            .WithMany(x => x.MovieActors)
            .HasForeignKey(x => x.MovieId);
        modelBuilder.Entity<MovieActor>()
            .HasOne(x => x.Actor)
            .WithMany()
            .HasForeignKey(x => x.ActorId);

        modelBuilder.Entity<History>()
            .HasOne(x => x.User)
            .WithMany()
            .HasForeignKey(x => x.UserId);
        modelBuilder.Entity<History>()
            .HasOne(x => x.Movie)
            .WithMany()
            .HasForeignKey(x => x.MovieId);

        modelBuilder.Entity<Notification>()
            .HasOne(x => x.Receiver)
            .WithMany(x => x.Notifications)
            .HasForeignKey(x => x.ReceiverId);

        modelBuilder.Entity<FavoriteMovie>()
            .HasOne(x => x.User)
            .WithMany()
            .HasForeignKey(x => x.UserId);

        modelBuilder.Entity<FavoriteMovie>()
            .HasOne(x => x.Movie)
            .WithMany()
            .HasForeignKey(x => x.MovieId);

        modelBuilder.Entity<Review>()
            .HasOne(x => x.User)
            .WithMany()
            .HasForeignKey(x => x.UserId);

        modelBuilder.Entity<Review>()
            .HasOne(x => x.Movie)
            .WithMany()
            .HasForeignKey(x => x.MovieId);

        // Identity tables
        modelBuilder.Entity<ApplicationUser>().ToTable("users");
        modelBuilder.Entity<IdentityRole<Guid>>().ToTable("roles");
        modelBuilder.Entity<IdentityUserRole<Guid>>().ToTable("user_roles");
        modelBuilder.Entity<IdentityUserClaim<Guid>>().ToTable("user_claims");
        modelBuilder.Entity<IdentityUserLogin<Guid>>().ToTable("user_logins");
        modelBuilder.Entity<IdentityUserToken<Guid>>().ToTable("user_tokens");
        modelBuilder.Entity<IdentityRoleClaim<Guid>>().ToTable("role_claims");
    }
}