# Azure Bicep Tips & Tricks

![Bicep Logo](../images/BicepLogoImage.png)

## Prerequisites

| Name | Link
|:-- |:--
| Azure Bicep | [Docs](https://docs.microsoft.com/azure/azure-resource-manager/bicep/overview?tabs=bicep)
| VS Code | [Install](https://code.visualstudio.com/download)
| Azure Bicep Extension (VS Code) | [Install](https://marketplace.visualstudio.com/items?itemName=ms-azuretools.vscode-bicep)
| PowerShell | [Install](https://github.com/PowerShell/PowerShell/blob/master/README.md#get-powershell)
| Azure PowerShell | [Docs](https://docs.microsoft.com/powershell/azure/get-started-azureps?view=azps-8.3.0)
| ACR Hosted Bicep Modules | [Docs](https://docs.microsoft.com/azure/azure-resource-manager/bicep/private-module-registry?tabs=azure-powershell)

## Concepts

![Management Groups](../images/scope-levels.png)

## Obstacles

- Development team adoption
- Tribal Knowledge
  - Who knows where everything is?
  - Do you?
- Across how many teams?
- Across how many regions?
- How quickly can you get a security fix out?
- Have you ever had an outage or issue due to:
  - Someone changing or forgetting to change a setting?
  - Someone with too much access touching things they don't understand?
- How often do you rotate security keys?
  - Are the apps and their settings updated manually?
- What you test in development SHOULD be what you run in production, right?
    <details>
    <summary>
    Trigger warning
    </summary>
    <span style="color:red">Have you ever had your code run differently "on someone else's computer"?</span>
    </details>

## Scenario

- Create a resource group
- Create a website
- Add telemetry
  - Connect them using a secure password
- Create a SQL server
  - Add a database
  - Connect them using a secure password
- Create development and production environments
  - Oooops we need it for all the previous steps
- Deploy to another country
- Create a diagram for your auditors (SOC 2, etc.)
- Auditors require proof of approvals and change management
- Warning (here comes the injection work)
  <details>
    <summary>
      Security Team
    </summary>
    <span style="color:red">Needs SQL sensitivity labels</span>
  </details>

