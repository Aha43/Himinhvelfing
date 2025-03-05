using Himinhvelfing.Domain.Services;
using Microsoft.Extensions.DependencyInjection;

namespace Himinhvelfing.Services;

public static class Services
{
    public static IServiceCollection AddHiminhvelfingServices(this IServiceCollection services)
    {
        return services.AddSingleton<IAstroApiProvider, AstroApiProvider>();
    } 
}
