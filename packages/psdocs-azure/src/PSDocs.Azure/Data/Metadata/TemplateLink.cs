// Copyright (c) Microsoft Corporation.
// Licensed under the MIT License.

using System;
using System.Collections;

namespace PSDocs.Azure.Data.Metadata
{
    internal sealed class TemplateLink : ITemplateLink
    {
        internal TemplateLink(string templateFile, string version)
        {
            TemplateFile = templateFile;
            Version = Version.Parse(version);
            Metadata = new Hashtable();
        }

        public string Name { get; internal set; }

        public string Description { get; internal set; }

        public string TemplateFile { get; }

        public Version Version { get; }

        public Hashtable Metadata { get; internal set; }
    }
}
