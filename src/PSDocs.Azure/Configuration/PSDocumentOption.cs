// Copyright (c) Microsoft Corporation.
// Licensed under the MIT License.

using System.Diagnostics;
using System.IO;
using System.Management.Automation;

namespace PSDocs.Azure.Configuration
{
    /// <summary>
    /// A delgate to allow callback to PowerShell to get current working path.
    /// </summary>
    internal delegate string PathDelegate();

    /// <summary>
    /// The base class for configuring options within PSDocs.
    /// </summary>
    public sealed class PSDocumentOption
    {
        internal static readonly PSDocumentOption Default = new()
        {
            Output = OutputOption.Default
        };

        /// <summary>
        /// A callback that is overridden by PowerShell so that the current working path can be retrieved.
        /// </summary>
        private static PathDelegate _GetWorkingPath = () => Directory.GetCurrentDirectory();

        /// <summary>
        /// Create an instance of options.
        /// </summary>
        public PSDocumentOption()
        {
            // Set defaults
            Output = new OutputOption();
        }

        /// <summary>
        /// Options that affect how output is generated.
        /// </summary>
        public OutputOption Output { get; set; }

        /// <summary>
        /// Set working path from PowerShell host environment.
        /// </summary>
        /// <param name="executionContext">An $ExecutionContext object.</param>
        /// <remarks>
        /// Called from PowerShell.
        /// </remarks>
        public static void UseExecutionContext(EngineIntrinsics executionContext)
        {
            if (executionContext == null)
            {
                _GetWorkingPath = () => Directory.GetCurrentDirectory();
                return;
            }
            _GetWorkingPath = () => executionContext.SessionState.Path.CurrentFileSystemLocation.Path;
        }

        /// <summary>
        /// Get the current working path.
        /// </summary>
        public static string GetWorkingPath()
        {
            return _GetWorkingPath();
        }

        /// <summary>
        /// Get a full path instead of a relative path that may be passed from PowerShell.
        /// </summary>
        internal static string GetRootedPath(string path)
        {
            return Path.IsPathRooted(path) ? path : Path.GetFullPath(Path.Combine(GetWorkingPath(), path));
        }

        /// <summary>
        /// Get a full path instead of a relative path that may be passed from PowerShell.
        /// </summary>
        internal static string GetRootedBasePath(string path)
        {
            var rootedPath = GetRootedPath(path);
            if (rootedPath.Length > 0 && IsSeparator(rootedPath[rootedPath.Length - 1]))
                return rootedPath;

            return File.Exists(rootedPath) ? rootedPath : string.Concat(rootedPath, Path.DirectorySeparatorChar);
        }

        [DebuggerStepThrough]
        private static bool IsSeparator(char c)
        {
            return c == Path.DirectorySeparatorChar || c == Path.AltDirectorySeparatorChar;
        }
    }
}
