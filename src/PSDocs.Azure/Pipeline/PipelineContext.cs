// Copyright (c) Microsoft Corporation.
// Licensed under the MIT License.

using PSDocs.Azure.Configuration;

namespace PSDocs.Azure.Pipeline
{
    internal sealed class PipelineContext
    {
        internal readonly PSDocumentOption Option;

        public PipelineContext(PSDocumentOption option)
        {
            Option = option;
        }
    }
}
