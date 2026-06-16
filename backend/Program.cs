using System.Text;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Tokens;
using Netmu.Data;
using Netmu.Exceptions;
using Netmu.Middlewares;
using Netmu.Models;
using Netmu.Repositories.Contracts;
using Netmu.Repositories.Implementations;
using Netmu.Services.Contracts;
using Netmu.Services.Implementations;
using Netmu.Utils.Security;
using Scalar.AspNetCore;

var builder = WebApplication.CreateBuilder(args);

// Database
builder.Services.AddDbContext<AppDbContext>(options =>
    options.UseNpgsql(builder.Configuration.GetConnectionString("DefaultConnection")));

// Identity
builder.Services.AddIdentity<ApplicationUser, IdentityRole<Guid>>(options =>
    {
        options.User.RequireUniqueEmail = true;
    })
    .AddEntityFrameworkStores<AppDbContext>()
    .AddDefaultTokenProviders();

// JWT Authentication
var jwtSection = builder.Configuration.GetSection("Jwt");
builder.Services.AddAuthentication(options =>
    {
        options.DefaultAuthenticateScheme = JwtBearerDefaults.AuthenticationScheme;
        options.DefaultChallengeScheme = JwtBearerDefaults.AuthenticationScheme;
    })
    .AddJwtBearer(options =>
    {
        options.TokenValidationParameters = new TokenValidationParameters
        {
            ValidateIssuer = true,
            ValidateAudience = true,
            ValidateLifetime = true,
            ValidateIssuerSigningKey = true,
            ValidIssuer = jwtSection["Issuer"],
            ValidAudience = jwtSection["Audience"],
            IssuerSigningKey = new SymmetricSecurityKey(
                Encoding.UTF8.GetBytes(jwtSection["Secret"]!)),
        };
    });

builder.Services.AddAuthorization();
builder.Services.AddControllers();
builder.Services.AddOpenApi(options =>
{
    options.AddDocumentTransformer<BearerSecuritySchemeTransformer>();
});

// CORS
builder.Services.AddCors(options =>
{
    options.AddDefaultPolicy(policy =>
    {
        policy.AllowAnyOrigin()
              .AllowAnyHeader()
              .AllowAnyMethod();
    });
});

// DI
builder.Services.AddScoped<IUnitOfWork, UnitOfWork>();
builder.Services.AddScoped<IMovieService, MovieService>();
builder.Services.AddScoped<IUserService, UserService>();
builder.Services.AddScoped<INotificationService, NotificationService>();
builder.Services.AddSingleton<Fcm>();

// Options pattern
builder.Services.Configure<FcmSettings>(builder.Configuration.GetSection("FcmSettings"));

// Exception handler
builder.Services.AddExceptionHandler<ExceptionHandler>();

var app = builder.Build();

