using Himinhvelfing.Services;
using SimplePromptFramework;

var spf = new Spf(args, o => 
    {
        o.Services.AddHiminhvelfingServices();
        o.BaseNamespace = "Himinhvelfing.Prompt.PromptHandlers";
    }
);

await spf.StartAsync();
