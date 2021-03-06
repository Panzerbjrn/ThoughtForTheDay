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
	ModuleVersion = '1.0'

	# ID used to uniquely identify this module
	GUID = '36b7ffea-5c51-4b38-8ec6-c4c17398a46a'

	# Author of this module
	Author = 'Lars Panzerbjørn'

	# Company or vendor of this module
	CompanyName = 'Ordo Ursus'

	# Copyright statement for this module
	Copyright = '(c) 2020 lars.petersson. All rights reserved.'

	# Description of the functionality provided by this module
	Description = 'Provides a bit of daily wisdom'

	# Minimum version of the Windows PowerShell engine required by this module
	PowerShellVersion = '3.0'

	# Functions to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no functions to export.
	FunctionsToExport = '*'

	# Cmdlets to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no cmdlets to export.
	CmdletsToExport = '*'

	# Variables to export from this module
	VariablesToExport = '*'

	# Aliases to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no aliases to export.
	AliasesToExport = '*'

	# Private data to pass to the module specified in RootModule/ModuleToProcess. This may also contain a PSData hashtable with additional module metadata used by PowerShell.
	PrivateData = @{
		PSData = @{
			# Tags applied to this module. These help with module discovery in online galleries.
			Tags = @('Wisdom','TFTD','Thought For The Day','Stoics','Stoicism')
		} # End of PSData hashtable
	} # End of PrivateData hashtable

}