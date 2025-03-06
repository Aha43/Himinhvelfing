using Himinhvelfing.Domain.Services;
using SimplePromptFramework;

namespace Himinhvelfing.Prompt.PromptHandlers.List;

public class Apis(IAstroApiProvider astroApiProvider) : ISpfPromptHandler
{
    public Task HandlePromptAsync(string[] path, string[] input, SpfState state)
    {
        var providers = astroApiProvider.GetProviders();
        foreach (var (api, uri) in providers)
        {
            Console.WriteLine($"{api}: {uri}");
        }

        return Task.CompletedTask;
    }
}
