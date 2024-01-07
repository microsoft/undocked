# Undocked Windows Development

The goal of this project is to provide helpers for Windows components to build exactly as they would internally in the Windows OS repository, but without a lot of complicated manual steps.

This project provides three main components:

- [windows.undocked.props](vs/windows.undocked.props) - Visual Studio property file to simplify components' project files.
- [windows.undocked.targets](vs/windows.undocked.targets) - Similar to the .props file, but only required if source link is being used.
- [build.yml](onebranch/v1/build.yml) - Azure Pipelines template to correctly build in OneBranch (Microsoft's **internal** Azure Pipelines sandbox).

# Example

With these helpers, new `vcxproj` files can be easily created, understood and maintained by a human. The following is an example for `myapp.exe`.

```xml
﻿<?xml version="1.0" encoding="utf-8"?>
<Project DefaultTargets="Build" xmlns="http://schemas.microsoft.com/developer/msbuild/2003">
  <PropertyGroup>
    <ProjectGuid>{4b452093-0ce2-4305-811a-06573ccab3c5}</ProjectGuid>
    <TargetName>myapp</TargetName>
    <UndockedType>exe</UndockedType>
  </PropertyGroup>
  <Import Project="$(UndockedDir)vs\windows.undocked.props" />
  <ItemGroup>
    <ClCompile Include="main.c" />
    <ResourceCompile Include="myapp.rc" />
  </ItemGroup>
  <Import Project="$(UndockedDir)vs\windows.undocked.targets" />
</Project>
```

## Usage

To use this project in your component, you must:

#### Get Local Build Working

1. Submodule this repository into your component's repository.
1. Create a `version.json` file to hold your component's version (see [example](templates/version.json)).
1. Update your component's project files to set the undocked variables (see [examples](templates)).
1. Import [windows.undocked.props](vs/windows.undocked.props).

#### Get OneBranch Build Working

1. Copy the `.azure` directory into your project.
1. Update the `OneBranch.*.yml` files as necessary for your project.
1. Onboard these new pipelines to OneBranch.
   - Requires a [service connection](https://learn.microsoft.com/en-us/azure/devops/pipelines/library/service-endpoints?view=azure-devops&tabs=yaml#azure-repos) to GitHub (name it `Undocked GitHub`).

> **Note** - As mentioned above, OneBranch is an internal to Microsoft build environment. If you are not a Microsoft employee, you will not be able to use these pipelines. You can, however, still leverage the property file to build locally.

## Contributing

This project welcomes contributions and suggestions.  Most contributions require you to agree to a Contributor License Agreement (CLA) declaring that you have the right to, and actually do, grant us the rights to use your contribution. For details, visit https://cla.opensource.microsoft.com.

When you submit a pull request, a CLA bot will automatically determine whether you need to provide a CLA and decorate the PR appropriately (e.g., status check, comment). Simply follow the instructions provided by the bot. You will only need to do this once across all repos using our CLA.

This project has adopted the [Microsoft Open Source Code of Conduct](https://opensource.microsoft.com/codeofconduct/). For more information see the [Code of Conduct FAQ](https://opensource.microsoft.com/codeofconduct/faq/) or contact [opencode@microsoft.com](mailto:opencode@microsoft.com) with any additional questions or comments.

## Trademarks

This project may contain trademarks or logos for projects, products, or services. Authorized use of Microsoft trademarks or logos is subject to and must follow
[Microsoft's Trademark & Brand Guidelines](https://www.microsoft.com/en-us/legal/intellectualproperty/trademarks/usage/general). Use of Microsoft trademarks or logos in modified versions of this project must not cause confusion or imply Microsoft sponsorship. Any use of third-party trademarks or logos are subject to those third-party's policies.
