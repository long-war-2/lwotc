using System;
using System.IO;
using System.Threading;
using System.Management.Automation;

using Microsoft.Build.Framework;
using Microsoft.Build.Utilities;

public class InvokePowershellTask : Task, ICancelableTask
{
    [Required] public string EntryPs1 { get; set; }
    [Required] public string SolutionRoot { get; set; }
    [Required] public string SdkInstallPath { get; set; }
    [Required] public string GameInstallPath { get; set; }
    [Required] public ITaskItem[] AdditionalArgs { get; set; }

    private PowerShell _ps;

    private ManualResetEventSlim _startingMre = new ManualResetEventSlim(false);

    public override bool Execute()
    {
        bool isSuccess = false;

        try
        {
            _ps = PowerShell.Create();

            _ps
                .AddCommand("Set-ExecutionPolicy")
                .AddArgument("Unrestricted")
                .AddParameter("Scope","CurrentUser");
            
            _ps
                .AddStatement()
                .AddCommand(EntryPs1)
                .AddParameter("srcDirectory", TrimEndingDirectorySeparator(SolutionRoot))
                .AddParameter("sdkPath", TrimEndingDirectorySeparator(SdkInstallPath))
                .AddParameter("gamePath", TrimEndingDirectorySeparator(GameInstallPath));

            foreach (ITaskItem Arg in AdditionalArgs)
            {
                string Val = Arg.GetMetadata("Value");
                if (string.IsNullOrEmpty(Val))
                {
                    _ps.AddParameter(Arg.ItemSpec);
                }
                else
                {
                    _ps.AddParameter(Arg.ItemSpec, Val);
                }
            }

            BindStreamEntryCallback(_ps.Streams.Debug, record => LogOutput(record.ToString()));
            BindStreamEntryCallback(_ps.Streams.Information, record => LogOutput(record.ToString()));
            BindStreamEntryCallback(_ps.Streams.Verbose, record => LogOutput(record.ToString()));
            BindStreamEntryCallback(_ps.Streams.Warning, record => LogOutput(record.ToString())); // TODO: More flashy output?

            BindStreamEntryCallback(_ps.Streams.Error, record =>
            {
                // TODO: Less info than when from console
                // TODO: More flashy output?
                LogOutput(record.ToString());
                Log.LogError(record.ToString());
                isSuccess = false;
            });

            _ps.InvocationStateChanged += (sender, args) => 
            {
                if (args.InvocationStateInfo.State == PSInvocationState.Running)
                {
                    _startingMre.Set();
                }
            };

            isSuccess = true;
            _ps.Invoke();
        }
        catch (System.Exception e)
        {
            Log.LogError(e.Message);
            isSuccess = false;
        }

        return isSuccess;
    }

    public void Cancel()
    {
        // Log.LogMessage(MessageImportance.High, "Got cancel");

        // Do not call Stop() until we know that we've actually started
        // This could be more elaborate, but the time interval between Execute() and Invoke() being called is extremely small

        _startingMre.Wait();
        _ps.Stop();
    }

    private void LogOutput (string output)
    {
        // This is required to keep the empty lines in the output
        if (string.IsNullOrEmpty(output)) output = " ";

        Log.LogMessage(MessageImportance.High, output);
    }

    private static readonly char[] DirectorySeparatorsForTrimming = new char[]
    {
        Path.DirectorySeparatorChar,
        Path.AltDirectorySeparatorChar
    };

    private static string TrimEndingDirectorySeparator(string path)
    {
        return path.TrimEnd(DirectorySeparatorsForTrimming);
    }

    private static void BindStreamEntryCallback<T>(PSDataCollection<T> stream, Action<T> handler)
    {
        stream.DataAdded += (object sender, DataAddedEventArgs e) => handler(stream[e.Index]);
    }
}