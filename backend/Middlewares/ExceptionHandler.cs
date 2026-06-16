using System.ComponentModel.DataAnnotations;
using Microsoft.AspNetCore.Diagnostics;
using Microsoft.AspNetCore.Mvc;
using Netmu.Exceptions;

namespace Netmu.Middlewares;

public class ExceptionHandler(ILogger<ExceptionHandler> logger) : IExceptionHandler
{
    public async ValueTask<bool> TryHandleAsync(HttpContext context, Exception exception,
        CancellationToken cancellationToken)
    {
        logger.LogError("Exception: {exception}", new
        {
            exception.Message,
            context.Request.Path,
            Trace = exception.StackTrace
        });

        // Identify which exception type to handle
        var (detail, title, status) = exception switch
        {
            NotFoundException => (
                exception.Message,
                exception.GetType().Name,
                context.Response.StatusCode = StatusCodes.Status404NotFound
            ),
            BadRequestException => (
                exception.Message,
                exception.GetType().Name,
                context.Response.StatusCode = StatusCodes.Status400BadRequest
            ),
            UnauthorizeException => (
                $"{exception.Message}",
                exception.GetType().Name,
                context.Response.StatusCode = StatusCodes.Status401Unauthorized
            ),
            // Custom InternalServerErrorException and any uncaught exception will be 500
            _ => (
                exception.Message,
                exception.GetType().Name,
                context.Response.StatusCode = StatusCodes.Status500InternalServerError
            )
        };

        // Create problem details
        var problemDetails = new ProblemDetails()
        {
            Title = title,
            Detail = detail,
            Status = status,
            Instance = context.Request.Path,
        };

        // Add extensions for problem details
        problemDetails.Extensions.Add("traceId", context.TraceIdentifier);

        // Write problem details into Response object
        await context.Response.WriteAsJsonAsync(problemDetails, cancellationToken);
        return true;
    }
}