#
# Module manifest for module 'ThoughtForTheDay'
#
# Generated by: lars.petersson
#
# Generated on: 03/01/2020
#

@{
	# Script module or binary module file associated with this manifest.
	RootModule = 'ThoughtForTheDay.psm1'

	# Version number of this module.
	ModuleVersion = '1.0.1'

	# ID used to uniquely identify this module
	GUID = '36b7ffea-5c51-4b38-8ec6-c4c17398a46a'

	# Author of this module
	Author = 'Lars Panzerbjørn'

	# Company or vendor of this module
	CompanyName = 'Ordo Ursus'

	# Copyright statement for this module
	Copyright = '(c) 2019 Lars Panzerbjørn. All rights reserved.'

	# Description of the functionality provided by this module
	Description = 'Provides a bit of daily wisdom'

	# Minimum version of the Windows PowerShell engine required by this module
	PowerShellVersion = '3.0'

	# Functions to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no functions to export.
	FunctionsToExport = '*'

	# Cmdlets to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no cmdlets to export.
	CmdletsToExport = @()

	# Aliases to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no aliases to export.
	AliasesToExport = @()

	# Private data to pass to the module specified in RootModule/ModuleToProcess. This may also contain a PSData hashtable with additional module metadata used by PowerShell.
	PrivateData = @{
		PSData = @{

			# Tags applied to this module. These help with module discovery in online galleries.
			Tags = @('Wisdom','TFTD','ThoughtForTheDay','Stoics','Stoicism','Panzerbjrn')

			# A URL to the license for this module.
			# LicenseUri = ''

			# A URL to the main website for this project.
			ProjectUri = 'https://github.com/Panzerbjrn/ThoughtForTheDay'

			# A URL to an icon representing this module.
			# IconUri = ''

			# ReleaseNotes of this module
			# ReleaseNotes = ''

			# Prerelease string of this module
			# Prerelease = ''

			# Flag to indicate whether the module requires explicit user acceptance for install/update/save
			# RequireLicenseAcceptance = $false

			# External dependent modules of this module
			# ExternalModuleDependencies = @()

		} # End of PSData hashtable

	} # End of PrivateData hashtable

	# HelpInfo URI of this module
	# HelpInfoURI = ''

	# Default prefix for commands exported from this module. Override the default prefix using Import-Module -Prefix.
	# DefaultCommandPrefix = ''

}
