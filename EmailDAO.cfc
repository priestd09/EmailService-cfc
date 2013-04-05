<cfcomponent name="EmailDAO" displayname="Email DAO" output="false" hint="Generic DAO object">

	<cffunction name="init" access="public" returntype="any" output="false" hint="Initializes the DAO">
		<cfargument name="datasource" type="string" required="true">
		<cfset variables.datasource = arguments.datasource>
	</cffunction>

</cfcomponent>