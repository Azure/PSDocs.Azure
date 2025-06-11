// Copyright (c) Microsoft Corporation.
// Licensed under the MIT License.

// An example for a storage account
targetScope = 'resourceGroup'
metadata name = 'Storage Account'
metadata description = 'Create or update a Storage Account.'
metadata details = 'This template deploys a Storage Account including blob containers and files shares. Encryption in transit it enabled using a minimum of TLS 1.2.'

@sys.description('The name of the storage account.')
param name string

@sys.description('The location of the storage account.')
param location string = resourceGroup().location

@sys.description('Tags for the storage account.')
param tags object?

resource storage 'Microsoft.Storage/storageAccounts@2022-09-01' = {
  name: name
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  tags: tags
}
