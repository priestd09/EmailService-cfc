<cfcomponent name="EmailGateway" displayname="Email Gateway" output="false" hint="Generic Gateway object">

	<cffunction name="init" access="public" returntype="any" output="false" hint="Initializes the Gateway">
		<cfargument name="datasource" type="string" required="true">
		<cfset variables.datasource = arguments.datasource>
	</cffunction>

</cfcomponent>