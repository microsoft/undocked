<#

.SYNOPSIS
Generates the necessary files for creating a PR into Windows.

#>

param (
    [Parameter(Mandatory = $true)]
    [string]$Name,              # i.e., ping

    [Parameter(Mandatory = $true)]
    [string]$Description,       # i.e., Windows Ping.exe Tool

    [Parameter(Mandatory = $true)]
    [string]$Repo,              # i.e., https://mscodehub.visualstudio.com/windows-ping/_git/windows-ping

    [Parameter(Mandatory = $true)]
    [string]$Branch,            # i.e., refs/heads/main

    [Parameter(Mandatory = $true)]
    [string]$Commit,            # i.e., 86962396b541a6540a67827fcedf3c456b59b140

    [Parameter(Mandatory = $true)]
    [string]$Owner,             # i.e., cnsdev

    [Parameter(Mandatory = $true)]
    [string]$BuildPipelineId,   # i.e., 315566

    [Parameter(Mandatory = $true)]
    [string]$OsPath,            # i.e., onecore/net/tcpip/commands/ping/vpack

    [Parameter(Mandatory = $true)]
    [string]$OsBranch,          # i.e., official/rs_onecore_liof1_stack

    [Parameter(Mandatory = $true)]
    [string]$OsPrTitle,         # i.e., Automated: Ingest Ping

    [Parameter(Mandatory = $true)]
    [string]$OutDir            # i.e., build
)

Set-StrictMode -Version "Latest";
$PSDefaultParameterValues["*:ErrorAction"] = "Stop";

$Project = $Repo.Substring(0, $Repo.IndexOf("/_git"))

if ($Branch.StartsWith("refs/heads/")) {
    $Branch = $Branch.Substring(11) # Remove the 'refs/heads/' prefix.
} elseif ($Branch.StartsWith("refs/pull/")) {
    $Branch = "main" # Pull requests are assumed to be 'main' branch.
}

$Ver = Get-Content -Raw version.json | ConvertFrom-Json
$Version = "$($Ver.major).$($Ver.minor).$($Ver.patch)-$BuildPipelineId"
$OsPrTitle = "$OsPrTitle ($Version)"

class CheckinFile {
    [string]$Source;
    [string]$Path;
    [string]$Type = "File";
    CheckinFile($Name, $OsPath) {
        $this.Source = "$Name.man";
        $this.Path = $OsPath;
    }
}

class CheckinBranch {
    [string]$collection = "microsoft"
    [string]$project = "OS"
    [string]$repo = "os.2020"
    [string]$name;
    [string]$completePR = "False"
    [string]$pullRequestTitle;
    [CheckinFile[]]$CheckinFiles;
    CheckinBranch($Name, $OsPath, $OsBranch, $OsPrTitle) {
        $this.name = $OsBranch;
        $this.pullRequestTitle = $OsPrTitle;
        $this.CheckinFiles = @([CheckinFile]::new($Name, $OsPath));
    }
}

class GitCheckin {
    [CheckinBranch[]]$Branch;
    GitCheckin($Name, $OsPath, $OsBranch, $OsPrTitle) {
        $this.Branch = @([CheckinBranch]::new($Name, $OsPath, $OsBranch, $OsPrTitle));
    }
}

$Manifest = @"
### StartMeta
# Manifest_Format_Version=2
### EndMeta

// Description: REPLACE_WITH_DESCRIPTION (REPLACE_WITH_PROJECT)
// The following metadata comments are used for ingesting the latest version
// METADATA_SOURCE_BRANCH: REPLACE_WITH_BRANCH
// METADATA_COMMIT: REPLACE_WITH_REPO/commit/REPLACE_WITH_COMMIT_HASH
// METADATA_BUILD_PIPELINE: REPLACE_WITH_PROJECT/_build/results?buildId=REPLACE_WITH_BUILD_ID&view=results
// Owner: REPLACE_WITH_OWNER
REPLACE_WITH_NAME.`$(Platform),[REPLACE_WITH_VERSION],Drop,CollectionOfFiles,https://microsoft.artifacts.visualstudio.com/DefaultCollection/,,`$(Destination)
"@

$Manifest = $Manifest.Replace("REPLACE_WITH_NAME", $Name)
$Manifest = $Manifest.Replace("REPLACE_WITH_DESCRIPTION", $Description)
$Manifest = $Manifest.Replace("REPLACE_WITH_PROJECT", $Project)
$Manifest = $Manifest.Replace("REPLACE_WITH_REPO", $Repo)
$Manifest = $Manifest.Replace("REPLACE_WITH_BRANCH", $Branch)
$Manifest = $Manifest.Replace("REPLACE_WITH_COMMIT_HASH", $Commit)
$Manifest = $Manifest.Replace("REPLACE_WITH_VERSION", $Version)
$Manifest = $Manifest.Replace("REPLACE_WITH_OWNER", $Owner)
$Manifest = $Manifest.Replace("REPLACE_WITH_BUILD_ID", $BuildPipelineId)

mkdir $OutDir -ErrorAction Ignore | Out-Null

$Manifest | Out-File "$OutDir/$($Name).man"
Write-Output "`n$($Name).man:`n"
Write-Output $Manifest

$Checkin = [GitCheckin]::new($Name, $OsPath, $OsBranch, $OsPrTitle) | ConvertTo-Json -Depth 100
$Checkin | Out-File "$OutDir/GitCheckin.json"
Write-Output "`nGitCheckin.json:`n"
Write-Output $Checkin
