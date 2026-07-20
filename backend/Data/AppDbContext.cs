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
    public DbSet<Playlist> Playlists { get; set; }
    public DbSet<PlaylistMovie> PlaylistMovies { get; set; }

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        base.OnModelCreating(modelBuilder);

        modelBuilder.Entity<Movie>().ToTable("movies");
        modelBuilder.Entity<Notification>().ToTable("notifications");
        modelBuilder.Entity<FavoriteMovie>().ToTable("favorite_movies");
        modelBuilder.Entity<Review>().ToTable("reviews");
        modelBuilder.Entity<Playlist>().ToTable("playlists");
        modelBuilder.Entity<PlaylistMovie>().ToTable("playlist_movies");

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

        modelBuilder.Entity<Playlist>()
            .HasOne(x => x.User)
            .WithMany()
            .HasForeignKey(x => x.UserId);

        modelBuilder.Entity<PlaylistMovie>()
            .HasOne(x => x.Playlist)
            .WithMany(x => x.PlaylistMovies)
            .HasForeignKey(x => x.PlaylistId);

        modelBuilder.Entity<PlaylistMovie>()
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