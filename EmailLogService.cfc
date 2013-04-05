<cfcomponent name="EmailLogService" displayname="Email Log Service" output="false" hint="I provide functions for logging email.">

	<cffunction name="init" access="public" output="false" returntype="any" hint="I initialize the component">
		<cfargument name="datasource" type="string" required="true" hint="I am the datasource.">
		<cfset variables.datasource = arguments.datasource>
		<cfreturn this>
	</cffunction>

	<cffunction name="logEmail" access="private" returntype="boolean" output="false" hint="I log the email being sent.">
    	<cfargument name="datasource" type="string" required="false" default="#variables.datasource#" hint="I am the datasource.">
		<cfargument name="emailtemplateid" type="numeric" required="false" default="0" hint="I am the email template id to use for getting the properties of the email. This is currently unsupported." />
		<cfargument name="templatecode" type="string" required="false" default="" hint="I am the template code to filter email template results." />
		<cfargument name="emailfromid" type="string" required="false" default="" hint="I am the ID of the email sender.">
		<cfargument name="emailrecipientid" type="string" required="false" default="" hint="I am the ID of the email recipient.">
		<cfargument name="emailreplytoaddress" type="string" required="false" default="" hint="I am the email address for which to reply." />
		<cfargument name="emailfrom" type="string" required="false" default="" hint="I am the sender (email and name [if applicable]) of the sender." />
		<cfargument name="emailtoaddress" type="string" required="false" default="" hint="I am the 'to' email recipient." />
		<cfargument name="emailccaddress" type="string" required="false" default="" hint="I am the 'cc' email recipient." />
		<cfargument name="emailbccaddress" type="string" required="false" default="" hint="I am the 'bcc' email recipient." />
		<cfargument name="emailsubject" type="string" required="false" default="" hint="I am the subject of the email." />
		<cfargument name="emailbodyhtml" type="string" required="false" default="" hint="I am the HTML version of the email body." />
		<cfargument name="emailbodyplaintext" type="string" required="false" default="" hint="I am the plain text version of the email body." />
		<cfargument name="mode" type="string" required="false" default="live" hint="I determine if the email is live or a test.">
		
    	<cfset var local = {}>

    	<cftry>
			<cfquery name="local.qiEmailMessageLog" datasource="#arguments.datasource#">
				INSERT INTO dbo.EmailMessageLog
				(
					EmailTemplateID
					, EmailFromID
					, EmailRecipientID
					, EmailReplyToAddress
					, EmailFrom
					, EmailToAddress
					, EmailBCCAddress
					, EmailCCAddress
					, EmailSubject
					, EmailBodyHTML
					, EmailBodyPlainText
					, Mode
				)
				VALUES
				(
					<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.emailtemplateid#">
					, <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.emailfromid#" null="#(NOT len(trim(arguments.emailfromid)))#">
					, <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.emailrecipientid#" null="#(NOT len(trim(arguments.emailrecipientid)))#">
					, <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.emailreplytoaddress#" null="#(NOT len(trim(arguments.emailreplytoaddress)))#">
					, <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.emailfrom#" null="#(NOT len(trim(arguments.emailfrom)))#">
					, <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.emailtoaddress#" null="#(NOT len(trim(arguments.emailtoaddress)))#">
					, <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.emailbccaddress#" null="#(NOT len(trim(arguments.emailbccaddress)))#">
					, <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.emailccaddress#" null="#(NOT len(trim(arguments.emailccaddress)))#">
					, <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.emailsubject#" null="#(NOT len(trim(arguments.emailsubject)))#">
					, <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.emailbodyhtml#" null="#(NOT len(trim(arguments.emailbodyhtml)))#">
					, <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.emailbodyplaintext#" null="#(NOT len(trim(arguments.emailbodyplaintext)))#">
					, <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.mode#" null="#(NOT len(trim(arguments.mode)))#">
				)
			</cfquery>
			<cfset local.returnobject = true>
    		<cfcatch type="any">
    			<cfset local.returnobject = false>
    		</cfcatch>
    	</cftry>

    	<cfreturn local.returnobject>
    </cffunction>

	<cffunction name="onMissingMethod" hint="I catch it if someone passes in a bad method name">
		<cfargument name="missingMethodName" type="string">
	    <cfargument name="missingMethodArguments" type="struct">

	</cffunction>
</cfcomponent>