// Seed roles and admin user
using (var scope = app.Services.CreateScope())
{
    var roleManager = scope.ServiceProvider.GetRequiredService<RoleManager<IdentityRole<Guid>>>();
    var userManager = scope.ServiceProvider.GetRequiredService<UserManager<ApplicationUser>>();
    var context = scope.ServiceProvider.GetRequiredService<AppDbContext>();

    if (!await roleManager.RoleExistsAsync("admin"))
        await roleManager.CreateAsync(new IdentityRole<Guid>("admin"));
    if (!await roleManager.RoleExistsAsync("user"))
        await roleManager.CreateAsync(new IdentityRole<Guid>("user"));

    var adminUser = await userManager.FindByNameAsync("admin");
    if (adminUser == null)
    {
        adminUser = new ApplicationUser
        {
            UserName = "admin",
            Email = "admin@netmu.com",
        };
        var result = await userManager.CreateAsync(adminUser, "Admin@123");
        if (result.Succeeded)
            await userManager.AddToRoleAsync(adminUser, "admin");
    }

    var movies = new List<Movie>
    {
        new()
        {
            Title = "The Last Horizon",
            Description = "A sci-fi adventure about humanity's final mission beyond the solar system.",
            Director = "Christopher Nolan",
            Genres = ["Sci-Fi", "Adventure"],
            DurationInMinutes = 148,
            VideoUrl = "https://www.youtube.com/watch?v=YoHD9XEInc0",
            ImageUrl = "https://images.unsplash.com/photo-1534447677768-be436bb09401"
        },
        new()
        {
            Title = "Silent Echoes",
            Description = "A psychological thriller centered around a detective haunted by his past.",
            Director = "Denis Villeneuve",
            Genres = ["Thriller", "Mystery"],
            DurationInMinutes = 124,
            VideoUrl = "",
            ImageUrl = "https://images.unsplash.com/photo-1517604931442-7e0c8ed2963c"
        },
        new()
        {
            Title = "Midnight Streets",
            Description = "A gripping crime drama set in the underground world of Tokyo.",
            Director = "Michael Mann",
            Genres = ["Crime", "Drama"],
            DurationInMinutes = 132,
            VideoUrl = "https://www.youtube.com/watch?v=EXeTwQWrcwY",
            ImageUrl = "https://images.unsplash.com/photo-1497032628192-86f99bcd76bc"
        },
        new()
        {
            Title = "Dreamwalker",
            Description = "A fantasy story about a girl who can travel through dreams.",
            Director = "Guillermo del Toro",
            Genres = ["Fantasy", "Adventure"],
            DurationInMinutes = 115,
            VideoUrl = "",
            ImageUrl = "https://images.unsplash.com/photo-1500530855697-b586d89ba3ee"
        },
        new()
        {
            Title = "Code Red",
            Description = "Elite hackers race against time to stop a global cyberattack.",
            Director = "David Fincher",
            Genres = ["Action", "Thriller"],
            DurationInMinutes = 127,
            VideoUrl = "https://www.youtube.com/watch?v=LXb3EKWsInQ",
            ImageUrl = "https://images.unsplash.com/photo-1518770660439-4636190af475"
        },
        new()
        {
            Title = "Summer in Florence",
            Description = "A heartfelt romance blooming during an Italian summer.",
            Director = "Nancy Meyers",
            Genres = ["Romance", "Drama"],
            DurationInMinutes = 108,
            VideoUrl = "",
            ImageUrl = "https://images.unsplash.com/photo-1491553895911-0055eca6402d"
        },
        new()
        {
            Title = "Iron Battalion",
            Description = "Soldiers fight for survival in a futuristic warzone.",
            Director = "James Cameron",
            Genres = ["Action", "Sci-Fi"],
            DurationInMinutes = 141,
            VideoUrl = "https://www.youtube.com/watch?v=TcMBFSGVi1c",
            ImageUrl = "https://images.unsplash.com/photo-1506744038136-46273834b3fb"
        },
        new()
        {
            Title = "The Forgotten Journal",
            Description = "A historian uncovers secrets hidden in a centuries-old diary.",
            Director = "Steven Spielberg",
            Genres = ["Mystery", "Adventure"],
            DurationInMinutes = 119,
            VideoUrl = "",
            ImageUrl = "https://images.unsplash.com/photo-1512820790803-83ca734da794"
        },
        new()
        {
            Title = "Neon Run",
            Description = "Street racers compete in a neon-lit cyberpunk city.",
            Director = "Justin Lin",
            Genres = ["Action", "Sport"],
            DurationInMinutes = 110,
            VideoUrl = "https://www.youtube.com/watch?v=2g811Eo7K8U",
            ImageUrl = "https://images.unsplash.com/photo-1500534314209-a25ddb2bd429"
        },
        new()
        {
            Title = "Frozen Kingdom",
            Description = "An epic journey across a kingdom trapped in eternal winter.",
            Director = "Peter Jackson",
            Genres = ["Fantasy", "Drama"],
            DurationInMinutes = 156,
            VideoUrl = "",
            ImageUrl = "https://images.unsplash.com/photo-1482192596544-9eb780fc7f66"
        },
        new()
        {
            Title = "The Painter's Secret",
            Description = "An artist discovers hidden messages inside famous paintings.",
            Director = "Wes Anderson",
            Genres = ["Drama", "Mystery"],
            DurationInMinutes = 102,
            VideoUrl = "",
            ImageUrl = "https://images.unsplash.com/photo-1460661419201-fd4cecdf8a8b"
        },
        new()
        {
            Title = "Skyline Pursuit",
            Description = "A rogue pilot is chased across dangerous skies.",
            Director = "Joseph Kosinski",
            Genres = ["Action", "Adventure"],
            DurationInMinutes = 129,
            VideoUrl = "https://www.youtube.com/watch?v=giXco2jaZ_4",
            ImageUrl = "https://images.unsplash.com/photo-1473448912268-2022ce9509d8"
        },
        new()
        {
            Title = "Hidden Frequency",
            Description = "Scientists detect a mysterious signal from deep space.",
            Director = "Ridley Scott",
            Genres = ["Sci-Fi", "Thriller"],
            DurationInMinutes = 138,
            VideoUrl = "",
            ImageUrl = "https://images.unsplash.com/photo-1446776811953-b23d57bd21aa"
        },
        new()
        {
            Title = "The Last Symphony",
            Description = "A struggling musician attempts one final comeback performance.",
            Director = "Damien Chazelle",
            Genres = ["Music", "Drama"],
            DurationInMinutes = 121,
            VideoUrl = "",
            ImageUrl = "https://images.unsplash.com/photo-1493225457124-a3eb161ffa5f"
        },
        new()
        {
            Title = "Zero Gravity",
            Description = "Astronauts fight to survive after a catastrophic accident in orbit.",
            Director = "Alfonso Cuarón",
            Genres = ["Sci-Fi", "Drama"],
            DurationInMinutes = 97,
            VideoUrl = "https://www.youtube.com/watch?v=OiTiKOy59o4",
            ImageUrl = "https://images.unsplash.com/photo-1462331940025-496dfbfc7564"
        },
        new()
        {
            Title = "Wild Frontier",
            Description = "Explorers venture into uncharted wilderness seeking ancient ruins.",
            Director = "Alejandro González Iñárritu",
            Genres = ["Adventure", "Drama"],
            DurationInMinutes = 144,
            VideoUrl = "",
            ImageUrl = "https://images.unsplash.com/photo-1501785888041-af3ef285b470"
        },
        new()
        {
            Title = "Crimson Verdict",
            Description = "A lawyer uncovers corruption inside the justice system.",
            Director = "Martin Scorsese",
            Genres = ["Crime", "Drama"],
            DurationInMinutes = 136,
            VideoUrl = "",
            ImageUrl = "https://images.unsplash.com/photo-1504384308090-c894fdcc538d"
        },
        new()
        {
            Title = "Ocean Depths",
            Description = "Marine researchers encounter terrifying creatures beneath the sea.",
            Director = "James Wan",
            Genres = ["Horror", "Sci-Fi"],
            DurationInMinutes = 113,
            VideoUrl = "https://www.youtube.com/watch?v=dQw4w9WgXcQ",
            ImageUrl = "https://images.unsplash.com/photo-1507525428034-b723cf961d3e"
        },
        new()
        {
            Title = "Parallel Lives",
            Description = "Two strangers discover their lives are mysteriously connected.",
            Director = "Sofia Coppola",
            Genres = ["Drama", "Romance"],
            DurationInMinutes = 118,
            VideoUrl = "",
            ImageUrl = "https://images.unsplash.com/photo-1494526585095-c41746248156"
        },
        new()
        {
            Title = "Ashes of Tomorrow",
            Description = "In a dystopian future, rebels fight against an oppressive regime.",
            Director = "George Miller",
            Genres = ["Action", "Sci-Fi"],
            DurationInMinutes = 134,
            VideoUrl = "https://www.youtube.com/watch?v=hA6hldpSTF8",
            ImageUrl = "https://images.unsplash.com/photo-1500534623283-312aade485b7"
        }
    };

    await context.Movies.AddRangeAsync(movies);
    await context.SaveChangesAsync();
}

// Middleware pipeline
if (app.Environment.IsDevelopment())
{
    app.MapOpenApi();
    app.MapScalarApiReference(options =>
    {
        options.Theme = ScalarTheme.BluePlanet;
    });
}

app.UseCors();
app.UseExceptionHandler(_ => { });
app.UseAuthentication();
app.UseAuthorization();
app.MapControllers();

app.Run();
