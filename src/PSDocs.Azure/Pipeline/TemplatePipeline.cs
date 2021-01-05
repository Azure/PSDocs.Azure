// Copyright (c) Microsoft Corporation.
// Licensed under the MIT License.

using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using PSDocs.Azure.Configuration;
using PSDocs.Azure.Data.Metadata;
using PSDocs.Azure.Resources;
using System;
using System.Collections;
using System.Globalization;
using System.IO;
using System.Management.Automation;
using System.Threading;

namespace PSDocs.Azure.Pipeline
{
    public interface ITemplatePipelineBuilder : IPipelineBuilder
    {

    }

    internal sealed class TemplatePipelineBuilder : PipelineBuilderBase, ITemplatePipelineBuilder
    {
        private readonly string _BasePath;

        internal TemplatePipelineBuilder(string basePath)
        {
            _BasePath = basePath;
        }

        protected override PipelineWriter PrepareWriter()
        {
            var writer = base.PrepareWriter();
            writer.VerbosePrefix = "[Get-AzDocTemplateFile] ";
            return writer;
        }

        public override IPipeline Build()
        {
            return new TemplatePipeline(PrepareContext(), PrepareWriter(), _BasePath);
        }
    }

    internal sealed class TemplatePipeline : PipelineBase
    {
        private const string PROPERTYNAME_SCHEMA = "$schema";
        private const string PROPERTYNAME_CONTENTVERSION = "contentVersion";
        private const string PROPERTYNAME_METADATA = "metadata";
        private const string PROPERTYNAME_TEMPLATE = "template";
        private const string PROPERTYNAME_NAME = "name";
        private const string PROPERTYNAME_DESCRIPTION = "description";

        private const string DEFAULT_TEMPLATESEARCH_PATTERN = "*.json";

        private readonly string _BasePath;
        private readonly PathBuilder _PathBuilder;

        internal TemplatePipeline(PipelineContext context, PipelineWriter writer, string basePath)
            : base(context, writer)
        {
            _BasePath = PSDocumentOption.GetRootedBasePath(basePath);
            _PathBuilder = new PathBuilder(writer, basePath, DEFAULT_TEMPLATESEARCH_PATTERN);
        }

        public override void Process(PSObject sourceObject)
        {
            if (sourceObject == null || !GetPath(sourceObject, out string path))
                return;

            _PathBuilder.Add(path);
            var fileInfos = _PathBuilder.Build();
            foreach (var info in fileInfos)
                ProcessTemplateFile(info.FullName);
        }

        private void ProcessTemplateFile(string templateFile)
        {
            try
            {
                var rootedTemplateFile = PSDocumentOption.GetRootedPath(templateFile);

                // Check if metadata property exists
                if (!TryTemplateFile(rootedTemplateFile, out string version, out JObject metadata))
                    return;

                var templateLink = new TemplateLink(rootedTemplateFile, version);

                // Populate remaining properties
                if (TryStringProperty(metadata, PROPERTYNAME_NAME, out string name))
                    templateLink.Name = name;

                if (TryStringProperty(metadata, PROPERTYNAME_DESCRIPTION, out string description))
                    templateLink.Description = description;

                if (TryMetadata(metadata, out Hashtable meta))
                    templateLink.Metadata = meta;

                // var pso = PSObject.AsPSObject(templateLink);
                // var instanceNameProp = new PSNoteProperty("InstanceName", string.Concat(templateLink.Name, "_v", templateLink.Version.Major));
                // pso.Members.Add(new PSMemberSet("PSDocs", new PSMemberInfo[] { instanceNameProp }));

                Writer.WriteObject(templateLink, false);
            }
            catch (InvalidOperationException ex)
            {
                Writer.WriteError(ex, nameof(InvalidOperationException), ErrorCategory.InvalidOperation, templateFile);
            }
            catch (FileNotFoundException ex)
            {
                Writer.WriteError(ex, nameof(FileNotFoundException), ErrorCategory.ObjectNotFound, templateFile);
            }
            catch (PipelineException ex)
            {
                Writer.WriteError(ex, nameof(PipelineException), ErrorCategory.WriteError, templateFile);
            }
        }

        private static bool GetPath(PSObject sourceObject, out string path)
        {
            path = null;
            if (sourceObject.BaseObject is string s)
            {
                path = s;
                return true;
            }
            if (sourceObject.BaseObject is FileInfo info && info.Extension == ".json")
            {
                path = info.FullName;
                return true;
            }
            return false;
        }

        private static T ReadFile<T>(string path)
        {
            if (string.IsNullOrEmpty(path) || !File.Exists(path))
                throw new FileNotFoundException(string.Format(CultureInfo.CurrentCulture, PSDocsResources.TemplateFileNotFound, path), path);

            try
            {
                return JsonConvert.DeserializeObject<T>(File.ReadAllText(path));
            }
            catch (InvalidCastException)
            {
                // Discard exception
                return default;
            }
            catch (Exception inner)
            {
                throw new TemplateReadException(string.Format(Thread.CurrentThread.CurrentCulture, PSDocsResources.JsonFileFormatInvalid, path, inner.Message), inner, path, null);
            }
        }

        /// <summary>
        /// Check the JSON object is an ARM template file.
        /// </summary>
        private static bool IsTemplateFile(JObject value)
        {
            if (!value.TryGetValue(PROPERTYNAME_SCHEMA, out JToken token) || !Uri.TryCreate(token.Value<string>(), UriKind.Absolute, out Uri schemaUri))
                return false;

            return StringComparer.OrdinalIgnoreCase.Equals(schemaUri.Host, "schema.management.azure.com") &&
                schemaUri.PathAndQuery.StartsWith("/schemas/", StringComparison.OrdinalIgnoreCase) &&
                schemaUri.PathAndQuery.EndsWith("deploymentTemplate.json", StringComparison.OrdinalIgnoreCase);
        }

        private bool TryTemplateFile(string templateFile, out string version, out JObject metadata)
        {
            var jsonData = ReadFile<JObject>(templateFile);
            metadata = null;
            version = null;

            // Check that the JSON file is an ARM template file
            if (jsonData == null || !IsTemplateFile(jsonData))
                return false;

            if (!(jsonData.TryGetValue(PROPERTYNAME_CONTENTVERSION, out JToken versionToken) && versionToken is JValue versionValue))
                return false;

            version = versionValue.ToString();
            Writer.VerboseFoundTemplate(templateFile);
            if (jsonData.TryGetValue(PROPERTYNAME_METADATA, out JToken metadataToken) && metadataToken is JObject metadataProperty)
                metadata = metadataProperty;

            if (metadata == null)
                Writer.VerboseMetadataNotFound(templateFile);

            return true;
        }

        private static bool TryStringProperty(JObject o, string propertyName, out string value)
        {
            value = null;
            return o != null && o.TryGetValue(propertyName, out JToken token) && TryString(token, out value);
        }

        private static bool TryMetadata(JObject o, out Hashtable value)
        {
            value = null;
            if (o == null)
                return false;

            value = new Hashtable();
            foreach (var prop in o.Properties())
            {
                value[prop.Name] = prop.Value.ToString();
            }
            return value.Count > 0;
        }

        private static bool TryString(JToken token, out string value)
        {
            value = null;
            if (token == null || token.Type != JTokenType.String)
                return false;

            value = token.Value<string>();
            return true;
        }
    }
}
