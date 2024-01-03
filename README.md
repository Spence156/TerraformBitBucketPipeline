# Terraform BitBucket Pipeline
This repo contains an example setup for using BitBucket to run Terraform to deploy Microsoft Azure Resources using a service principal with a client secret.

## Outcome

The outcome of this process will be to have a pipeline trigger on every branch update to validate and plan the changes and then on the main branch when it is updated to run the validate steps again but also offer a manual option to trigger the deployment.

## Pre-Requisites

1) You must have the Azure CLI installed on the machine (You can use the GUI but the instructions here will not cover that)

Instructions on how to use the GUI can be found here:

https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/guides/service_principal_client_secret#1-creating-an-application-in-azure-active-directory

The process for setting this up is as follows:

1) Create a Service Principal

    1a) Login to the Azure Account using the Azure CLI

    ```bash
        az login
    ```

    1b) Check the account connected to is the one you wish to connect to the pipeline by running:

    ```bash
    az account show
    ```

    1c) If it is not you can change the account using:

    ```bash
    az account set --subscription <SubscriptionName/Id>
    ```
    1d) Create the service pricipal

    ```bash
        az ad sp create-for-rbac --role="Contributor" --scopes="/subscriptions/<SubscriptionId>"
    ```
    E.g.

    ```bash
        az ad sp create-for-rbac --role="Contributor" --scopes="/subscriptions/20000000-0000-0000-0000-000000000000"
    ```

    This will output 5 values which are mapped below:

    | Output      | Use                     |
    | :---        |:----                    |
    | appId       | ARM_CLIENT_ID environment variable  |
    | displayName | Name which the App will appear in Azure Entra ID/Azure Portal |
    | name        | GUID ID for the App |
    | password    | ARM_CLIENT_SECRET environment variable                  |
    | tenant      | ARM_TENANT_ID environment variable                  |

2) Create the following Environment Variables.

    In BitBuck create the following Repository or Deployment Variables (Depending on setup):

    | Variable    | Use                     | Secured                     |
    | :---        |:----                    |:----                    |
    | ARM_SUBSCRIPTION_ID  | SubscriptionId for the subscription which will be deployed to | False |
    | ARM_CLIENT_ID | "appId" from the Azure Entra App\Service Pricipal | False |
    | ARM_CLIENT_SECRET | "password" from the Azure Entra App\Service Pricipal | True |
    | ARM_TENANT_ID    | "tenant" from the Azure Entra App\Service Pricipal | False |

3) Setup build pipeline.

Add the [bitbucket-pipelines.yml](https://github.com/Spence156/TerraformBitBucketPipeline/blob/eb9150105f13100473eb784700f4663222a61683/bitbucket-pipelines.yml) to the git repo.