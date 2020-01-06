#region Script Header
#	Thought for the day:
#	NAME: ThoughtForTheDay.psm1
#	AUTHOR: Lars Panzerbjrn
#	CONTACT: GitHub: Panzerbjrn / Twitter: Panzerbjrn
#	DATE: 2019.10.01
#
#	SYNOPSIS:
#	Provides a bit of daily wisdom
#
#	DESCRIPTION:
#	Provides a bit of daily wisdom
#
#	REQUIREMENTS:
#
#endregion Script Header

#Requires -Version 3.0

[CmdletBinding()]
param()

Write-Verbose $PSScriptRoot

#Get Functions and Helpers function definition files.
$Functions	= @( Get-ChildItem -Path $PSScriptRoot\Functions\*.ps1 -ErrorAction SilentlyContinue )
#$Helpers = @( Get-ChildItem -Path $PSScriptRoot\Helpers\*.ps1 -ErrorAction SilentlyContinue )

#Dot source the files
ForEach ($Import in @($Functions))
{
	Try
	{
		. $Import.Fullname
	}
	Catch
	{
		Write-Error -Message "Failed to Import function $($Import.Fullname): $_"
	}
}

Export-ModuleMember -Function $Functions.Basename

